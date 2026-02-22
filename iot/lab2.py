# lab2.py
# Author - Aryan Gupta

import M5      # Device specific library 
import time    # Standard Library 
 
def setup():   # This function will run only once (Why?) 
  M5.begin()                       # Initialize hardware 
  M5.Display.setBrightness(50)     # Set Screen Brightness 
  M5.Display.fillScreen(0xff0000)  # Fill screen with colour 
  print("Initialized!") 
 
def loop():    # This function will run repeatedly (Why?) 
  M5.update()  # Poll for hardware updates 
  print(time.time()," : Main Application Loop!") 
 
if __name__ == '__main__':        # Run only if the file is run as a script 
  try: 
    setup() 
    while True: 
      loop() 
      time.sleep_ms(500)          # Sleep for 500 milliseconds 
  except (Exception, KeyboardInterrupt) as e: 
    try: 
      from utility import print_error_msg    # Hardware specific library 
      print_error_msg(e) 
    except ImportError: 
      print("Unable to import utility module") 
      
# part 2

import M5 
from M5 import Widgets, BtnA, BtnB, BtnC 
 
# Global variables 
title0 = None 
rect0 = None 
image0 = None 
counterLabel = None 
counterValue = None 
touchLabel = None 
touchValue = None 
accelLabel = None 
accelValue = None 
gyroLabel = None 
gyroValue = None 
count = 0 
dirty = False 
widgetsList=[] 
 
def drawShapes(): # Draw some shapes and QR 
    global dirty 
    M5.Display.fillCircle(50,200,10,0xff0000)           #(cX,cY,R,HEX) 
    M5.Display.drawRect(50,200,50,20,0xffff00)          #(X,Y,W,H,HEX) 
    M5.Display.drawRoundRect(50,150,50,20,5,0xffff00)   #(X,Y,W,H,R,HEX) 
    M5.Display.fillRect(150,200,50,20,0xffff00)         #(X,Y,W,H,HEX) 
    M5.Display.drawQR("Hello World!",220,30,100,1)      #(Text,X,Y,W,Ver) 
    M5.Display.drawEllipse(50,150,10,20,0xffff00)       #(cX,cY,rX,rY,HEX) 
    dirty=False 
 
def showAll(): # Refresh all widgets 
  global widgetsList 
  for k in widgetsList: 
    k.setVisible(True) 
  drawShapes() 
 
def getTouchXY(): # Get touch coordinates 
  X = M5.Touch.getX() 
  Y = M5.Touch.getY() 
  return str([X, Y]) 
 
def getAccelXYZ(): # Get Accelerometer readings 
  R=M5.Imu.getAccel() 
  return f"{R[0]:.1f},{R[1]:.1f},{R[2]:.1f}" 
 
def getGyroXYZ(): # Get Gyroscope readings 
  R=M5.Imu.getGyro() 
  return f"{R[0]:.1f},{R[1]:.1f},{R[2]:.1f}"

def btnA_wasReleased_event(state):
    Widgets.fillScreen(0x000000) 
    for k in widgetsList[3:]: 
        k.setColor(0xffffff, 0x000000) 
    showAll() 
    M5.Speaker.tone(5000,50) 
 
def btnC_wasReleased_event(state): 
  Widgets.fillScreen(0xffffff) 
  for k in widgetsList[3:]: 
    k.setColor(0x000000, 0xffffff) 
  showAll() 
  M5.Speaker.tone(5000,50) # (Frequency, Time in ms) 
 
def btnB_wasReleased_event(state): 
  global count, dirty 
  count = count + 1 
  counterValue.setText(str(str(count))) 
  if dirty: 
    btnA_wasReleased_event(None) 
  if count>1 and count%5==0:            # Text mode demo 
    M5.Display.clear(0) 
    M5.Display.setCursor(0,0) 
    M5.Display.setTextScroll(True) 
    M5.Display.setTextColor(0xffff00) 
    M5.Display.setFont(M5.Display.FONTS.DejaVu18) 
    for k in range(25): 
        M5.Display.print("Middle button pressed "+str(count)+" times!\n") 
    dirty=True 
 
def setup(): 
  global title0, counterLabel, rect0, image0, counterValue 
  global touchLabel, touchValue, count, accelLabel 
  global accelValue, gyroLabel, gyroValue, widgetsList 
 
  M5.begin() 
  Widgets.fillScreen(0x222222) 
  M5.Speaker.setVolume(100) 
  # Title(str,offset,BackCol,TextCol,font) 
  title0 = Widgets.Title("IoT Lab - 2", 25,  
                         0xffffff, 0x0000FF,  
                         Widgets.FONTS.DejaVu24)  
 
  # Rectangle(X,Y,W,H,borderCol,fillColor) 
  rect0 = Widgets.Rectangle(270, 190, 50, 50, 0xff0000, 0x767676) 
 
  # Image(file,X,Y) 
  image0 = Widgets.Image("res/img/default.png", 1, 208) 
 
  # Label(str,X,Y,scale,TextCol,BackCol,font) 
  counterLabel = Widgets.Label("Count:", 10, 30,  
                               1.0, 0xffffff, 0x222222,  
                               Widgets.FONTS.DejaVu12)   
  counterValue = Widgets.Label("---", 80, 30,  
                               1.0, 0xffff00, 0x000000,  
                               Widgets.FONTS.DejaVu12) 
  touchLabel = Widgets.Label("Touch:", 10, 50,  
                             1.0, 0xffffff, 0x222222,
                             Widgets.FONTS.DejaVu12) 
  touchValue = Widgets.Label("---", 80, 50,  
                             1.0, 0xffffff, 0x222222,  
                             Widgets.FONTS.DejaVu12) 
  accelLabel = Widgets.Label("Accel:", 10, 70,  
                             1.0, 0xffffff, 0x222222,  
                             Widgets.FONTS.DejaVu12) 
  accelValue = Widgets.Label("---", 80, 70,  
                             1.0, 0xffffff, 0x222222,  
                             Widgets.FONTS.DejaVu12)   
  gyroLabel = Widgets.Label("Gyro :", 10, 90,  
                             1.0, 0xffffff, 0x222222,  
                             Widgets.FONTS.DejaVu12) 
  gyroValue = Widgets.Label("---", 80, 90,  
                             1.0, 0xffffff, 0x222222,  
                             Widgets.FONTS.DejaVu12) 
 
  widgetsList=[title0, rect0, image0, 
               counterLabel,counterValue, 
               touchLabel,touchValue,  
               accelLabel,accelValue, 
               gyroLabel,gyroValue] 
 
  # Callback on button releases 
  BtnA.setCallback(type=BtnA.CB_TYPE.WAS_RELEASED,  
                   cb=btnA_wasReleased_event) 
  BtnC.setCallback(type=BtnC.CB_TYPE.WAS_RELEASED,  
                   cb=btnC_wasReleased_event) 
  BtnB.setCallback(type=BtnB.CB_TYPE.WAS_RELEASED,  
                   cb=btnB_wasReleased_event) 
 
  # Initialize counter 
  count = 0 
  counterValue.setText(str(count)) 
  touchValue.setText(str(count)) 
  drawShapes() 
 
def loop(): 
  M5.update() 
  if M5.Touch.getCount()>0: # If screen is touched 
    if dirty: # If screen is showing garbage 
      btnA_wasReleased_event(None) 
    touchValue.setText(getTouchXY()) 
    accelValue.setText(getAccelXYZ()) 
    gyroValue.setText(getGyroXYZ()) 
 
if __name__ == '__main__': 
  try: 
    setup() 
    while True: 
      loop() 
  except (Exception, KeyboardInterrupt) as e: 
    try: 
      from utility import print_error_msg 
      print_error_msg(e) 
    except ImportError: 
      print("please update to latest firmware") 
      
# part 3 - network
import network 
import machine 
import ntptime 
import utime 
import time 
import M5 
from M5 import Widgets 
 
title0 = None 
timeLabel = None 
wifi_ssid = ''        # Replace with your WiFi SSID 
wifi_password = '' # Replace with your WiFi Password
 
def getInternetTime(): 
    ntptime.timeout=30      # NTP server timeout 
    ntptime.settime()       # Get internet time 
    t = utime.localtime(utime.mktime(utime.localtime()) + 19800)  # IST  
    # Set Real time clock to follow IST  
    machine.RTC().datetime((t[0], t[1], t[2], 0, t[3], t[4], t[5], 0))  
 
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
    return(wlan) 
 
def setup():
    global title0, timeLabel 
 
    M5.begin() 
    Widgets.fillScreen(0x222222) 
    
    title0 = Widgets.Title("IoT Lab - 2 - Internet Time", 25,  
                            0xffffff, 0x0000FF,  
                            Widgets.FONTS.DejaVu18)  
    
    # Label(str,X,Y,scale,TextCol,BackCol,font) 
    timeLabel = Widgets.Label("Initializing", 10, 50,  
                                1.0, 0xffffff, 0x222222,  
                                Widgets.FONTS.DejaVu18) 
    timeLabel_net = Widgets.Label("Initializing", 10, 60,  
                                1.0, 0xffffff, 0x222222,  
                                Widgets.FONTS.DejaVu18) 
    connect_to_wifi(wifi_ssid, wifi_password) 
    getInternetTime() 
    print(utime.localtime()) 
 
def loop(): 
  M5.update() 
  T=utime.localtime() 
  S=f"{T[3]:02d}:{T[4]:02d}:{T[5]:02d} {T[2]}/{T[1]}/{T[0]} IST" 
  timeLabel.setText(S) 
  time.sleep_ms(500) 
 
if __name__ == '__main__': 
  try: 
    setup() 
    while True: 
      loop() 
  except (Exception, KeyboardInterrupt) as e: 
    try: 
      from utility import print_error_msg 
      print_error_msg(e) 
    except ImportError: 
      print("Unable to import utility module") 
      
# part 4 - create countdown timer
import M5
from M5 import Widgets, BtnB
import time

def btnB_wasReleased_event(state):
    countdown = 5

    start = time.time()  # Initialize time module
    end = start + countdown

    M5.begin() 
    Widgets.fillScreen(0x222222) 
    M5.Speaker.setVolume(100) 

    # Title(str,offset,BackCol,TextCol,font) 
    timeLabel = Widgets.Label("Initializing", 10, 50,  
                                    1.0, 0xffffff, 0x222222,  
                                    Widgets.FONTS.DejaVu18) 

    dis_text = "time left - "

    while True:
        M5.update()
        current_time = int(end - time.time())
        timeLabel.setText(f'{dis_text} {current_time} sec')
        if current_time <= 0:
            break
        
    for I in range(3):
        M5.Speaker.tone(5000,50) 
        time.sleep_ms(200)
BtnB.setCallback(type=BtnB.CB_TYPE.WAS_RELEASED,  
                   cb=btnB_wasReleased_event)

while True:
    M5.update()
    time.sleep_ms(100)