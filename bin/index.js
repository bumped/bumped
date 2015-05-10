#!/usr/bin/env node
'use strict';
require('coffee-script').register();
var Bumped = require('./../lib/Bumped');
var updateNotifier = require('update-notifier');
var partial = require('fn-partial');
var cli = require('meow')({
      pkg: '../package.json',
      help: [
        'Usage',
        '  $ bumped <version|minor|major|patch>',
        '\n  options:',
        '\t -d --directory\t directory where run the command',
        '\n  examples:',
        '\t bumped 1.0.1',
        '\t bumped patch'
      ].join('\n')
    });

console.log(); // so pretty
updateNotifier({pkg: cli.pkg}).notify();
if (cli.input.length === 0) cli.showHelp();

var options = {
  logger: {
    color: true,
    level: 'silly'
  }
};

var bumped = new Bumped(options);
var command = cli.input.shift();

var exit = function(err) {
  if (err) return process.exit(1);
  return process.exit();
};

var commands = {
  init: partial(bumped.init, exit),
  version: partial(bumped.semver.version, exit),
  release: partial(bumped.semver.release, {version: cli.input[0]}, exit)
};

var existCommand = Object.keys(commands).indexOf(command) > -1;

if (existCommand) {
  return bumped.init({
    outputMessage: false
  }, function() {
    return commands[command]();
  });
}

cli.showHelp();
