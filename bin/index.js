#!/usr/bin/env node
'use strict';
require('coffee-script').register();
var path = require('path'),
    Logger = require('acho'),
    Bumped = require('./../lib/Bumped'),
    updateNotifier = require('update-notifier'),
    cli = require('meow')({
      pkg: '../package.json',
      help: [
        'Usage',
        '  $ bumped <version|minor|major|patch>',
        '\n  options:',
        '\t -d \t directory where run the command',
        '\n  examples:',
        '\t bumped 1.0.1',
        '\t bumped patch'
      ].join('\n')
    });

updateNotifier({pkg: cli.pkg}).notify();
if (cli.input.length === 0) cli.showHelp();

var bumped = new Bumped({
      logger: {color: true}
    }),
    action = cli.input.shift();

bumped[action](cli.input);
