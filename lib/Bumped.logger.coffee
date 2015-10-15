'use strict'

Acho         = require 'acho'
objectAssign = require 'object-assign'
DEFAULT      = require './Bumped.default'
chalk        = require 'acho/node_modules/chalk'

# Extending with error handler
Acho::errorHandler = (err, cb) ->
  @error err
  cb err

module.exports = (opts) ->
  opts = objectAssign DEFAULT.logger, opts
  logger = new Acho opts
  logger
