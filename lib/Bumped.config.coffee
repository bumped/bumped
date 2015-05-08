'use strict'

fs      = require 'fs'
async   = require 'neo-async'
pkg     = require '../package.json'
DEFAULT = require './Bumped.default'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @bumped.config = require('rc')(pkg.name, {})

  detect: (cb) =>
    @bumped.config = require('rc')(pkg.name, DEFAULT.fileStructure)
    async.each DEFAULT.checkFiles, (file, next) =>
      fs.exists "#{process.cwd()}/#{file}", (exists) =>
        if exists
          @bumped.logger.info "Detected '#{file}' in the directory. Aded into the configuration file."
          @add file, logger: false, next
    , cb

  add: (name, options = {logger: false}, cb) ->
    @bumped.config.files.push name
    @bumped.logger.info "File '#{name}' added." if options.logger
    cb?()

  save: (cb) =>
    file = files: @bumped.config.files, plugins: []
    fs.writeFile ".#{pkg.name}rc", JSON.stringify(file, null, 2), encoding: 'utf8', (err) =>
      cb(err, @bumped.config.files)
