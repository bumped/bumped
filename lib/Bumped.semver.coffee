'use strict'

path      = require 'path'
async     = require 'async'
semver    = require 'semver'
util      = require './Bumped.util'
DEFAULT   = require './Bumped.default'
MSG       = require './Bumped.messages'
Animation = require './Bumped.animation'

module.exports = class Semver

  constructor: (bumped) ->
    @bumped = bumped

  ###*
   * Get the high project version across config files declared.
   * @return {[type]} [description]
  ###
  sync: =>
    [opts, cb] = DEFAULT.args arguments
    async.compose(@max, @versions) (err, max) =>
      @bumped._version = max
      cb()

  versions: (cb) =>
    async.reduce @bumped.config.rc.files, [], (accumulator, file, next) ->
      version = require(path.resolve file).version
      accumulator.push(version) if version?
      next(null, accumulator)
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
    semverStyle = @detect opts.version
    releaseVersion = @releaseBasedOn semverStyle

    tasks = [
      (next) =>
        opts.type = 'prerelease'
        @bumped.plugin.exec opts, next
      (next) ->
        releaseVersion
          version: opts.version
          prefix: opts.prefix
        , next
      (newVersion, next) =>
        @bumped._oldVersion = @bumped._version
        @update version: newVersion, next
      (next) =>
        opts.type = 'postrelease'
        @bumped.plugin.exec opts, next
    ]

    async.waterfall tasks, (err) =>
      return @bumped.logger.errorHandler err, cb if err
      cb null, @bumped._version

  update: ->
    [opts, cb] = DEFAULT.args arguments

    @bumped._version = opts.version

    async.forEachOf @bumped.config.rc.files, @save, (err) =>
      return @bumped.logger.errorHandler err, cb if err

      Animation.end
        logger   : @bumped.logger
        version  : @bumped._version

      cb()

  save: (file, index, cb) =>
    util.updateJSON
      filename : file
      property : 'version'
      value    : @bumped._version
      force    : index is 0
    , cb

  ###*
   * Print the current synchronized version.
  ###
  version: =>
    [opts, cb] = DEFAULT.args arguments

    if @bumped._version?
      @bumped.logger.success MSG.CURRENT_VERSION @bumped._version
    else
      @bumped.logger.errorHandler MSG.NOT_CURRENT_VERSION(), lineBreak:false

    return cb null, @bumped._version

  detect: (word) ->
    return 'semver' if util.includes DEFAULT.keywords.semver, word
    return 'nature' if util.includes DEFAULT.keywords.nature, word
    'numeric'

  releaseBasedOn: (type) =>
    return @_releasesBasedOnSemver if type is 'semver'
    return @_releaseBasedOnNatureSemver if type is 'nature'
    @_releasesBasedOnVersion

  _releaseBasedOnNatureSemver: (opts, cb) =>
    cb null, semver.inc(@bumped._version, DEFAULT.keywords.adapter[opts.version])

  _releasesBasedOnSemver: (opts, cb) =>
    cb null, semver.inc(@bumped._version, opts.version, opts.prefix)

  _releasesBasedOnVersion: (opts, cb) =>
    version = semver.clean opts.version
    version = semver.valid version
    return cb MSG.NOT_VALID_VERSION version unless version?
    return cb MSG.NOT_GREATER_VERSION(version, @bumped._version) unless semver.gt version, @bumped._version
    cb null, version
