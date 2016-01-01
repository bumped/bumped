'use strict'

chalk   = require 'chalk'
ms      = require 'pretty-ms'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

TYPE_SHORTCUT =
  prerelease: 'pre'
  postrelease: 'post'

module.exports = class Animation

  constructor: (params = {}) ->
    @[param] = value for param, value of params
    @isPostRelease = @type is 'postrelease'
    @isPreRelease  = @type is 'prerelease'

  start: (cb) ->
    @start = new Date()
    @running = true
    shortcut = TYPE_SHORTCUT[@type]
    process.stdout.write '\n' if @isPostRelease

    @logger.keyword = "#{chalk.magenta(shortcut)} #{@logger.keyword}"
    @logger.success "Starting '#{chalk.cyan(@text)}'..."
    cb()

  stop: (err, cb) ->
    @running = false
    return @logger.errorHandler err, lineBreak: false, cb if err

    end = ms new Date() - @start
    @logger.success "Finished '#{chalk.cyan(@text)}' after #{chalk.magenta(end)}."
    process.stdout.write '\n' if @isPreRelease
    @logger.keyword = DEFAULT.logger.keyword

    cb err

  @end: (opts) ->
    if opts.outputMessage
      diff = ms(new Date() - opts.start)
      message = "#{MSG.CREATED_VERSION(opts.version)} after #{chalk.magenta(diff)}."
      opts.logger.success message
      opts.logger.keyword = DEFAULT.logger.keyword
