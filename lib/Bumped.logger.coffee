'use strict'

Acho          = require 'acho'
DEFAULT       = require './Bumped.default'
MSG           = require './Bumped.messages'
existsDefault = require 'existential-default'
noop          = require('./Bumped.util').noop
isArray       = require('./Bumped.util').isArray

optsDefault =
  lineBreak: true

errorHandler = (err, opts, cb) ->
  if (arguments.length is 2 and typeof arguments[1] is 'function')
    cb = opts
    opts = optsDefault
  else
    opts or= optsDefault
    cb or= noop

  return cb err if @level is 'silent'
  err = MSG.NOT_PROPERLY_FINISHED err if typeof err is 'boolean'

  printErrorMessage = (err) => @error err.message or err
  process.stdout.write '\n' if opts.lineBreak
  err = if isArray err then err else [err]
  err.forEach printErrorMessage
  cb err

module.exports = (opts) ->
  opts = existsDefault opts, DEFAULT.logger
  logger = Acho opts
  logger.errorHandler = errorHandler
  logger
