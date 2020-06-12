from setuptools import setup

setup(
    name='backend',
    version='1.0.0',
    packages=['backend'],
    include_package_data=True,
    install_requires=[
        'flask>=1.1.1',
        'flask-cors',
        'gitpython',
        'celery',
        'redis',
        'python-redis-lock',
        'future',
        'gunicorn'
        'supervisord'
    ],
)
