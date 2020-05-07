#!/usr/bin/env bash

git submodule update --init --recursive
cd elm-mdc
make

cd ..
elm make

