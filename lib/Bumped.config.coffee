'use strict'

CSON    = require 'season'
fs      = require 'fs-extra'
async   = require 'neo-async'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @rc = require('rc') bumped.pkg.name, DEFAULT.structure(), null, (config) -> CSON.parse config

  autodetect: (opts, cb) ->
    tasks = [
      (next) =>
        return next() unless @rc.config
        fs.remove @rc.config, (err) -> next()
      (next) =>
        @rc.files = DEFAULT.structure().files
        async.each DEFAULT.detect, (file, done) =>
          @detect file: file, outputMessage: false, (exists) =>
            return done() unless exists
            @bumped.logger.info MSG.DETECTED_FILE file if opts.outputMessage
            @add file: file, done
        , next
    ]

    async.waterfall tasks, cb

  detect: (opts, cb) ->
    fs.exists "#{process.cwd()}/#{opts.file}", (exists) =>
      return cb exists unless opts.outputMessage
      if opts.outputMessage
        if exists
          @bumped.logger.info MSG.DETECTED_FILE opts.file
        else
          @bumped.logger.error MSG.NOT_DETECTED_FILE opts.file
      cb exists

  add: (opts, cb) =>
    if @hasFile opts.file
      message = MSG.ADD_ALREADY_FILE opts.file
      @bumped.logger.error message if opts.outputMessage
      return cb message, @rc.files

    tasks = [
      (next) => unless opts.detect then next() else @detectFile opts, next
      (next) => @addFile opts, next
      (next) => unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb err, @rc.files

  remove: (opts, cb) =>
    unless @hasFile opts.file
      message = MSG.NOT_REMOVE_FILE opts.file
      @bumped.logger.error message if opts.outputMessage
      return cb message, @rc.files

    tasks = [
      (next) => @removeFile opts, next
      (next) => unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb(err, @rc.files)

  save: (opts, cb) =>
    file = files: @rc.files
    fs.writeFile ".#{@bumped.pkg.name}rc", CSON.stringify(file, null, 2), encoding: 'utf8', cb

  detectFile: (opts, cb) ->
    @detect opts, (exists) ->
      return cb MSG.DETECTED_FILE opts.file unless exists
      cb()

  addFile: (opts, cb) ->
    @rc.files.push opts.file
    @bumped.logger.info MSG.ADD_FILE opts.file if opts.outputMessage
    cb()

  removeFile: (opts, cb) ->
    index = @rc.files.indexOf opts.file
    @rc.files.splice index, 1
    @bumped.logger.info MSG.REMOVE_FILE opts.file if opts.outputMessage
    cb()

  hasFile: (file) ->
    @rc.files.indexOf(file) isnt -1
