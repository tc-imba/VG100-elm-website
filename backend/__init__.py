from flask import Flask, request

app = Flask(__name__)

app.config.from_object('backend.config')

# app.config.from_envvar('BACKEND_SETTINGS')


from backend import api


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    app.run(debug=True)
