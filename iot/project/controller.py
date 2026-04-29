import time
from config import DEFAULT_RUN_SECONDS, MAX_RUN_SECONDS
from relay_control import init_relay, relay_on, relay_off, relay_toggle, relay_state

_mode = "OFF"
_until_ms = None
_last_action = "boot"

def init_controller():
    global _mode, _until_ms, _last_action
    init_relay()
    _mode = "OFF"
    _until_ms = None
    _last_action = "initialized"

def pump_on():
    global _mode, _until_ms, _last_action
    relay_on()
    _mode = "ON"
    _until_ms = None
    _last_action = "manual on"

def pump_off():
    global _mode, _until_ms, _last_action
    relay_off()
    _mode = "OFF"
    _until_ms = None
    _last_action = "manual off"

def pump_toggle():
    global _mode, _until_ms, _last_action
    relay_toggle()
    if relay_state() == 1:
        _mode = "ON"
        _until_ms = None
        _last_action = "toggle on"
    else:
        _mode = "OFF"
        _until_ms = None
        _last_action = "toggle off"

def run_for(seconds=None):
    global _mode, _until_ms, _last_action

    if seconds is None:
        seconds = DEFAULT_RUN_SECONDS

    try:
        seconds = int(seconds)
    except:
        seconds = DEFAULT_RUN_SECONDS

    if seconds < 1:
        seconds = 1
    if seconds > MAX_RUN_SECONDS:
        seconds = MAX_RUN_SECONDS

    relay_on()
    _mode = "TIMED"
    _until_ms = time.ticks_add(time.ticks_ms(), seconds * 1000)
    _last_action = "timed run {}s".format(seconds)

# Make sure to add RECORD_SECONDS to your config import at the top (or inside the function)
from config import DEFAULT_RUN_SECONDS, MAX_RUN_SECONDS, MONITOR_INTERVAL_SECONDS, LAPTOP_IP, RECORD_SECONDS

_last_monitor_ms = 0

def update_controller():
    global _mode, _until_ms, _last_action, _last_monitor_ms
    import time

    # Existing timed-run logic
    if _until_ms is not None:
        if time.ticks_diff(_until_ms, time.ticks_ms()) <= 0:
            relay_off()
            _mode = "OFF"
            _until_ms = None
            _last_action = "timed run complete"
            
    # --- Automated ML Fault Monitoring ---
    if _mode in ["ON", "TIMED"]:
        # Check if it's time to record a sample
        if time.ticks_diff(time.ticks_ms(), _last_monitor_ms) > (MONITOR_INTERVAL_SECONDS * 1000):
            _last_monitor_ms = time.ticks_ms()
            
            # Import here to prevent circular import issues
            from audio_manager import record_audio, send_for_analysis
            
            print(f"Auto-Monitor triggered... Recording for {RECORD_SECONDS}s")
            
            # THE FIX: Use the config variable instead of the hardcoded '2'
            filename = record_audio(RECORD_SECONDS) 
            
            if filename:
                status = send_for_analysis(filename, LAPTOP_IP)
                
                if status == "fault":
                    print("⚠️ FAULT DETECTED! SHUTTING DOWN PUMP!")
                    relay_off()
                    _mode = "OFF"
                    _until_ms = None
                    _last_action = "AUTO-SHUTDOWN (FAULT)"

def seconds_remaining():
    if _until_ms is None:
        return None
    diff = time.ticks_diff(_until_ms, time.ticks_ms())
    if diff <= 0:
        return 0
    return diff // 1000

def status():
    return {
        "mode": _mode,
        "relay_raw": relay_state(),
        "seconds_remaining": seconds_remaining(),
        "last_action": _last_action
    }