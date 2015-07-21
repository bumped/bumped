'use strict'

os      = require 'os'
path    = require 'path'
CSON    = require 'season'
fs      = require 'fs-extra'
dotProp = require 'dot-prop'
exists  = require 'exists-file'

module.exports = class Util

  constructor: (bumped) ->
    @bumped = bumped

  ###*
   * A sweet way to update JSON Arrays, Objects or String from String.
   * @param  {Object}   opts [description]
   * @param  {Function} cb   Standard NodeJS callback.
   * @return {[type]}        Standard NodeJS callback.
  ###
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

  loadCSON: (opts, cb) ->
    fs.readFile opts.path, encoding: 'utf8', (err, data) ->
      return cb err if err
      cb null, CSON.parse data

  saveCSON: (opts, cb) ->
    data = CSON.stringify opts.data, null, 2
    fs.writeFile opts.path, data, encoding: 'utf8', cb
