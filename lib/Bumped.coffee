'use strict'

fs      = require 'fs'
os      = require 'os'
Acho    = require 'acho'
path    = require 'path'
semver  = require 'semver'
async   = require 'neo-async'
DEFAULT = require './Bumped.default'
pkg     = require '../package.json'

module.exports = class Bumped

  constructor: (options = {}) ->
    process.chdir options.cwd if options.cwd?
    @config = require('rc')(pkg.name, {})
    @logger = new Acho(options.logger)
    this

  init: (cb) ->
    @config = require('rc')(pkg.name, DEFAULT.fileStructure)
    async.series [@detectFiles, @writeConfig, @syncVersion], (err, result) =>
      @logError err, cb
      @logger.success "Config file created!."
      cb()

  writeConfig: (cb) =>
    file = files: @config.files, plugins: []
    fs.writeFile ".#{pkg.name}rc", JSON.stringify(file, null, 2), encoding: 'utf8', cb

  detectFiles: (cb) =>
    async.each DEFAULT.checkFiles, (file, next) =>
      fs.exists "#{process.cwd()}/#{file}", (exists) =>
        if exists
          @logger.info "Detected '#{file}' in the directory. Aded into the configuration file."
          @addFile file, logger: false, next
    , cb

  version: (newVersion) ->
    return @_version if arguments.length is 0
    @_version = newVersion

  syncVersion: (cb) =>
    async.compose(@maxVersion, @filesVersion) (err, max) =>
      @_version = max
      cb()

  filesVersion: (cb) =>
    async.map @config.files, (file, next) ->
      version = require(path.resolve(file)).version
      next(null, version)
    , cb

  maxVersion: (versions, cb) ->
    initial = versions.shift()
    async.reduce versions, initial, (max, version, next) ->
      max = version if semver.gt version, max
      next(null, max)
    , cb

  logError: (err, cb) ->
    if err
      logger.error err.message
      return cb(err)

  addFile: (name, options = {logger: false}, cb) ->
    @config.files.push name
    @logger.info "File '#{name}' added." if options.logger
    cb?()

  increment: (release, cb) ->
    newVersion = semver.inc @version(), release
    @version newVersion
    async.each @config.files, @saveVersion, (err) =>
      @logError err, cb
      @logger.success "Created version #{@version()}"
      cb?()

  saveVersion: (file, cb) =>
    filepath = path.resolve file
    file = require filepath
    file.version = @version()
    fileoutput = JSON.stringify(file, null, 2) + os.EOL
    fs.writeFile filepath, fileoutput, encoding: 'utf8', cb
