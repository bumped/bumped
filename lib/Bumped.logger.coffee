'use strict'

Acho         = require 'acho'
objectAssign = require 'object-assign'
DEFAULT      = require './Bumped.default'
chalk        = require 'acho/node_modules/chalk'
output       = (color) -> (message) -> console.log chalk[color] message

Acho::errorHandler = (err, cb) ->
  @error err
  cb err

module.exports = (opts) ->
  opts = objectAssign {types: DEFAULT.loggerTypes()}, opts
  logger = new Acho opts
  logger.output = output logger.types.line.color
  logger
