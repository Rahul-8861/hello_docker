from flask import Flask
app = Flask(__name__)

@app.get("/")
def home():
    return "Hello from Docker!"

if __name__ == "__main__":
    # listen on all interfaces so Docker can map the port
    app.run(host="0.0.0.0", port=8000)

