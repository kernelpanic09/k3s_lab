from flask import Flask, render_template_string
app = Flask(__name__)

@app.route("/")
def home():
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>CI/CD DemoApp</title>
        <style>
            body {
                background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
                color: #ffffff;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                text-align: center;
                padding: 60px;
            }
            h1 {
                font-size: 3em;
                margin-bottom: 0.5em;
            }
            p {
                font-size: 1.5em;
                margin-bottom: 1.5em;
            }
            img {
                max-width: 80%%;
                height: auto;
                border: 2px solid #fff;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
            }
        </style>
    </head>
    <body>
        <h1>🚀 Hello from CI/CD!</h1>
        <p>This is a GitOps-powered Flask app, deployed via ArgoCD from ECR</p>
        <img src="https://raw.githubusercontent.com/argoproj/argo-cd/master/docs/assets/gitops-overview.png" alt="CI/CD Diagram">
    </body>
    </html>
    """
    return render_template_string(html)

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
