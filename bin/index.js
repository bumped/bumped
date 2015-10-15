#!/usr/bin/env node
'use strict';
require('coffee-script').register();
var fs = require('fs');
var Bumped = require('./../lib/Bumped');
var updateNotifier = require('update-notifier');
var partial = require('fn-partial');
var cli = require('meow')({
  pkg: '../package.json',
  help: fs.readFileSync(__dirname + '/help.txt', 'utf8')
});

updateNotifier({pkg: cli.pkg}).notify();
if (cli.input.length === 0) cli.showHelp();

var bumped = new Bumped();
var command = cli.input.shift();

var exit = function(err) {
  if (err) return process.exit(1);
  return process.exit();
};

var commands = {
  init: partial(bumped.init, exit),
  version: partial(bumped.semver.version, exit),

  release: partial(bumped.semver.release, {
    version: cli.input[0]
  }, exit),

  add: partial(bumped.config.add, {
    detect: true,
    save: true,
    file: cli.input[0]
  }, exit),

  remove: partial(bumped.config.remove, {
    save: true,
    file: cli.input[0]
  }, exit),

  set: (function() {
    var property = cli.input[0];
    cli.input.shift();
    var value = cli.input.join(' ');
    return partial(bumped.config.set, {
      property: property,
      value: value
    }, exit);
  })()
};

var existCommand = Object.keys(commands).indexOf(command) > -1;

if (existCommand) {
  return bumped.start({
    outputMessage: false
  }, function(err) {
    if (err) throw err;
    process.stdout.write('\n');
    return commands[command]();
  });
}

cli.showHelp();
