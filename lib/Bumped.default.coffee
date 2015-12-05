'use strict'

chalk        = require 'chalk'
Args         = require 'args-js'
existsAssign = require 'existential-assign'

module.exports =

  scaffold: ->
    return {
      files: []
      plugins:
        prerelease: {}
        postrelease: {}
    }

  detect: ['package.json', 'bower.json']

  defaulOptions: ->
    return {
      outputMessage: true
    }

  logger:
    outputType: (type, diff = '') -> "#{@keyword} "
    color: true
    align: false
    diff: false
    keyword: 'bumped'
    level: 'plugin'
    types:
      line:
        color: 'white'
      error:
        level : 0
        color : 'red'
      warn:
        level : 1
        color : 'yellow'
      success:
        level : 2
        color : 'green'
      info:
        level : 3
        color : 'white'
      verbose:
        level : 4
        color : 'cyan'
      debug:
        level : 5
        color : 'blue'
      plugin:
        level : 6
        color : 'magenta'

  args: ->
    args = Args([
      { opts :  Args.OBJECT   | Args.Optional, _default:  this.defaulOptions() }
      { cb   :  Args.FUNCTION | Args.Required                                  }
    ], arguments[0])
    return [existsAssign(this.defaulOptions(), args.opts), args.cb]
