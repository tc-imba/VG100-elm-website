#!/usr/bin/env bash

# init the submodule
git submodule update --init --recursive
cd elm-mdc && make

# download elm dependencies
cd ..
elm make

# init python venv
python3 -m virtualenv venv
source venv/bin/activate
pip3 install -e .

# init node modules
npm install -g yarn create-elm-app
yarn

