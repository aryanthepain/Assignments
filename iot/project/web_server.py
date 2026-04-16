import socket
from controller import pump_on, pump_off, pump_toggle, run_for, status, update_controller
from config import HTTP_PORT

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
    # expects /run?seconds=5
    if "seconds=" not in path:
        return None
    try:
        value = path.split("seconds=")[1].split("&")[0]
        return int(value)
    except:
        return None

def html_page():
    s = status()

    remaining = s["seconds_remaining"]
    if remaining is None:
        remaining_text = "N/A"
    else:
        remaining_text = str(remaining)

    mode = s["mode"]
    relay_raw = s["relay_raw"]
    last_action = s["last_action"]

    return """<!DOCTYPE html>
<html>
<head>
    <title>Smart Irrigation Controller</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="refresh" content="2">
    <style>
        body {{
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 20px;
            background: #f4f4f4;
        }}
        .card {{
            max-width: 420px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }}
        .btn {{
            display: inline-block;
            margin: 8px;
            padding: 14px 22px;
            text-decoration: none;
            color: white;
            border-radius: 12px;
            font-size: 18px;
        }}
        .on {{ background: #2e7d32; }}
        .off {{ background: #c62828; }}
        .toggle {{ background: #1565c0; }}
        .run {{ background: #6a1b9a; }}
        .status {{
            text-align: left;
            margin-top: 20px;
            font-size: 17px;
            line-height: 1.8;
        }}
    </style>
</head>
<body>
    <div class="card">
        <h2>Smart Irrigation Controller</h2>

        <a class="btn on" href="/on">ON</a>
        <a class="btn off" href="/off">OFF</a>
        <a class="btn toggle" href="/toggle">TOGGLE</a>

        <br><br>

        <a class="btn run" href="/run?seconds=2">RUN 2s</a>
        <a class="btn run" href="/run?seconds=5">RUN 5s</a>
        <a class="btn run" href="/run?seconds=10">RUN 10s</a>

        <div class="status">
            <b>Mode:</b> {mode}<br>
            <b>Relay raw:</b> {relay_raw}<br>
            <b>Seconds remaining:</b> {remaining}<br>
            <b>Last action:</b> {last_action}<br>
        </div>
    </div>
</body>
</html>
""".format(
        mode=mode,
        relay_raw=relay_raw,
        remaining=remaining_text,
        last_action=last_action
    )

def http_response(body):
    return (
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/html\r\n"
        "Connection: close\r\n"
        "\r\n" + body
    )

def handle_path(path):
    if path == "/on":
        pump_on()
    elif path == "/off":
        pump_off()
    elif path == "/toggle":
        pump_toggle()
    elif path.startswith("/run"):
        seconds = parse_run_seconds(path)
        run_for(seconds)

def start_server():
    addr = socket.getaddrinfo("0.0.0.0", HTTP_PORT)[0][-1]
    s = socket.socket()
    try:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    except:
        pass
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

            print("Request path:", path)
            handle_path(path)

            body = html_page()
            response = http_response(body)
            client.send(response.encode())
        except Exception as e:
            print("Client error:", e)
        finally:
            try:
                client.close()
            except:
                pass