'use strict'

async   = require 'neo-async'
Semver  = require './Bumped.semver'
Config  = require './Bumped.config'
Logger  = require './Bumped.logger'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

module.exports = class Bumped

  constructor: (opts = {}) ->
    process.chdir opts.cwd if opts.cwd?
    @config = new Config(this)
    @semver = new Semver(this)
    @logger = new Logger(opts.logger)

  init: (opts, cb) =>
    args = DEFAULT.args(arguments)

    tasks = [
      (next) => @config.detect(args.opts, next)
      (next) => @config.save(args.opts, next)
      (next) => @semver.sync(args.opts, next)
    ]

    async.waterfall tasks, (err, result) =>
      @logger.errorHandler err, args.cb
      @logger.success MSG.CONFIG_CREATED() if args.opts.outputMessage
      args.cb()
