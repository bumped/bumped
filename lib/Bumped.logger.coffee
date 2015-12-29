'use strict'

Acho         = require 'acho'
chalk        = require 'chalk'
DEFAULT      = require './Bumped.default'
existsAssign = require 'existential-assign'

module.exports = (opts) ->
  opts = existsAssign DEFAULT.logger, opts
  logger = Acho opts

  # Extending with error handler
  logger.errorHandler = (err, opts, cb) ->
    optsDefault = lineBreak: true

    if (arguments.length is 2)
      cb = opts
      opts = optsDefault
    else
      opts = opts or optsDefault
      cb = cb or ->

    printErrorMessage = (err) => @error err.message or err

    process.stdout.write '\n' if opts.lineBreak
    err = if Array.isArray(err) then err else [err]

    err.forEach printErrorMessage
    @keyword = DEFAULT.logger.keyword
    cb err

  logger
