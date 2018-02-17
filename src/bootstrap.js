const pureBase = require('purecss/build/base.css');
const pureForms = require('purecss/build/forms.css');
const pureGrids = require('purecss/build/grids.css');
const pureGridsResponsive = require('purecss/build/grids-responsive.css');
const Elm = require('./elm/main');
Elm.Main.embed(document.querySelector('body'));