from machine import Pin
from config import RELAY_PIN, RELAY_ON_VALUE, RELAY_OFF_VALUE

relay = Pin(RELAY_PIN, Pin.OUT)

def init_relay():
    relay.value(RELAY_OFF_VALUE)

def relay_on():
    relay.value(RELAY_ON_VALUE)
    print("Relay ON")

def relay_off():
    relay.value(RELAY_OFF_VALUE)
    print("Relay OFF")

def relay_toggle():
    relay.value(0 if relay.value() == RELAY_ON_VALUE else RELAY_ON_VALUE)
    print("Relay toggled. Raw value:", relay.value())

def relay_state():
    return relay.value()