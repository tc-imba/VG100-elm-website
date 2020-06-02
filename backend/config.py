# DATABASE_NAME = 'secure-private-dating'
# APP_ID = ''
# APP_SECRET = ''
# SESSION_TYPE = 'mongodb'

GIT_SERVER = 'git@vg100'

CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'

REPOS = {
    'p1': [{
        "name": "p1teamta",
        "author": "Shixin Song"
    }, {
        "name": "p1teamta-new",
        "author": "Li Shi"
    }]
}
