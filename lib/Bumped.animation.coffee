'use strict'

logUpdate     = require 'log-update'
eleganSpinner = require 'elegant-spinner'
chalk         = require 'acho/node_modules/chalk'

module.exports = class Animation

  constructor: (params = {}) ->
    @frame = eleganSpinner()
    @interval = params.interval or 30

    @logger = params.logger
    @logLevel = params.logLevel

    @text = params.text

  start: (cb) ->
    @running = true
    message = @logger[@logLevel] @text, 'raw'
    color = @logger.types.line.color

    @_intervalObject = setInterval =>
      if @running
        logUpdate("#{message} #{chalk[color](@frame())}")
      else
        logUpdate message
        clearInterval @_intervalObject
    , @interval

    setTimeout cb, @interval

  stop: (cb) =>
    @running = false
    process.stdin.write '\n'
    setTimeout cb, @interval
