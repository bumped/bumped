'use strict'

path       = require 'path'
async      = require 'async'
CSON       = require 'season'
fs         = require 'fs-extra'
existsFile = require 'exists-file'
util       = require './Bumped.util'
DEFAULT    = require './Bumped.default'
MSG        = require './Bumped.messages'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @rc = require('rc') bumped.pkg.name, DEFAULT.scaffold(), null, (config) ->
      CSON.parse config

  autodetect: ->
    [opts, cb] = DEFAULT.args arguments

    tasks = [
      (next) =>
        return next() unless @rc.config
        fs.remove @rc.config, next
      (next) =>
        @rc.files =  DEFAULT.scaffold().files
        @rc.plugins = DEFAULT.scaffold().plugins

        async.each DEFAULT.detect, (file, next) =>
          @add file: file, next
        , next
    ]

    async.waterfall tasks, cb

  detect: ->
    [opts, cb] = DEFAULT.args arguments

    filePath = path.join(process.cwd(), opts.file)
    existsFile filePath, cb

  add: =>
    [opts, cb] = DEFAULT.args arguments

    if @hasFile opts.file
      message = MSG.NOT_ALREADY_ADD_FILE opts.file
      @bumped.logger.errorHandler message, lineBreak:false
      return cb message, @rc.files

    tasks = [
      (next) =>
        @detect opts, next,
      (exists, next) =>
        return @addFile opts, next if exists
        message = MSG.NOT_ADD_FILE opts.file
        @bumped.logger.errorHandler message, lineBreak:false
        return cb message, @rc.files
      (next) =>
        unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb err, @rc.files

  remove: =>
    [opts, cb] = DEFAULT.args arguments

    unless @hasFile opts.file
      message = MSG.NOT_REMOVE_FILE opts.file
      @bumped.logger.errorHandler message, lineBreak:false
      return cb message, @rc.files

    tasks = [
      (next) => @removeFile opts, next
      (next) => unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb(err, @rc.files)

  save: =>
    [opts, cb] = DEFAULT.args arguments

    util.saveCSON
      path : ".#{@bumped.pkg.name}rc"
      data :
        files: @rc.files
        plugins: @rc.plugins
    , cb

  load: =>
    [opts, cb] = DEFAULT.args arguments

    util.loadCSON
      path: @bumped.config.rc.config
    , (err, filedata) =>
      throw err if err
      @loadScaffold filedata
      cb()

  addFile: ->
    [opts, cb] = DEFAULT.args arguments

    @rc.files.push opts.file
    @bumped.logger.success MSG.ADD_FILE opts.file
    cb()

  removeFile: ->
    [opts, cb] = DEFAULT.args arguments

    index = @rc.files.indexOf opts.file
    @rc.files.splice index, 1
    @bumped.logger.success MSG.REMOVE_FILE opts.file
    cb()

  set: =>
    [opts, cb] = DEFAULT.args arguments

    setProperty = (file, done) ->
      util.updateJSON
        filename : file
        property : opts.property
        value    : opts.value
        force    : true
      , done

    message = null
    message = MSG.NOT_SET_PROPERTY() if util.size(opts.value) is 0
    message = MSG.NOT_SET_PROPERTY() if util.size(opts.property) is 0
    message = MSG.NOT_SET_VERSION() if opts.property is 'version'
    return @bumped.logger.errorHandler message, lineBreak:false, cb if message

    async.each @bumped.config.rc.files, setProperty, (err) =>
      return @bumped.logger.errorHandler err, cb if err
      @bumped.logger.success MSG.SET_PROPERTY opts.property, opts.value
      cb null, opts

  hasFile: (file) ->
    @rc.files.indexOf(file) isnt -1

  loadScaffold: (filedata) ->
    @bumped.config.rc.files = filedata.files
    @bumped.config.rc.plugins = filedata.plugins
