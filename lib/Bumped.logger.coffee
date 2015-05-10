'use strict'

Acho = require 'acho'

Acho::errorHandler = (err, cb) ->
  if err
    @error err.message
    return cb err

module.exports = Acho
