#!/usr/bin/env bash

git pull
PUBLIC_URL='/vg100' node scripts/build.js
# FLASK_APP=backend FLASK_ENV=production flask run -h 0.0.0.0
pm2 restart ./ecosystem.config.js
