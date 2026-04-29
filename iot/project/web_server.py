import socket
import os
from controller import pump_on, pump_off, pump_toggle, run_for, status, update_controller
from config import HTTP_PORT, RECORD_SECONDS
from audio_manager import record_audio

def parse_path(request_text):
    try:
        first_line = request_text.split("\r\n")[0]
        parts = first_line.split()
        if len(parts) >= 2:
            return parts[1]
    except:
        pass
    return "/"

def parse_run_seconds(path):
    if "seconds=" not in path:
        return None
    try:
        value = path.split("seconds=")[1].split("&")[0]
        return int(value)
    except:
        return None

def parse_download_filename(path):
    if "file=" not in path:
        return None
    try:
        return path.split("file=")[1].split("&")[0]
    except:
        return None

def clear_all_audio():
    try:
        for filename in os.listdir("/sd"):
            if filename.endswith(".raw"):
                os.remove("/sd/" + filename)
        print("All audio recordings cleared.")
    except Exception as e:
        print("Error clearing audio:", e)

def html_page():
    s = status()
    remaining = s["seconds_remaining"]
    remaining_text = "N/A" if remaining is None else str(remaining)

    try:
        # Get list of .raw files on SD card
        files = os.listdir("/sd")
        raw_files = [f for f in files if f.endswith(".raw")]
        
        # Sort by modification time (index 7 of os.stat)
        def get_mtime(filename):
            try:
                return os.stat("/sd/" + filename)[7]
            except:
                return 0
                
        raw_files.sort(key=get_mtime, reverse=True) # Newest at the top
        
        file_links = "".join(['<li style="margin-bottom: 8px;"><a href="/download?file={}">💾 {}</a></li>'.format(f, f) for f in raw_files])
        if not file_links:
            file_links = "<li>No audio files yet.</li>"
    except:
        file_links = "<li>SD card not found or empty.</li>"

    return """<!DOCTYPE html>
<html>
<head>
    <title>Smart Irrigation Controller</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {{ font-family: Arial, sans-serif; text-align: center; padding: 20px; background: #f4f4f4; }}
        .card {{ max-width: 420px; margin: auto; background: white; padding: 20px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.12); }}
        .btn {{ display: inline-block; margin: 8px; padding: 14px 22px; text-decoration: none; color: white; border-radius: 12px; font-size: 18px; }}
        .on {{ background: #2e7d32; }} .off {{ background: #c62828; }} .toggle {{ background: #1565c0; }} 
        .run {{ background: #6a1b9a; }} .record {{ background: #e65100; }} .danger {{ background: #d32f2f; }}
        .status {{ text-align: left; margin-top: 20px; font-size: 17px; line-height: 1.8; }}
        ul {{ list-style-type: none; padding: 0; }}
        a {{ color: #1565c0; text-decoration: none; font-weight: bold; }}
    </style>
</head>
<body>
    <div class="card">
        <h2>Smart Irrigation Controller</h2>
        <a class="btn on" href="/on">ON</a>
        <a class="btn off" href="/off">OFF</a>
        <a class="btn toggle" href="/toggle">TOGGLE</a><br><br>
        <a class="btn run" href="/run?seconds=2">RUN 2s</a>
        <a class="btn run" href="/run?seconds=5">RUN 5s</a><br><br>
        <a class="btn record" href="/record">🎙️ RECORD 5s</a>

        <div class="status">
            <b>Mode:</b> {mode}<br>
            <b>Relay raw:</b> {relay_raw}<br>
            <b>Seconds remaining:</b> {remaining}<br>
            <b>Last action:</b> {last_action}<br>
        </div>
        
        <hr style="margin-top:20px; margin-bottom:20px;">
        <div class="status">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <b>SD Card Recordings:</b>
                <a class="btn danger" style="margin: 0; padding: 8px 12px; font-size: 14px;" href="/clear_audio" onclick="return confirm('Are you sure you want to delete all recordings?');">🗑️ CLEAR ALL</a>
            </div>
            <ul style="margin-top: 15px;">{file_links}</ul>
        </div>
    </div>
</body>
</html>
""".format(
        mode=s["mode"], relay_raw=s["relay_raw"],
        remaining=remaining_text, last_action=s["last_action"],
        file_links=file_links
    )

def handle_path(path):
    if path == "/on": pump_on()
    elif path == "/off": pump_off()
    elif path == "/toggle": pump_toggle()
    elif path == "/record": record_audio()
    elif path == "/clear_audio": clear_all_audio()
    elif path.startswith("/run"):
        seconds = parse_run_seconds(path)
        run_for(seconds)

def start_server():
    addr = socket.getaddrinfo("0.0.0.0", HTTP_PORT)[0][-1]
    s = socket.socket()
    try: s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    except: pass
    s.bind(addr)
    s.listen(2)
    s.settimeout(0.2)
    print("Web server listening on port", HTTP_PORT)
    return s

def serve_forever(server_socket):
    while True:
        update_controller()
        try:
            client, addr = server_socket.accept()
        except OSError:
            continue

        try:
            request = client.recv(1024)
            request_text = request.decode("utf-8", "ignore")
            path = parse_path(request_text)
            
            # --- FILE DOWNLOAD ROUTE ---
            if path.startswith("/download"):
                filename = parse_download_filename(path)
                if filename and filename in os.listdir("/sd"):
                    filepath = "/sd/" + filename
                    # Send HTTP headers for file download
                    client.send("HTTP/1.1 200 OK\r\n")
                    client.send("Content-Type: application/octet-stream\r\n")
                    client.send("Content-Disposition: attachment; filename={}\r\n\r\n".format(filename))
                    
                    # Read and send file in chunks to save RAM
                    with open(filepath, "rb") as f:
                        while True:
                            chunk = f.read(1024)
                            if not chunk: break
                            client.send(chunk)
                else:
                    client.send("HTTP/1.1 404 Not Found\r\n\r\nFile not found".encode())
            
            # --- NORMAL HTML UI ROUTE ---
            else:
                handle_path(path)
                # Redirect back to the root if we just cleared the audio
                if path == "/clear_audio" or path == "/record":
                    response = "HTTP/1.1 303 See Other\r\nLocation: /\r\nConnection: close\r\n\r\n"
                else:
                    body = html_page()
                    response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n" + body
                client.send(response.encode())
                
        except Exception as e:
            print("Client error:", e)
        finally:
            try: client.close()
            except: pass