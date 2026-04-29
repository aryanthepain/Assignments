from machine import I2S, Pin, SDCard
import os
import time
from config import MIC_SCK_PIN, MIC_WS_PIN, MIC_SD_PIN, RECORD_SECONDS

audio_in = None

def init_sd():
    try:
        sd = SDCard()
        os.mount(sd, "/sd")
        print("SD card mounted successfully")
        print("SD contents:", os.listdir("/sd"))
    except Exception as e:
        print("SD mount failed:", e)

def init_mic():
    global audio_in
    try:
        audio_in = I2S(
            0,
            sck=Pin(MIC_SCK_PIN),
            ws=Pin(MIC_WS_PIN),
            sd=Pin(MIC_SD_PIN),
            mode=I2S.RX,
            bits=16,
            format=I2S.MONO,
            rate=16000,
            ibuf=4096
        )
        print("Microphone initialized")
    except Exception as e:
        print("Mic setup failed:", e)

def record_audio():
    if audio_in is None:
        print("Microphone not initialized")
        return None

    buf = bytearray(1024)
    filename = "/sd/pump_{}.raw".format(time.ticks_ms())

    try:
        print("Recording {} seconds to SD card...".format(RECORD_SECONDS))
        # 16000 sample rate * 2 bytes (16-bit) = 32000 bytes per second
        # We read 1024 bytes per iteration
        iterations = int((16000 * 2 * RECORD_SECONDS) / 1024)
        
        with open(filename, "wb") as f:
            for _ in range(iterations):
                num_bytes = audio_in.readinto(buf)
                if num_bytes > 0:
                    f.write(buf[:num_bytes])

        print("Recording complete:", filename)
        return filename

    except Exception as e:
        print("Recording error:", e)
        return None