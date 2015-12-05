'use strict'

Acho         = require 'acho'
chalk        = require 'chalk'
DEFAULT      = require './Bumped.default'
existsAssign = require 'existential-assign'

module.exports = (opts) ->
  opts = existsAssign DEFAULT.logger, opts
  logger = Acho opts

  # Extending with error handler
  logger.errorHandler = (err, cb) ->
    @error err
    cb err

  logger
