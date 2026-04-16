import network
import time
from config import WIFI_SSID, WIFI_PASSWORD

wlan = network.WLAN(network.STA_IF)

def connect_wifi(timeout_s=20):
    if wlan.isconnected():
        return wlan.ifconfig()[0]

    wlan.active(True)

    if not wlan.isconnected():
        print("Connecting to Wi-Fi:", WIFI_SSID)
        wlan.connect(WIFI_SSID, WIFI_PASSWORD)

        start = time.time()
        while not wlan.isconnected():
            if time.time() - start > timeout_s:
                raise Exception("Wi-Fi connection timed out")
            time.sleep(1)

    ip = wlan.ifconfig()[0]
    print("Wi-Fi connected")
    print("IP:", ip)
    return ip

def get_ip():
    if wlan.isconnected():
        return wlan.ifconfig()[0]
    return None