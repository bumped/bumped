'use strict'

logUpdate     = require 'log-update'
eleganSpinner = require 'elegant-spinner'
chalk         = require 'acho/node_modules/chalk'

module.exports = class Animation

  constructor: (params = {}) ->
    @text = params.text
    @logger = params.logger

  start: (cb) ->
    @running = true
    @logger.plugin @text
    cb()

  stop: (cb) ->
    @running = false
    cb()
