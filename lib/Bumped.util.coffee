'use strict'

os     = require 'os'
path   = require 'path'
fs     = require 'fs-extra'

module.exports = class Util

  constructor: (bumped) ->
    @bumped = bumped

  updateJSON: (opts, cb) ->
    filepath = path.resolve opts.filename
    file = require filepath
    file[opts.property] = opts.value
    fileoutput = JSON.stringify(file, null, 2) + os.EOL
    fs.writeFile filepath, fileoutput, encoding: 'utf8', cb

  saveJSON: (opts, cb) ->
    filepath = path.resolve opts.filename
    fs.writeFile filepath, opts.data, encoding: 'utf8', cb

  throwError: (message, cb) ->
    err = new Error()
    err.message = message
    @bumped.logger.errorHandler err, cb
