'use strict'

async   = require 'async'
Semver  = require './Bumped.semver'
Config  = require './Bumped.config'
Logger  = require './Bumped.logger'
Plugin  = require './Bumped.plugin'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

module.exports = class Bumped

  constructor: (opts = {}) ->
    process.chdir opts.cwd if opts.cwd
    @pkg = require '../package.json'
    @config = new Config this
    @semver = new Semver this
    @logger = new Logger opts.logger
    @plugin = new Plugin this

    this

  ###*
   * Load a previously cofinguration file declared.
  ###
  load: ->
    [opts, cb] = DEFAULT.args arguments

    return cb() unless @config.rc.config

    tasks = [
      (next) => @config.load opts, next
      (next) => @semver.sync opts, next
    ]

    async.series tasks, cb

  ###*
   * Initialize a new configuration file in the current path.
  ###
  init: =>
    [opts, cb] = DEFAULT.args arguments

    tasks = [
      (next) => @config.autodetect opts, next
      (next) => @config.save opts, next
      (next) => @semver.sync opts, next
    ]

    async.waterfall tasks, (err, result) =>
      return @logger.errorHandler err, cb if err
      @end opts, cb

  end: ->
    [opts, cb] = DEFAULT.args arguments

    @semver.version opts, =>
      @logger.success MSG.CONFIG_CREATED()
      cb()
