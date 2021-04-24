# VG100 Elm Website

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

## Setup

```bash
# init node modules
npm install -g yarn create-elm-app
yarn

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
```

Or you can run the setup script directly

```bash
./init.sh
```

## Development

```bash
npm run start
FLASK_APP=backend FLASK_ENV=development flask run
```

This should start the web app on `127.0.0.1:3000` and the backend on `127.0.0.1:5000`.

## Production

```bash
npm run build
FLASK_APP=backend FLASK_ENV=production flask run
```

This should start the backend on `127.0.0.1:5000`.

@TODO The backend should also serve the web app as home page, and be able to deal with the assets.


## License

MIT

Copyright (c) 2020 UM-SJTU-JI VG100 Team




