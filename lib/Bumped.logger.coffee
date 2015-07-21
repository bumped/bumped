'use strict'

Acho         = require 'acho'
objectAssign = require 'object-assign'
DEFAULT      = require './Bumped.default'

Acho::errorHandler = (err, cb) ->
  @error err
  cb err

module.exports = (opts) ->
  opts = objectAssign {types: DEFAULT.loggerTypes()}, opts
  new Acho opts
