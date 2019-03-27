#!/usr/bin/env node
'use strict'
require('coffeescript').register()
var fs = require('fs')
var Bumped = require('./../lib/Bumped')
var updateNotifier = require('update-notifier')
var partial = require('lodash.partial')
var cli = require('meow')({
  pkg: require('../package.json'),
  help: fs.readFileSync(__dirname + '/help.txt', 'utf8')
})

updateNotifier({ pkg: cli.pkg }).notify()
if (cli.input.length === 0) cli.showHelp()

var bumped = new Bumped()
var command = cli.input.shift()

var exit = function (err) {
  if (!err) return process.exit()
  if (!Array.isArray(err)) err = [err]
  var code = err[err.length - 1].code || 1
  return process.exit(code || 1)
}

var commands = {
  init: partial(bumped.init, exit),
  version: partial(bumped.semver.version, exit),

  release: partial(
    bumped.semver.release,
    {
      version: cli.input[0],
      prefix: cli.input[1]
    },
    exit
  ),

  add: partial(
    bumped.config.add,
    {
      detect: true,
      save: true,
      file: cli.input[0]
    },
    exit
  ),

  remove: partial(
    bumped.config.remove,
    {
      save: true,
      file: cli.input[0]
    },
    exit
  ),

  set: (function () {
    var property = cli.input[0]
    cli.input.shift()
    var value = cli.input.join(' ')
    return partial(
      bumped.config.set,
      {
        property: property,
        value: value
      },
      exit
    )
  })()
}

var existCommand = Object.keys(commands).indexOf(command) > -1

if (!existCommand) return cli.showHelp()

process.stdout.write('\n')

if (command === 'init') return commands[command]()

return bumped.load(function (err) {
  if (err) throw err
  return commands[command]()
})
