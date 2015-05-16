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
    async.each DEFAULT.detect, (file, next) =>
      @detect file: file, outputMessage: opts.outputMessage, (exists) =>
        return next() unless exists
        @add file: file, next
    , cb

  detect: (opts, cb) ->
    fs.exists "#{process.cwd()}/#{opts.file}", (exists) =>
      return cb exists unless opts.outputMessage
      if exists
        @bumped.logger.info MSG.DETECTED_FILE opts.file
      else
        @bumped.logger.error MSG.NOT_DETECTED_FILE opts.file
      cb exists

  add: (opts, cb) ->
    tasks = [
      (next) => unless opts.detect then next() else @detectFile opts, next
      (next) => @addFile opts, next
      (next) => unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb(err, @bumped.config.files)


  save: (opts, cb) =>
    file = files: @bumped.config.files
    fs.writeFile ".#{pkg.name}rc", JSON.stringify(file, null, 2), encoding: 'utf8', cb

  detectFile: (opts, cb) ->
    @detect opts, (exists) =>
      return cb(MSG.DETECTED_FILE opts.file) unless exists
      cb()

  addFile: (opts, cb) ->
    if @isPresent opts.file
      message = MSG.ALREADY_FILE opts.file
      @bumped.logger.error message if opts.outputMessage
      return cb message
    @bumped.config.files.push opts.file
    @bumped.logger.info MSG.ADD_FILE opts.file if opts.outputMessage
    cb()

  isPresent: (file) ->
    @bumped.config.files.indexOf(file) isnt -1
