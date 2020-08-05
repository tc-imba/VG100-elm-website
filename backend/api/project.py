from backend import app, url_prefix
from backend.build import add_task, get_task_set, refresh_task_set
# from backend.utils import check_argument
import os

from flask import jsonify


repos_config = app.config['REPOS']
repos_list = []
for item in repos_config.values():
    repos_list.extend(item)
repos_dict = {}
for item in repos_list:
    repos_dict[item['name']] = item

repos_dir = os.path.abspath('repos')
refresh_task_set_flag = True


def get_log_file(repo_name, log_type):
    build_log_dir = os.path.join(repos_dir, repo_name, '.vg100.build')
    log_file = os.path.join(build_log_dir, log_type)
    if os.path.isfile(log_file):
        with open(log_file, 'rb') as f:
            return f.read().decode('utf-8')
    return ''


def get_return_code(repo_name):
    code = -1
    log_code = get_log_file(repo_name, 'code')
    try:
        code = int(log_code)
    except:
        pass
    return code


def get_status(repo_name, return_code, task_set):
    if repo_name in task_set:
        status = 'building'
    elif return_code == 0:
        status = 'success'
    else:
        status = 'fail'
    return status


@app.route('%s/api/project/build/<name>' % url_prefix)
def build_project(name: str):
    global refresh_task_set_flag
    if refresh_task_set_flag:
        refresh_task_set_flag = False
        refresh_task_set()

    repo = repos_dict.get(name, None)
    if repo is None:
        result = {
            'name': name,
            'author': '',
            'code': -1,
            'status': 'fail',
            'title': name,
        }
    else:
        add_task(name)
        return_code = get_return_code(name)
        task_set = get_task_set()
        result = {
            'name': name,
            'author': repo.get('author', ''),
            'code': -1,
            'status': get_status(name, return_code, task_set),
            'title': repo.get('title', name),
        }
    return jsonify(result)


@app.route('%s/api/project/list/<name>' % url_prefix)
def list_project(name: str):
    repos = repos_config.get(name, [])
    result = []
    task_set = get_task_set()
    for repo in repos:
        if 'name' in repo:
            return_code = get_return_code(repo['name'])
            result.append({
                'name': repo['name'],
                'author': repo.get('author', ''),
                'code': return_code,
                'status': get_status(repo['name'], return_code, task_set),
                'title': repo.get('title', repo['name']),
            })
    return jsonify(result)


@app.route('%s/api/project/log/<name>' % url_prefix)
def log_project(name: str):
    repo = repos_dict.get(name, None)
    if repo is None:
        return jsonify({})
    return_code = get_return_code(name)
    task_set = get_task_set()
    result = {
        'name': name,
        'author': repo.get('author', ''),
        'code': return_code,
        'status': get_status(name, return_code, task_set),
        'title': repo.get('title', name),
        'stdout': get_log_file(name, 'stdout'),
        'stderr': get_log_file(name, 'stderr')
    }
    return jsonify(result)
