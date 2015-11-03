'use strict'

path      = require 'path'
async     = require 'async'
semver    = require 'semver'
fs        = require 'fs-extra'
ms        = require 'pretty-ms'
DEFAULT   = require './Bumped.default'
MSG       = require './Bumped.messages'
Animation = require './Bumped.animation'

module.exports = class Semver

  constructor: (bumped) ->
    @bumped = bumped

  sync: =>
    [opts, cb] = DEFAULT.args arguments
    async.compose(@max, @versions) (err, max) =>
      @bumped._version = max
      cb()

  versions: (cb) =>
    async.map @bumped.config.rc.files, (file, next) ->
      version = require(path.resolve file).version
      next null, version
    , cb

  max: (versions, cb) ->
    initial = versions.shift()
    async.reduce versions, initial, (max, version, next) ->
      max = version if semver.gt version, max
      next null, max
    , cb

  release: =>
    [opts, cb] = DEFAULT.args arguments

    return @bumped.logger.errorHandler MSG.NOT_VALID_VERSION(opts.version), cb unless opts.version
    @bumped._version ?= '0.0.0'

    if @isSemverWord opts.version
      bumpedVersion = @_releasesBasedOnSemver
    else
      bumpedVersion = @_releasesBasedOnVersion

    tasks = [
      (next) =>
        opts.type = 'prerelease'
        @bumped.plugin.exec opts, (err) ->
          next(MSG.NOT_RELEASED() if err)
      (next) ->
        bumpedVersion opts.version, next
      (newVersion, next) =>
        @bumped._oldVersion = @bumped._version
        @update start: now, version: newVersion, outputMessage: opts.outputMessage, next
      (next) =>
        opts.type = 'postrelease'
        @bumped.plugin.exec opts, next
    ]

    now = new Date()
    async.waterfall tasks, (err) =>
      return @bumped.logger.errorHandler err, cb if err
      cb null, @bumped._version

  update: ->
    [opts, cb] = DEFAULT.args arguments

    @bumped._version = opts.version
    async.each @bumped.config.rc.files, @save, (err) =>

      return @bumped.logger.errorHandler err, cb if err

      Animation.end
        logger  : @bumped.logger
        version : @bumped._version
        start   : opts.start
        outputMessage: opts.outputMessage

      @bumped.logger.keyword = DEFAULT.logger.keyword
      cb()

  save: (file, cb) =>
    @bumped.util.updateJSON
      filename : file
      property : 'version'
      value    : @bumped._version
    , cb

  version: =>
    [opts, cb] = DEFAULT.args arguments

    if opts.outputMessage
      if @bumped._version?
        @bumped.logger.success MSG.CURRENT_VERSION @bumped._version
      else
        @bumped.logger.warn MSG.NOT_CURRENT_VERSION()

    return cb @bumped._version

  isSemverWord: (word) ->
    [ 'major', 'premajor', 'minor', 'preminor'
      'patch', 'prepatch', 'prerelease' ].indexOf(word) isnt -1

  _releasesBasedOnSemver: (keyword, cb) =>
    cb null, semver.inc(@bumped._version, keyword)

  _releasesBasedOnVersion: (version, cb) =>
    version = semver.clean version
    version = semver.valid version
    return cb MSG.NOT_VALID_VERSION version unless version?
    return cb MSG.NOT_GREATER_VERSION(version, @bumped._version) unless semver.gt version, @bumped._version
    cb null, version
