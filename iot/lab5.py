# step 1
import network 

def connect_to_wifi(ssid = 'Password nahi dunga', password = 'qqqqqqqq'): 
    # Configure WiFi using Station Interface 
    wlan = network.WLAN(network.STA_IF) 
    wlan.active(True) 
    if not wlan.isconnected(): 
        print('Connecting to network...') 
        wlan.connect(ssid, password) 
        while not wlan.isconnected(): 
            pass 
    print('Network config:', wlan.ifconfig()) 
    return(wlan) 

if __name__ == '__main__':
    try: 
        connect_to_wifi() 
    except (Exception, KeyboardInterrupt) as e: 
        try: 
            from utility import print_error_msg 
            print_error_msg(e) 
        except ImportError: 
            print("Unable to import utility module") 
            
# step 2
import mip 
mip.install("aioble", target="/flash/libs") 

# step 3
import aioble 
import uasyncio as asyncio 
import bluetooth 
import esp32 
from time import time 
 
# Random UUID from https://www.uuidgenerator.net/version4 
service_uuid = bluetooth.UUID("6bf04b06-af26-407f-ab10-cd478aeb9226") 
read_characteristic_uuid = bluetooth.UUID( 
    "3dba0950-1c03-4a77-959f-bbc5414ff3ff") 
write_characteristic_uuid = bluetooth.UUID( 
    "a4c184a8-7b5b-4e0d-a135-5c27cfa0a7db") 
 
# Advertisement interval 
_ADV_INTERVAL_MS = 250_000 
 
initTime = time() 
 
myService = aioble.Service(service_uuid) 
 
# Clients would be able to read this Characteristic.  
# They are also notified of changes. 
read_characteristic = aioble.Characteristic( 
    myService, read_characteristic_uuid, read=True, notify=True) 
 
# Clients would be able to over-write this Characteristic. 
write_characteristic = aioble.Characteristic( 
    myService, write_characteristic_uuid, read=True, write=True, notify=True) 
 
aioble.register_services(myService) 
 
async def sensor_task(): 
    try: 
        while True: 
            t = f"{time()-initTime}s : {(esp32.raw_temperature()-32)/1.8} deg C" 
            print("Temp "+t) 
            read_characteristic.write(t, True) 
            await asyncio.sleep_ms(3000) 
    except: 
        print("Exception in the Sensor Task") 
 
async def notif_task(): 
    try: 
        while True: 
            await write_characteristic.written() 
            t = write_characteristic.read() 
            print("Recieved: ", t) 
    except: 
        print("Exception in the Notification Task") 
 
async def peripheral_task(): 
    while True: 
        try: 
            while True: 
                async with await aioble.advertise(_ADV_INTERVAL_MS,  
                                                  name="ESP32-Device", 
                                                  services=[service_uuid]) as connection: 
                    print("Connection from", connection.device) 
                    await connection.disconnected(timeout_ms=None) 
                    print("Disconnected from", connection.device) 
        except: 
            print("Exception in the Peripheral Task") 
 
async def main(): 
    try: 
        t1 = asyncio.create_task(sensor_task()) 
        t2 = asyncio.create_task(notif_task()) 
        t3 = asyncio.create_task(peripheral_task()) 
        await asyncio.gather(t1, t2, t3) 
    except: 
        print("Exception in the Main Task") 
 
try: 
    asyncio.run(main()) 
except Exception as e: 
    print(f'Failed with: {e}') 
    raise e 