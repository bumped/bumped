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


  plugins: (files) ->
    return {
      prerelease:
        'Linting config files':
          plugin: 'bumped-finepack'
      postrelease:
        'Generating CHANGELOG file':
          plugin: 'bumped-changelog'
        'Committing new version':
          plugin: 'bumped-terminal'
          command: 'git add CHANGELOG.md ' + files.join(' ') + ' && git commit -m "Release $newVersion"'
        'Detecting problems before publish':
          plugin: 'bumped-terminal'
          command: 'git-dirty && npm test'
        'Publishing tag to GitHub':
          plugin: 'bumped-terminal'
          command: 'git tag $newVersion && git push && git push --tags'
        'Publishing to NPM':
          plugin: 'bumped-terminal'
          command: 'npm publish'
    }

  keywords:
    semver: ['major', 'minor', 'patch', 'premajor', 'preminor', 'prepatch', 'prerelease']
    nature: ['breaking', 'feature', 'fix']
    adapter:
      breaking: 'major'
      feature: 'minor'
      fix: 'patch'

  detectFileNames: ['package.json']
  fallbackFileName: 'package.json'

  logger:
    keyword: 'bumped'
    level: 'all'
    types:
      error:
        level : 0
        color : ['red']
      warn:
        level : 1
        color : ['yellow']
      success:
        level : 2
        color : ['green']

  args: ->
    args = Args([
      { opts :  Args.OBJECT   | Args.Optional }
      { cb   :  Args.FUNCTION | Args.Required }
    ], arguments[0])
    return [args.opts, args.cb]
