'use strict'

CSON    = require 'season'
fs      = require 'fs-extra'
async   = require 'neo-async'
Util    = require './Bumped.util'
Semver  = require './Bumped.semver'
Config  = require './Bumped.config'
Logger  = require './Bumped.logger'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

module.exports = class Bumped

  constructor: (opts = {}) ->
    process.chdir opts.cwd if opts.cwd?
    @pkg    = require '../package.json'
    @config = new Config this
    @semver = new Semver this
    @logger = new Logger opts.logger
    @util   = new Util this
    this

  start: ->
    args = DEFAULT.args arguments
    return args.cb() unless @config.rc.config
    @load args.opts, args.cb

  load: (opts, cb) ->
    fs.readFile @config.rc.config, 'utf8', (err, config) =>
      throw err if err
      config = CSON.parse config
      @config.rc.files = config.files
      @semver.sync opts, cb

  init: (opts, cb) =>
    args = DEFAULT.args arguments

    tasks = [
      (next) => @config.autodetect args.opts, next
      (next) => @config.save args.opts, next
      (next) => @semver.sync args.opts, next
    ]

    async.waterfall tasks, (err, result) =>
      @logger.errorHandler err, args.cb
      @end args.opts, args.cb

  end: (opts, cb) ->
    return @semver.version opts, cb unless opts.outputMessage?

    if @config.rc.files.length is 0
      @logger.warn MSG.NOT_AUTODETECTED()
      @logger.warn MSG.NOT_AUTODETECTED_2()

    @semver.version opts, =>
      @logger.success MSG.CONFIG_CREATED() if opts.outputMessage
      cb()
