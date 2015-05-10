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

  release: (opts, cb) =>

    throwError = (message) =>
      error = new Error()
      error.message = message
      @bumped.logger.error error.message
      return cb error

    return throwError MSG.NOT_VALID_VERSION(opts.version) unless opts.version

    if @isSemverWord opts.version
      return @update semver.inc(@bumped._version, opts.version), cb

    newVersion = opts.version
    newVersion = semver.clean newVersion
    newVersion = semver.valid newVersion

    return throwError MSG.NOT_VALID_VERSION opts.version unless newVersion?
    unless semver.gt newVersion, @bumped._version
      return throwError MSG.NOT_GREATER_VERSION opts.version, @bumped._version

    @update newVersion, cb

  update: (newVersion, cb) ->
    @bumped._version = newVersion
    async.each @bumped.config.files, @save, (err) =>
      @bumped.logger.errorHandler err, cb
      @bumped.logger.success MSG.CREATED_VERSION(@bumped._version)
      cb null, @bumped._version

  save: (file, cb) =>
    filepath = path.resolve file
    file = require filepath
    file.version = @bumped._version
    fileoutput = JSON.stringify(file, null, 2) + os.EOL
    fs.writeFile filepath, fileoutput, encoding: 'utf8', cb

  version: (newVersion, cb) =>
    cb = newVersion if arguments.length is 1
    @bumped.logger.info MSG.CURRENT_VERSION(@bumped._version)
    return cb(@bumped._version)

  isSemverWord: (word) ->
    [ 'major'
      'premajor'
      'minor'
      'preminor'
      'patch'
      'prepatch'
      'prerelease' ].indexOf(word) isnt -1
