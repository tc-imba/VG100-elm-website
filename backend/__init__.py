from flask import Flask, request, send_from_directory, redirect, make_response
from flask_cors import CORS
import os
import multiprocessing
from celery import Celery

url_prefix = os.getenv('PUBLIC_URL', '')

app = Flask(__name__, static_folder='../build/static', static_url_path='%s/static' % url_prefix)
cors = CORS(app, resources={r"*": {"origins": "*"}})

app.config.from_object('backend.config')
# app.config.from_envvar('BACKEND_SETTINGS')

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)

from backend import api

build_dir = os.path.join(os.path.dirname(app.instance_path), 'build')


@app.route('%s/' % url_prefix)
@app.route('%s/markdown/' % url_prefix)
@app.route('%s/markdown/<path:name>' % url_prefix)
@app.route('%s/project/<path:name>' % url_prefix)
def show_main(name=''):
    response = make_response(send_from_directory(build_dir, 'index.html'))
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response


@app.route('%s/<name>' % url_prefix)
def show_main_assets(name):
    print(name)
    if name == 'markdown' or name == 'index.html':
        return redirect('/')
    return send_from_directory(build_dir, name)


# this is also dirty...
@app.route('%s/demo/<project>' % url_prefix)
def show_project_demo_redirect(project):
    return redirect('/vg100/demo/%s/' % project)


@app.route('%s/demo/<project>/' % url_prefix)
@app.route('%s/demo/<project>/<path:name>' % url_prefix)
def show_project_demo(project, name='index.html'):
    if name.startswith('doc/'):
        name = name[4:]
        repos_dir = os.path.join(os.path.dirname(app.instance_path), 'repos', project, 'doc')
    else:
        repos_dir = os.path.join(os.path.dirname(app.instance_path), 'repos', project, 'build')
    print(os.path.join(repos_dir, name))
    return send_from_directory(repos_dir, name)


# @app.route('/static/<path:name>', methods=['GET'])
# def show_static(name):
#    print(name)
#    static_dir = os.path.join(os.path.dirname(app.instance_path), 'build', 'static')
#    return send_from_directory(static_dir, name)

# print(app.instance_path)

if __name__ == '__main__':
    app.run(debug=True)
