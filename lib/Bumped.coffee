'use strict'

fs      = require 'fs'
os      = require 'os'
Acho    = require 'acho'
path    = require 'path'
async   = require 'neo-async'
Semver  = require './Bumped.semver'
DEFAULT = require './Bumped.default'
Config  = require './Bumped.config'

module.exports = class Bumped

  constructor: (options = {}) ->
    process.chdir options.cwd if options.cwd?
    @config = new Config(this)
    @logger = new Acho(options.logger)
    @semver = new Semver(this)
    this

  init: (cb) ->
    async.series [@config.detect, @config.save, @semver.sync], (err, result) =>
      @errorHandler err, cb
      @logger.success "Config file created!."
      cb()

  errorHandler: (err, cb) ->
    if err
      logger.error err.message
      return cb(err)
