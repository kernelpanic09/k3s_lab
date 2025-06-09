from flask import Flask, render_template_string
import platform
import os

app = Flask(__name__)

@app.route("/")
def home():
    git_sha = os.getenv("GIT_SHA", "N/A")
    python_version = platform.python_version()
    os_name = platform.system()
    framework = "Flask"
    container_os = platform.platform()

    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>CI/CD Dashboard</title>
        <style>
            body {{
                background-color: #0d1117;
                color: #c9d1d9;
                font-family: 'Segoe UI', sans-serif;
                padding: 40px;
                text-align: center;
                transition: all 0.3s ease;
            }}
            h1 {{
                font-size: 3em;
                color: #58a6ff;
            }}
            .info {{
                margin-top: 20px;
                font-size: 1.2em;
            }}
            .toggle {{
                position: absolute;
                top: 20px;
                right: 20px;
            }}
            .diagram {{
                margin-top: 40px;
            }}
            svg {{
                width: 80%;
                max-width: 600px;
            }}
        </style>
        <script>
            function toggleMode() {{
                const body = document.body;
                if (body.style.backgroundColor === 'white') {{
                    body.style.backgroundColor = '#0d1117';
                    body.style.color = '#c9d1d9';
                }} else {{
                    body.style.backgroundColor = 'white';
                    body.style.color = 'black';
                }}
            }}
        </script>
    </head>
    <body>
        <div class="toggle">
            <button onclick="toggleMode()">🌗 Toggle Dark Mode</button>
        </div>
        <h1>🚀 DevOps CI/CD Dashboard</h1>
        <div class="info">
            <p><strong>Git SHA:</strong> {git_sha}</p>
            <p><strong>Language:</strong> Python {python_version}</p>
            <p><strong>Framework:</strong> {framework}</p>
            <p><strong>OS:</strong> {os_name}</p>
            <p><strong>Container:</strong> {container_os}</p>
        </div>

        <div class="diagram">
            <svg viewBox="0 0 800 200">
                <text x="10" y="40" font-size="18" fill="#58a6ff">GitHub</text>
                <line x1="70" y1="35" x2="140" y2="35" stroke="#58a6ff" stroke-width="2"/>
                <text x="150" y="40" font-size="18" fill="#3fb950">GitHub Actions</text>
                <line x1="260" y1="35" x2="330" y2="35" stroke="#3fb950" stroke-width="2"/>
                <text x="340" y="40" font-size="18" fill="#facc15">ECR</text>
                <line x1="390" y1="35" x2="460" y2="35" stroke="#facc15" stroke-width="2"/>
                <text x="470" y="40" font-size="18" fill="#ec4899">ArgoCD</text>
                <line x1="540" y1="35" x2="610" y2="35" stroke="#ec4899" stroke-width="2"/>
                <text x="620" y="40" font-size="18" fill="#22d3ee">K3s</text>
            </svg>
        </div>
    </body>
    </html>
    """
    return render_template_string(html)

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
