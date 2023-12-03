from flask import Flask
import socket
import os

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    app_name = os.getenv('APP_NAME', "Default-app")  
    web_content = os.getenv('WEB_CONTENT', "Empty")  
    return f"<!DOCTYPE html><html><body><h1>This is APP: {app_name}</h1><h1>Hello from POD: {hostname}</h1>{web_content}</body></html>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
