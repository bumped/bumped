'use strict'

Args = require 'args-js'

module.exports =

  structure:
    "files": []

  detect: ['package.json', 'bower.json']

  opts:
    outputMessage: true

  args: ->
    Args([
      { opts :  Args.OBJECT   | Args.Optional, _default:  this.opts }
      { cb   :  Args.FUNCTION | Args.Required                       }
    ], arguments[0])
