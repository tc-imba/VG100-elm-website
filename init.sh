#!/usr/bin/env bash

elm make

git submodule update --init --recursive
cd elm-mdc
make

