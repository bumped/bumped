fs      = require 'fs'
os      = require 'os'
path    = require 'path'
semver  = require 'semver'
_       = require 'lodash'
async   = require 'async'
pkgJSON = require '../package.json'

module.exports = class Bumped

  constructor: (options) ->
    process.chdir options.scope if options.scope?
    @config = require('rc')(pkgJSON.name, {})
    @version = @_syncVersion()
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

  _syncVersion: ->
    versions = []
    versions.push require(path.resolve(file)).version for file in @config.files
    _.reduce versions, (max, version) -> max = version if semver.gt version, max
