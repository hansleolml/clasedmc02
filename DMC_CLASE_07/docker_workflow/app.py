from flask import Flask

app = Flask(__name__)

@app.route("/saludo")
def saludo():
    return "Hola, mundo desde Docker! fecha miercoles 5 de agosto de 2026"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
