from backend import app
from backend.utils import check_argument
import git
import os
import shutil
import subprocess





@app.route('/api/build/<path:name>')
# @check_argument("name")
def build_project(name: str):
    name = name.replace('/', '.')
    base_dir = os.path.abspath('repos')
    project_dir = os.path.join(base_dir, name)
    shutil.rmtree(project_dir, ignore_errors=True)
    repo = git.Git(base_dir).clone('%s:%s' % (app.config['GIT_SERVER'], name))

    with open(os.path.join('build.stdout'), 'w') as out, open(os.path.join('build.stderr'), 'w') as err:
        subprocess.run("make", shell=True, cwd=project_dir, stdout=out, stderr=err)

    print(repo)
    return name
