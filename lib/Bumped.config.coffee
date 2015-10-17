'use strict'

async      = require 'async'
CSON       = require 'season'
fs         = require 'fs-extra'
existsFile = require 'exists-file'
DEFAULT    = require './Bumped.default'
MSG        = require './Bumped.messages'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @rc = require('rc') bumped.pkg.name, DEFAULT.scaffold(), null, (config) -> CSON.parse config

  autodetect: ->
    [opts, cb] = DEFAULT.args arguments

    tasks = [
      (next) =>
        return next() unless @rc.config
        fs.remove @rc.config, next
      (next) =>
        @saveScaffold()
        async.each DEFAULT.detect, (file, done) =>
          @detect file: file, outputMessage: false, (exists) =>
            return done() unless exists
            @bumped.logger.success MSG.DETECTED_FILE file if opts.outputMessage
            @add file: file, done
        , next
    ]

    async.waterfall tasks, cb

  detect: ->
    [opts, cb] = DEFAULT.args arguments

    existsFile "#{process.cwd()}/#{opts.file}", (err, exists) =>
      return cb err if err
      return cb exists unless opts.outputMessage
      if exists
        @bumped.logger.success MSG.DETECTED_FILE opts.file
      else
        @bumped.logger.error MSG.NOT_DETECTED_FILE opts.file
      cb exists

  add: =>
    [opts, cb] = DEFAULT.args arguments

    if @hasFile opts.file
      message = MSG.ADD_ALREADY_FILE opts.file
      @bumped.logger.error message if opts.outputMessage
      return cb message, @rc.files

    opts.outputMessageType = 'success'

    tasks = [
      (next) => unless opts.detect then next() else @detectFile opts, next
      (next) => @addFile opts, next
      (next) => unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb err, @rc.files

  remove: =>
    [opts, cb] = DEFAULT.args arguments

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

  save: =>
    [opts, cb] = DEFAULT.args arguments

    @bumped.util.saveCSON
      path : ".#{@bumped.pkg.name}rc"
      data :
        files: @rc.files
        plugins: @rc.plugins
    , cb

  load: =>
    [opts, cb] = DEFAULT.args arguments

    @bumped.util.loadCSON
      path: @bumped.config.rc.config
    , (err, filedata) =>
      throw err if err
      @loadScaffold filedata
      cb()

  detectFile: ->
    [opts, cb] = DEFAULT.args arguments

    @detect opts, (exists) ->
      return cb MSG.DETECTED_FILE opts.file unless exists
      cb()

  addFile: ->
    [opts, cb] = DEFAULT.args arguments

    @rc.files.push opts.file
    outputMessageType = opts.outputMessageType or 'info'
    @bumped.logger[outputMessageType] MSG.ADD_FILE opts.file if opts.outputMessage
    cb()

  removeFile: ->
    [opts, cb] = DEFAULT.args arguments

    index = @rc.files.indexOf opts.file
    @rc.files.splice index, 1
    @bumped.logger.success MSG.REMOVE_FILE opts.file if opts.outputMessage
    cb()

  set: =>
    [opts, cb] = DEFAULT.args arguments

    setProperty = (file, done) =>
      @bumped.util.updateJSON
        filename : file
        property : opts.property
        value    : opts.value
      , done

    return @bumped.logger.errorHandler MSG.NOT_SET_PROPERTY(), cb unless opts.property or opts.value
    return @bumped.logger.errorHandler MSG.NOT_SET_VERSION(), cb if opts.property is 'version'

    async.each @bumped.config.rc.files, setProperty, (err) =>
      return @bumped.logger.errorHandler err, cb if err
      @bumped.logger.success MSG.SET_PROPERTY opts.property, opts.value if opts.outputMessage
      cb null, opts

  hasFile: (file) ->
    @rc.files.indexOf(file) isnt -1

  saveScaffold: ->
    [@rc.files, @rc.plugins] = [DEFAULT.scaffold().files, DEFAULT.scaffold().plugins]

  loadScaffold: (filedata) ->
    @bumped.config.rc.files = filedata.files
    @bumped.config.rc.plugins = filedata.plugins
