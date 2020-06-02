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


def get_task_set():
    data = conn.get('vg100-elm-website-task-set')
    if data is None:
        return set()
    return pickle.loads(data)


def save_task_set(task_set):
    data = pickle.dumps(task_set)
    conn.set('vg100-elm-website-task-set', data)


@celery.task
def async_build_project(name):
    print('build start: %s' % name)
    # time.sleep(10)
    try:
        repos_dir = os.path.abspath('repos')
        project_dir = os.path.join(repos_dir, name)
        shutil.rmtree(project_dir, ignore_errors=True)

        build_log_dir = os.path.join(project_dir, '.vg100.build')
        code_file = os.path.join(build_log_dir, 'code')
        stdout_file = os.path.join(build_log_dir, 'stdout')
        stderr_file = os.path.join(build_log_dir, 'stderr')

        repo = git.Git(repos_dir).clone('%s:%s' % (app.config['GIT_SERVER'], name))

    except Exception as e:
        print(e)
        pass

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
    else:
        print('skip task: %s' % name)
    lock.release()
