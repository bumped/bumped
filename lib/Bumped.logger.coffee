'use strict'

Acho         = require 'acho'
objectAssign = require 'object-assign'
DEFAULT      = require './Bumped.default'
chalk        = require 'acho/node_modules/chalk'

# A new logger level method
loggerOutput = (color) ->
  (message) -> @transport chalk[color] message

# Extending native generateTypeMessage
generateTypeMessage = (type) ->
  (message, rawMode = false) ->
    if rawMode
      @generateMessage type, message
    else
      @transport @generateMessage type, message
      this

# Extending with error handler
Acho::errorHandler = (err, cb) ->
  @error err
  cb err

module.exports = (opts) ->
  opts = objectAssign {types: DEFAULT.loggerTypes()}, opts
  opts.generateTypeMessage = generateTypeMessage

  logger = new Acho opts
  logger.output = loggerOutput logger.types.line.color
  logger
