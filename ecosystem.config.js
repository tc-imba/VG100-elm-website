module.exports = {
  apps : [{
    name: 'vg100-elm-website',
    script: '.',
    interpreter: 'python3',
    interpreter_args: '-m flask run -h 0.0.0.0 --extra-files',
    watch: '.',
    env: {
      'FLASK_APP': 'backend',
      'FLASK_ENV': 'production'
    }
  }, {
    name: 'vg100-elm-celery',
    script: '.',
    interpreter: 'python3',
    interpreter_args: '-m celery worker --loglevel=info -c 1 -A backend.celery --workdir',
    watch: '.',
  }],

  deploy : {
    production : {
      user : 'SSH_USERNAME',
      host : 'SSH_HOSTMACHINE',
      ref  : 'origin/master',
      repo : 'GIT_REPOSITORY',
      path : 'DESTINATION_PATH',
      'pre-deploy-local': '',
      'post-deploy' : 'npm install && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
};
