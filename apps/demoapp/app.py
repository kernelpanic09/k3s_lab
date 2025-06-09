# app.py
from flask import Flask, render_template
import platform
import os
from datetime import datetime

app = Flask(__name__, static_url_path='/static')

@app.route("/")
def home():
    context = {
        "git_sha": os.getenv("GIT_SHA", "N/A"),
        "python_version": platform.python_version(),
        "os_name": platform.system(),
        "container_os": platform.platform(),
        "framework": "Flask",
        "timestamp": datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"),
        "env": os.getenv("DEPLOY_ENV", "dev")
    }
    return render_template("index.html", **context)

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
