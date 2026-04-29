from controller import init_controller
from wifi_manager import connect_wifi
from web_server import start_server, serve_forever
from audio_manager import init_sd, init_mic
from config import HTTP_PORT

print("Booting smart irrigation controller...")

init_sd()
init_mic()
init_controller()

ip = connect_wifi()

print("Open this in your browser:")
print("http://{}:{}/".format(ip, HTTP_PORT))

server = None
try:
    server = start_server()
    serve_forever(server)
finally:
    if server is not None:
        try:
            server.close()
        except:
            pass