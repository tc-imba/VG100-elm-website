from backend import app
import os
import pickle
import time
import git
import subprocess
import shutil
import celery
import redis
import redis_lock

conn = redis.from_url(app.config['CELERY_BROKER_URL'])


def refresh_task_set():
    lock = redis_lock.Lock(conn, "vg100-elm-website-task-lock")
    print('refresh task set')
    if not lock.acquire(blocking=False):
        lock.reset()
        lock.acquire()
    save_task_set(set())
    lock.release()


def get_task_set():
    data = conn.get('vg100-elm-website-task-set')
    if data is None:
        return set()
    return pickle.loads(data)


def save_task_set(task_set):
    data = pickle.dumps(task_set)
    conn.set('vg100-elm-website-task-set', data)


@celery.task(soft_time_limit=120)
def async_build_project(name):
    print('build start: %s' % name)
    # time.sleep(10)

    repos_dir = os.path.abspath('repos')
    project_dir = os.path.join(repos_dir, name)
    build_log_dir = os.path.join(project_dir, '.vg100.build')
    code_file = os.path.join(build_log_dir, 'code')
    stdout_file = os.path.join(build_log_dir, 'stdout')
    stderr_file = os.path.join(build_log_dir, 'stderr')

    return_code = -1
    try:
        shutil.rmtree(project_dir, ignore_errors=True)
        print('git clone: %s' % name)
        repo = git.Git(repos_dir).clone('%s:%s' % (app.config['GIT_SERVER'], name))
        os.makedirs(build_log_dir, exist_ok=True)

        print('make: %s' % name)
        with open(stdout_file, 'w') as out, open(stderr_file, 'w') as err:
            p = subprocess.run("make", shell=True, cwd=project_dir, stdout=out, stderr=err)
            return_code = p.returncode

        with open(code_file, 'w') as out:
            out.write(str(return_code))

    except Exception as e:
        print(e)

    print('build finish: %s (%d)' % (name, return_code))

    lock = redis_lock.Lock(conn, "vg100-elm-website-task-lock")
    lock.acquire()
    task_set = get_task_set()
    if name in task_set:
        task_set.remove(name)
        save_task_set(task_set)
    lock.release()


def add_task(name):
    lock = redis_lock.Lock(conn, "vg100-elm-website-task-lock")
    lock.acquire()
    task_set = get_task_set()
    if name not in task_set:
        print('add task: %s' % name)
        task_set.add(name)
        save_task_set(task_set)
        async_build_project.delay(name)
        lock.release()
        return True
    else:
        print('skip task: %s' % name)
        lock.release()
        return False

