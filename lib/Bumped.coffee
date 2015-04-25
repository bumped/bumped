fs      = require 'fs'
os      = require 'os'
path    = require 'path'
_       = require 'lodash'
async   = require 'async'
semver  = require 'semver'
pkgJSON = require '../package.json'
CONST   =
  DEFAULT_CONFIG:
    files: ['package.json']


module.exports = class Bumped

  constructor: (options) ->
    process.chdir options.scope if options.scope?
    @config = require('rc')(pkgJSON.name, CONST.DEFAULT_CONFIG)
    @version = @_lastVersion()
    this

  increment: (release) ->
    @version = semver.inc @version, release
    this

  save: (cb) ->
    files = []
    files.push path.resolve file for file in @config.files
    async.each files, @_saveFile, cb

  _saveFile: (filePath, cb) =>
    file = require filePath
    file.version = @version
    fileoutput = JSON.stringify(file, null, 2) + os.EOL
    fs.writeFile filePath, fileoutput, encoding: 'utf8', cb

  _lastVersion: ->
    versions = []
    versions.push require(path.resolve(file)).version for file in @config.files
    _.reduce versions, (max, version) -> max = version if semver.gt version, max
