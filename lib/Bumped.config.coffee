'use strict'

fs      = require 'fs'
async   = require 'neo-async'
pkg     = require '../package.json'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @bumped.config = require('rc') pkg.name, DEFAULT.fileStructure

  autodetect: (opts, cb) =>
    @bumped.config.files = []
    async.each DEFAULT.checkFiles, (file, next) =>
      @detect file: file, outputMessage: opts.outputMessage, (exists) =>
        return next() unless exists
        @add file: file, next
    , cb

  detect: (opts, cb) ->
    fs.exists "#{process.cwd()}/#{opts.file}", (exists) =>
      return cb exists unless opts.outputMessage
      message = if exists then MSG.DETECTED_FILE else MSG.NOT_DETECTED_FILE
      @bumped.logger.info message opts.file
      cb exists

  add: (opts, cb) ->
    @bumped.config.files.push opts.file
    @bumped.logger.info MSG.ADD_FILE opts.file if opts.outputMessage
    return cb() unless opts.save
    @save cb

  save: (opts, cb) =>
    file = files: @bumped.config.files, plugins: []
    fs.writeFile ".#{pkg.name}rc", JSON.stringify(file, null, 2), encoding: 'utf8', cb
