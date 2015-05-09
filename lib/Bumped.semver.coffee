'use strict'

os     = require 'os'
path   = require 'path'
semver = require 'semver'
fs     = require 'fs-extra'
async  = require 'neo-async'
MSG    = require './Bumped.messages'

module.exports = class Semver

  constructor: (bumped) ->
    @bumped = bumped

  sync: (opts, cb) =>
    async.compose(@max, @versions) (err, max) =>
      @bumped._version = max
      cb()

  versions: (cb) =>
    async.map @bumped.config.files, (file, next) ->
      version = require(path.resolve(file)).version
      next(null, version)
    , cb

  max: (versions, cb) ->
    initial = versions.shift()
    async.reduce versions, initial, (max, version, next) ->
      max = version if semver.gt version, max
      next(null, max)
    , cb

  increment: (opts, cb) =>
    newVersion = semver.inc @bumped._version, opts.release
    @bumped._version = newVersion
    async.each @bumped.config.files, @save, (err) =>
      @bumped.logger.errorHandler err, cb
      @bumped.logger.success MSG.CREATED_VERSION(@bumped._version)
      cb?()

  save: (file, cb) =>
    filepath = path.resolve file
    file = require filepath
    file.version = @bumped._version
    fileoutput = JSON.stringify(file, null, 2) + os.EOL
    fs.writeFile filepath, fileoutput, encoding: 'utf8', cb

  version: (newVersion, cb) =>
    cb = newVersion if arguments.length is 1

    if @bumped._version
      @bumped.logger.info MSG.CURRENT_VERSION(@bumped._version)
      return cb(@bumped._version)
    else
      @bumped.init messages:false, =>
        @bumped.logger.info MSG.CURRENT_VERSION(@bumped._version)
        return cb(@bumped._version)
