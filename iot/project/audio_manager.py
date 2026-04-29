import os
import time
import M5

# Initialize the M5 unified hardware system
M5.begin()

def init_sd():
    print('initialising sd')
    try:
        # Check if the system already mounted the SD card automatically
        if "sd" in os.listdir("/"):
            print("SD card is already mounted by the system.")
            return

        # If not, try mounting it manually
        from machine import SDCard, Pin
        sd = SDCard(slot=2, sck=Pin(18), mosi=Pin(23), miso=Pin(38), cs=Pin(4))
        os.mount(sd, "/sd")
        print("SD card mounted manually.")

    except Exception as e:
        print("SD mount failed:", e)

def init_mic():
    try:
        M5.Mic.begin()
        M5.Mic.setSampleRate(16000)
        print("M5.Mic initialized with hardware PDM filter")
    except Exception as e:
        print("Mic setup failed:", e)

def record_audio(record_seconds=2):
    filename = "/sd/pump_{}.raw".format(time.ticks_ms())
    
    # 16000 samples/sec * 2 bytes/sample (16-bit mono)
    bytes_per_sec = 32000
    chunk_size = 1024
    iterations = int((bytes_per_sec * record_seconds) / chunk_size)
    
    buf = bytearray(chunk_size)
    
    try:
        print("Recording {} seconds using M5.Mic...".format(record_seconds))
        with open(filename, "wb") as f:
            for _ in range(iterations):
                # Required by M5 hardware library to keep background tasks alive
                M5.update() 
                
                # record() automatically applies the PDM filter and outputs clean PCM audio
                # Parameters: (buffer, sample_rate, stereo=False)
                success = M5.Mic.record(buf, 16000, False) 
                
                if success:
                    f.write(buf)
                else:
                    # Small yield if the DMA buffer wasn't ready
                    time.sleep_ms(2) 

        print("Recording complete:", filename)
        return filename

    except Exception as e:
        print("Recording error:", e)
        return None

def send_for_analysis(filename, server_ip):
    import requests 
    url = "http://{}:5000/analyze".format(server_ip)
    
    try:
        print("Sending to AI Server...")
        with open(filename, "rb") as f:
            audio_data = f.read()
            
        # Send raw bytes to the Flask server
        response = requests.post(
            url, 
            data=audio_data, 
            headers={"Content-Type": "application/octet-stream"}
        )
        
        result = response.json()
        response.close()
        print("Server says:", result["status"])
        return result["status"]
        
    except Exception as e:
        print("Failed to reach server:", e)
        return "error"