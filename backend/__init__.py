from flask import Flask, request, send_from_directory, redirect
from flask_cors import CORS
import os

app = Flask(__name__, static_folder='../build/static', static_url_path='/vg100/static')
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

app.config.from_object('backend.config')
url_prefix = app.config['URL_PREFIX']

# app.config.from_envvar('BACKEND_SETTINGS')


from backend import api


build_dir = os.path.join(os.path.dirname(app.instance_path), 'build')

@app.route('%s' % url_prefix)
@app.route('%s/markdown/' % url_prefix)
@app.route('%s/markdown/<path:name>' % url_prefix)
def show_main(name = ''):
    return send_from_directory(build_dir, 'index.html')


@app.route('%s/<name>' % url_prefix)
def show_main_assets(name):
    print(name)
    if name == 'markdown' or name == 'index.html':
        return redirect('/')
    return send_from_directory(build_dir, name)


@app.route('%s/demo/<project>' % url_prefix)
@app.route('%s/demo/<project>/<path:name>' % url_prefix)
def show_project_demo(project, name = ''):
    repos_dir = os.path.join(os.path.dirname(app.instance_path), 'repos', project)
    if name == '':
        filename = os.path.join(project, 'index.html')
    else:
        filename = os.path.join(project, name)
    return send_from_directory(repos_dir, name)

#@app.route('/static/<path:name>', methods=['GET'])
#def show_static(name):
#    print(name)
#    static_dir = os.path.join(os.path.dirname(app.instance_path), 'build', 'static')
#    return send_from_directory(static_dir, name)

print(app.instance_path)

if __name__ == '__main__':
    app.run(debug=True)