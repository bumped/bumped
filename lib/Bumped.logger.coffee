'use strict'

Acho         = require 'acho'
DEFAULT      = require './Bumped.default'
existsAssign = require 'existential-assign'

optsDefault =
  lineBreak: true

errorHandler = (err, opts, cb) ->

  if (arguments.length is 2 and typeof arguments[1] is 'function')
    cb = opts
    opts = optsDefault
  else
    opts = opts or optsDefault
    cb = cb or ->

  return cb err if @level is 'silent'

  printErrorMessage = (err) => @error err.message or err
  process.stdout.write '\n' if opts.lineBreak

  err = if Array.isArray(err) then err else [err]
  err.forEach printErrorMessage

  cb err

module.exports = (opts) ->
  opts = existsAssign DEFAULT.logger, opts
  logger = Acho opts
  logger.errorHandler = errorHandler
  logger
