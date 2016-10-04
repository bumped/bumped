'use strict'

path       = require 'path'
async      = require 'async'
fs         = require 'fs-extra'
existsFile = require 'exists-file'
jsonFuture = require 'json-future'
util       = require './Bumped.util'
DEFAULT    = require './Bumped.default'
MSG        = require './Bumped.messages'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @init()

  init: (files) =>
    @rc = util.initConfig
      appname: @bumped.pkg.name
      default: DEFAULT.scaffold()

  ###*
   * Special '.add' action that try to autodetect common configuration files
   * It doesn't print a error message if the file are not present
   * in the directory.
  ###
  autodetect: ->
    [opts, cb] = DEFAULT.args arguments

    tasks = [
      removePreviousConfigFile = (next) =>
        return next() unless @rc.config

        fs.remove @rc.config, (err) =>
          return next err if err
          @init()
          next()

      detectCommonFiles = (next) =>
        async.each DEFAULT.detectFileNames, (file, done) =>
          @add file:file, output:false, (err) -> done()
        , next
      fallbackUnderNotDetect = (next) =>
        return next() if @rc.files.length isnt 0
        @addFallback next
      generateDefaultPlugins = (next) =>
        @rc.plugins = DEFAULT.plugins @rc.files
        next()
    ]

    async.waterfall tasks, cb

  ###*
   * Special '.add' action to be called when autodetect fails.
  ###
  addFallback: (cb) ->
    opts =
      file: DEFAULT.fallbackFileName
      data: version:'0.0.0'

    tasks = [
      createFallbackFile = (next) -> util.createJSON opts, next
      addFallbackFile = (next) => @addFile opts, next
    ]

    async.waterfall tasks, cb

  ###*
   * Add a file into configuration file.
   * Before do it, check:
   *  - The file was previously added.
   *  - The file that are you trying to add exists.
  ###
  add: =>
    [opts, cb] = DEFAULT.args arguments

    loggerOptions =
      lineBreak: false
      output: opts.output

    if @hasFile opts.file
      message = MSG.NOT_ALREADY_ADD_FILE opts.file
      return @bumped.logger.errorHandler message, loggerOptions, cb

    tasks = [
      (next) =>
        @detect opts, next,
      (exists, next) =>
        return @addFile opts, next if exists
        message = MSG.NOT_ADD_FILE opts.file
        return @bumped.logger.errorHandler message, loggerOptions, cb
      (next) =>
        unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb err, @rc.files

  ###*
   * Detect if a configuration file exists in the project path.
  ###
  detect: ->
    [opts, cb] = DEFAULT.args arguments

    filePath = path.join(process.cwd(), opts.file)
    existsFile filePath, cb

  remove: =>
    [opts, cb] = DEFAULT.args arguments

    unless @hasFile opts.file
      message = MSG.NOT_REMOVE_FILE opts.file
      return @bumped.logger.errorHandler message, lineBreak:false, cb

    tasks = [
      (next) => @removeFile opts, next
      (next) => unless opts.save then next() else @save opts, next
    ]

    async.waterfall tasks, (err, result) =>
      cb(err, @rc.files)

  ###*
   * Write from memory to config file.
  ###
  save: =>
    [opts, cb] = DEFAULT.args arguments

    util.saveConfig
      path : ".#{@bumped.pkg.name}rc"
      data :
        files: @rc.files
        plugins: @rc.plugins
    , cb

  load: =>
    [opts, cb] = DEFAULT.args arguments

    util.loadConfig
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
