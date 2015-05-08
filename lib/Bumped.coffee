'use strict'

async   = require 'neo-async'
Semver  = require './Bumped.semver'
DEFAULT = require './Bumped.default'
Config  = require './Bumped.config'
Logger  = require './Bumped.logger'

module.exports = class Bumped

  constructor: (options = {}) ->
    process.chdir options.cwd if options.cwd?
    @config = new Config(this)
    @semver = new Semver(this)
    @logger = new Logger(options.logger)
    this

  init: (cb) ->
    async.series [@config.detect, @config.save, @semver.sync], (err, result) =>
      @logger.errorHandler err, cb
      @logger.success "Config file created!."
      cb()
