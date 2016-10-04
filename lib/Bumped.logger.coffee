'use strict'

Acho          = require 'acho'
DEFAULT       = require './Bumped.default'
MSG           = require './Bumped.messages'
noop          = require('./Bumped.util').noop
isArray       = require('./Bumped.util').isArray
isBoolean     = require('./Bumped.util').isBoolean

optsDefault =
  lineBreak: true
  output: true

###*
 * Unify error logging endpoint
 * @param  {Message}   err Error structure based on Message.
 * @param  {Object}   opts Configurable options
 * @param  {Object}   [opts.lineBreak=true] Prints Line break
 * @param  {Function} cb   [description]
###
errorHandler = (err, opts, cb) ->
  if (arguments.length is 2 and typeof arguments[1] is 'function')
    cb = opts
    opts = optsDefault
  else
    opts = Object.assign optsDefault, opts
    cb ||= noop

  return cb err if @level is 'silent' or not opts.output

  err = MSG.NOT_PROPERLY_FINISHED err if isBoolean err
  printErrorMessage = (err) => @error err.message or err
  process.stdout.write '\n' if opts.lineBreak
  err = [err] unless isArray(err)

  err.forEach printErrorMessage
  cb err

module.exports = (opts) ->
  opts = Object.assign DEFAULT.logger, opts
  logger = Acho opts
  logger.errorHandler = errorHandler
  logger
