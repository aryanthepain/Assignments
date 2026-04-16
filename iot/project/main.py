# from controller import init_controller
# from wifi_manager import connect_wifi
# from web_server import start_server, serve_forever

# print("Booting smart irrigation controller...")

# init_controller()
# ip = connect_wifi()

# print("Open this in your browser:")
# print("http://{}/".format(ip))

# server = start_server()
# serve_forever(server)

from machine import I2S, Pin, SDCard
import os
import time

print("Root:", os.listdir("/"))
print("Flash:", os.listdir("/flash"))

# -----------------------
# Mount SD Card
# -----------------------
try:
    sd = SDCard()
    os.mount(sd, "/sd")
    print("SD card mounted successfully")
    print("SD contents:", os.listdir("/sd"))
except Exception as e:
    print("SD mount failed:", e)

# -----------------------
# I2S Mic Setup
# -----------------------
audio_in = I2S(
    0,
    sck=Pin(12),
    ws=Pin(0),
    sd=Pin(2),
    mode=I2S.RX,
    bits=16,
    format=I2S.MONO,
    rate=16000,
    ibuf=4096
)

# -----------------------
# Record Function
# -----------------------
def record(seconds=5):
    buf = bytearray(1024)

    # Unique filename (no overwrite)
    filename = "/sd/pump_{}.raw".format(time.ticks_ms())

    try:
        with open(filename, "wb") as f:
            print("Recording to SD card...")

            for _ in range(int(16000 / 512 * seconds)):
                num_bytes = audio_in.readinto(buf)

                if num_bytes > 0:
                    f.write(buf[:num_bytes])

        print("Recording complete")
        print("Saved file:", filename)

    except Exception as e:
        print("Recording error:", e)

# -----------------------
# Run
# -----------------------
record(5)