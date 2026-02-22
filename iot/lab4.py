import network 
import time 
from umqtt.simple import MQTTClient 
import ubinascii 
import random 
import machine 
 
 
SSID = 'ssid'
PASSWORD = 'pass'
SERVER = "ip address of your MQTT broker" 
CLIENT_ID = ubinascii.hexlify(machine.unique_id()) 
PUBLISH_TOPIC = b"iot/loc0/temperature" 
SUBSCRIBE_TOPIC = b"iot/loc0/server" 
 
def connect_to_wifi(ssid, password): 
    # Configure WiFi using Station Interface 
    wlan = network.WLAN(network.STA_IF) 
    wlan.active(True) 
    if not wlan.isconnected(): 
        print('Connecting to network...') 
        wlan.connect(ssid, password) 
        while not wlan.isconnected(): 
            pass 
    print('Network config:', wlan.ifconfig()) 
    return (wlan) 
 
def subscribe_callback(topic, msg): 
    print("Received: "+str((topic, msg))) 
 
if __name__ == '__main__': 
    try: 
        wlan = connect_to_wifi(SSID, PASSWORD) 
        if SERVER == "0.0.0.0": 
            SERVER = wlan.ifconfig()[2] 
        c = MQTTClient(CLIENT_ID, SERVER) 
        c.connect() 
        print("Connected to %s" % SERVER) 
        c.set_callback(subscribe_callback) 
        c.subscribe(SUBSCRIBE_TOPIC) 
        for k in range(1000): 
            v = str(random.randint(250, 350)/10) 
            c.check_msg() 
            c.publish(PUBLISH_TOPIC, v) 
            print("Published %s at %ds" % (v, k)) 
            time.sleep(1) 
        c.disconnect() 
    except (Exception, KeyboardInterrupt) as e: 
        try: 
            from utility import print_error_msg 
            print_error_msg(e) 
        except ImportError: 
            print("Unable to import utility module") 
    finally: 
        c.disconnect() 