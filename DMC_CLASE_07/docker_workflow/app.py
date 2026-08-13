import os

from dotenv import load_dotenv
from flask import Flask, jsonify
import pymssql

load_dotenv()

app = Flask(__name__)


def db_config():
    return {
        "server": os.getenv("DB_HOST"),
        "user": os.getenv("DB_USER"),
        "password": os.getenv("DB_PASSWORD"),
        "database": os.getenv("DB_NAME"),
        "port": os.getenv("DB_PORT", "1433"),
    }


def get_connection():
    cfg = db_config()
    env_names = {
        "server": "DB_HOST",
        "user": "DB_USER",
        "password": "DB_PASSWORD",
        "database": "DB_NAME",
    }
    missing = [env_names[key] for key in env_names if not cfg[key]]
    if missing:
        raise RuntimeError("Faltan variables de entorno: " + ", ".join(missing))
    return pymssql.connect(
        server=cfg["server"],
        user=cfg["user"],
        password=cfg["password"],
        database=cfg["database"],
        port=cfg["port"],
        login_timeout=10,
    )


@app.route("/saludo")
def saludo():
    return "Hola, mundo desde Docker! fecha miercoles 5 de agosto de 2026"


@app.route("/db")
def db_status():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT @@VERSION, DB_NAME(), GETDATE()")
        version, db_name, fecha = cursor.fetchone()
        cursor.close()
        conn.close()
        return jsonify(
            {
                "estado": "conectado",
                "base_datos": db_name,
                "fecha_servidor": str(fecha),
                "version": version.strip().split("\n")[0] if version else None,
            }
        )
    except Exception as exc:
        return jsonify({"estado": "error", "detalle": str(exc)}), 500


@app.route("/user")
def usuarios():
    try:
        conn = get_connection()
        cursor = conn.cursor(as_dict=True)
        cursor.execute("SELECT * FROM prueba.Usuarios")
        filas = []
        for fila in cursor.fetchall():
            filas.append({clave: str(valor) if valor is not None else None for clave, valor in fila.items()})
        cursor.close()
        conn.close()
        return jsonify({"estado": "ok", "total": len(filas), "usuarios": filas})
    except Exception as exc:
        return jsonify({"estado": "error", "detalle": str(exc)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
