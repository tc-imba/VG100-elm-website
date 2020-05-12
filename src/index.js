import hljs from 'highlight.js';
import 'highlight.js/styles/github-gist.css'
window.hljs = hljs;

import 'typeface-roboto'
import 'normalize.css'
import 'material-icons/css/material-icons.css'
import '../elm-mdc/material-components-web.css'
import '../elm-mdc/elm-mdc'

import 'github-markdown-css'
import './main.css'

import _package from '../package.json'

import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

const env = process.env.NODE_ENV;
const devMode = env  !== 'production';

const flags = {
  api: devMode ? "http://localhost:5000/vg100" : "/vg100",
  version: _package.version
}

Elm.Main.init({
  node: document.getElementById('root'),
  flags: flags,
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
