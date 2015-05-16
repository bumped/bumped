'use strict'

fs      = require 'fs-extra'
async   = require 'neo-async'
Semver  = require './Bumped.semver'
Config  = require './Bumped.config'
Logger  = require './Bumped.logger'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'
pkg     = require '../package.json'

module.exports = class Bumped

  constructor: (opts = {}) ->
    process.chdir opts.cwd if opts.cwd?
    @config = new Config this
    @semver = new Semver this
    @logger = new Logger opts.logger
    this

  start: ->
    args = DEFAULT.args arguments
    filepath = "#{process.cwd()}/.#{pkg.name}rc"
    fs.open filepath, 'r', (err, fileDescriptor) =>
      return @init args.opts, args.cb  if err
      args.opts.filepath = filepath
      @load args.opts, args.cb

  load: (opts, cb) ->
    fs.readJSON opts.filepath, (err, config) =>
      throw err if err
      @config.files = config.files
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

    if @config.files.length is 0
      @logger.warn MSG.NOT_AUTODETECTED()
      @logger.warn MSG.NOT_AUTODETECTED_2()

    @semver.version opts, =>
      @logger.success MSG.CONFIG_CREATED() if opts.outputMessage
      cb()
