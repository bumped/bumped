'use strict'

Args = require 'args-js'

module.exports =

  scaffold: ->
    return {
      files: []
      plugins:
        prerelease: {}
        postrelease: {}
    }

  keywords:
    semver: ['major', 'minor', 'patch', 'premajor', 'preminor', 'prepatch', 'prerelease']
    nature: ['breaking', 'feature', 'fix']
    adapter:
      breaking: 'major'
      feature: 'minor'
      fix: 'patch'

  detect: ['package.json', 'bower.json']

  logger:
    keyword: 'bumped'
    level: 'all'
    types:
      error:
        level : 0
        color : 'red'
      warn:
        level : 1
        color : 'yellow'
      success:
        level : 2
        color : 'green'

  args: ->
    args = Args([
      { opts :  Args.OBJECT   | Args.Optional }
      { cb   :  Args.FUNCTION | Args.Required               }
    ], arguments[0])
    return [args.opts, args.cb]
