'use strict'

fs      = require 'fs'
os      = require 'os'
Acho    = require 'acho'
path    = require 'path'
async   = require 'neo-async'
pkg     = require '../package.json'
Semver  = require './Bumped.semver'
DEFAULT = require './Bumped.default'

module.exports = class Bumped

  constructor: (options = {}) ->
    process.chdir options.cwd if options.cwd?
    @config = require('rc')(pkg.name, {})
    @logger = new Acho(options.logger)
    @semver = new Semver(this)
    this

  init: (cb) ->
    @config = require('rc')(pkg.name, DEFAULT.fileStructure)
    async.series [@detect, @saveConfig, @semver.sync], (err, result) =>
      @errorHandler err, cb
      @logger.success "Config file created!."
      cb()

  saveConfig: (cb) =>
    file = files: @config.files, plugins: []
    fs.writeFile ".#{pkg.name}rc", JSON.stringify(file, null, 2), encoding: 'utf8', (err) =>
      cb(err, @config.files)

  detect: (cb) =>
    async.each DEFAULT.checkFiles, (file, next) =>
      fs.exists "#{process.cwd()}/#{file}", (exists) =>
        if exists
          @logger.info "Detected '#{file}' in the directory. Aded into the configuration file."
          @addFile file, logger: false, next
    , cb

  errorHandler: (err, cb) ->
    if err
      logger.error err.message
      return cb(err)

  addFile: (name, options = {logger: false}, cb) ->
    @config.files.push name
    @logger.info "File '#{name}' added." if options.logger
    cb?()
