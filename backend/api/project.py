from backend import app, url_prefix
from backend.build import add_task
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


@app.route('%s/api/project/build/<name>' % url_prefix)
# @check_argument("name")
def build_project(name: str):
    add_task(name)
    # project_dir = os.path.join(repos_dir, name)
    #
    # shutil.rmtree(project_dir, ignore_errors=True)
    #
    # build_log_dir = os.path.join(project_dir, '.vg100.build')
    # code_file = os.path.join(build_log_dir, 'code')
    # stdout_file = os.path.join(build_log_dir, 'stdout')
    # stderr_file = os.path.join(build_log_dir, 'stderr')
    #
    # repo = git.Git(repos_dir).clone('%s:%s' % (app.config['GIT_SERVER'], name))
    #
    # with open(stdout_file, 'w') as out, open(stderr_file, 'w') as err:
    #     subprocess.run("make", shell=True, cwd=project_dir, stdout=out, stderr=err)
    #
    # print(repo)
    return name


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


@app.route('%s/api/project/list/<name>' % url_prefix)
def list_project(name: str):
    repos = repos_config.get(name, [])
    result = []
    for repo in repos:
        if 'name' in repo:
            result.append({
                'name': repo['name'],
                'author': repo.get('author', ''),
                'code': get_return_code(repo['name'])
            })
    return jsonify(result)


@app.route('%s/api/project/log/<name>' % url_prefix)
def log_project(name: str):
    repo = repos_dict.get(name, None)
    if repo is None:
        return jsonify({})
    result = {
        'name': name,
        'author': repo.get('author', ''),
        'code': get_return_code(name),
        'stdout': get_log_file(name, 'stdout'),
        'stderr': get_log_file(name, 'stderr')
    }
    return jsonify(result)
