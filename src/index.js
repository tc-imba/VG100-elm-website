import 'typeface-roboto'
import 'material-icons/css/material-icons.css'
import 'normalize.css'
import '../elm-mdc/material-components-web.css'
import '../elm-mdc/elm-mdc'

import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

Elm.Main.init({
  node: document.getElementById('root')
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
