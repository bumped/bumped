'use strict'

Args = require 'args-js'
objectAssign = require('object-assign')

module.exports =

  scaffold: ->
    return {
      files: []
      plugins:
        prerelease: []
        postrelease: []
    }

  detect: ['package.json', 'bower.json']

  defaulOptions: ->
    return {
      outputMessage: true
    }

  args: ->
    args = Args([
      { opts :  Args.OBJECT   | Args.Optional, _default:  this.defaulOptions() }
      { cb   :  Args.FUNCTION | Args.Required                                  }
    ], arguments[0])
    return [objectAssign(this.defaulOptions(), args.opts), args.cb]
