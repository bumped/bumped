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

  start: (cb) ->
    @start = new Date()
    @running = true

    shortcut = TYPE_SHORTCUT[@type]
    name = @plugin.replace /bumped-/, ''
    @logger.keyword = "#{chalk.magenta(shortcut)} #{@logger.keyword}"
    @logger.success "Starting '#{chalk.cyan(@text)}'..."

    cb()

  stop: (err, cb) ->
    @running = false
    unless err
      end = ms new Date() - @start
      @logger.success "Finished '#{chalk.cyan(@text)}' after #{chalk.magenta(end)}."
      process.stdout.write '\n' unless @isLast and @isPostRelease

    @logger.keyword = DEFAULT.logger.keyword
    cb err

  @end: (opts) ->
    if opts.outputMessage
      diff = ms(new Date() - opts.start)
      message = "#{MSG.CREATED_VERSION(opts.version)} after #{chalk.magenta(diff)}."
      opts.logger.success message
      process.stdout.write '\n'
