'use strict'

os     = require 'os'
path   = require 'path'
fs     = require 'fs-extra'
dotProp = require 'dot-prop'

module.exports = class Util

  constructor: (bumped) ->
    @bumped = bumped

  updateJSON: (opts, cb) ->
    filepath = path.resolve opts.filename
    file = require filepath
    firstChar = opts.value.charAt(0);
    lastChar = opts.value.charAt(opts.value.length - 1);
    isArray = (firstChar is '[') and (lastChar is ']')
    isDotProp = opts.property.split('.').length > 1

    if isArray
      items = opts.value.substring(1, opts.value.length - 1)
      items = items.split(',')
      items = items.map (item) -> item.trim()
      file[opts.property] = items
    else if isDotProp
      dotProp.set(file, opts.property, opts.value);
    else
      file[opts.property] = opts.value

    fileoutput = JSON.stringify(file, null, 2) + os.EOL
    fs.writeFile filepath, fileoutput, encoding: 'utf8', cb

  saveJSON: (opts, cb) ->
    filepath = path.resolve opts.filename
    fs.writeFile filepath, opts.data, encoding: 'utf8', cb

  existsFile: (filepath, cb) ->
    fs.stat filepath, (err, stats) ->
      return cb null, true unless err?
      return cb null, false if err.code is 'ENOENT'
      cb err, stats

  throwError: (message, cb) ->
    err = new Error()
    err.message = message
    @bumped.logger.errorHandler err, cb
