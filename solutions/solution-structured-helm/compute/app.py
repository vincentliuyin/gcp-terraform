from flask import Flask
import socket
import os
import requests

app = Flask(__name__)

@app.route('/')
def hello():
    # Get the hostname
    hostname = socket.gethostname()
    
    # Get the cloud storage link from the environment variable
    Storage_link = os.getenv('STORAGE_LINK')

    # Initialize web_content
    web_content = "storage content has problem"

    # Try to fetch content from cloud storage link if available
    if Storage_link:
        try:
            response = requests.get(Storage_link)
            if response.status_code == 200:
                web_content = f"<p>{response.text}</p><p>(Content fetched from cloud storage)</p>"
            else:
                web_content += " (unable to fetch)"
        except Exception as e:
            web_content += f" (Error: {e})"

    return f"<!DOCTYPE html><html><body><h1>Flask App on: {hostname}</h1>{web_content}</body></html>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)