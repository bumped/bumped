'use strict'

chalk    = require 'chalk'
ms       = require 'pretty-ms'
timeSpan = require 'time-span'
DEFAULT  = require './Bumped.default'
MSG      = require './Bumped.messages'

TYPE_SHORTCUT =
  prerelease: 'pre'
  postrelease: 'post'

module.exports = class Animation

  constructor: (params) ->
    @[param] = value for param, value of params
    @isPostRelease = @type is 'postrelease'
    @isPreRelease  = @type is 'prerelease'

  start: (cb) ->
    @timespan = timeSpan()
    @running = true
    shortcut = TYPE_SHORTCUT[@type]
    process.stdout.write '\n' if @isPostRelease

    @logger.keyword = "#{chalk.magenta(shortcut)} #{@logger.keyword}"
    @logger.success "Starting #{chalk.cyan(@text)}"
    cb()

  stop: (err, cb) ->
    @running = false

    if err
      @logger.keyword = DEFAULT.logger.keyword
      return cb err

    end = ms @timespan()
    @logger.success "Finished #{chalk.cyan(@text)} after #{chalk.magenta(end)}."
    process.stdout.write '\n' if @isPreRelease
    @logger.keyword = DEFAULT.logger.keyword
    cb()

  @end: (opts) ->
    opts.logger.success MSG.CREATED_VERSION(opts.version)
    opts.logger.keyword = DEFAULT.logger.keyword
