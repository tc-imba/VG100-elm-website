from flask import Flask, request, send_from_directory, redirect
from flask_cors import CORS
import os

app = Flask(__name__, static_folder='../build/static')
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

app.config.from_object('backend.config')

# app.config.from_envvar('BACKEND_SETTINGS')


from backend import api


build_dir = os.path.join(os.path.dirname(app.instance_path), 'build')

@app.route('/')
@app.route('/markdown/')
@app.route('/markdown/<path:name>')
def show_main(name = ''):
    return send_from_directory(build_dir, 'index.html')


@app.route('/<name>')
def show_main_assets(name):
    print(name)
    if name == 'markdown' or name == 'index.html':
        return redirect('/')
    return send_from_directory(build_dir, name)



#@app.route('/static/<path:name>', methods=['GET'])
#def show_static(name):
#    print(name)
#    static_dir = os.path.join(os.path.dirname(app.instance_path), 'build', 'static')
#    return send_from_directory(static_dir, name)

print(app.instance_path)

if __name__ == '__main__':
    app.run(debug=True)
