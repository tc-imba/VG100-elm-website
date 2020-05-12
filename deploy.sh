#!/usr/bin/env bash

git pull
PUBLIC_URL='/vg100' npx elm-app build
FLASK_APP=backend FLASK_ENV=production flask run -h 0.0.0.0
