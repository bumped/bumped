'use strict'

path       = require 'path'
CSON       = require 'season'
fs         = require 'fs-extra'
dotProp    = require 'dot-prop'
jsonFuture = require 'json-future'

module.exports =

  ###*
   * A sweet way to update JSON Arrays, Objects or String from String.
   * @param  {Object}   opts [description]
   * @param  {Function} cb   Standard NodeJS callback.
   * @return {[type]}        Standard NodeJS callback.
  ###
  updateJSON: (opts, cb) ->
    jsonFuture.loadAsync opts.filename, (err, file) ->
      return cb err if err

      firstChar = opts.value.charAt(0)
      lastChar = opts.value.charAt(opts.value.length - 1)
      isArray = (firstChar is '[') and (lastChar is ']')
      isDotProp = opts.property.split('.').length > 1

      if isArray
        items = opts.value.substring(1, opts.value.length - 1)
        items = items.split(',')
        items = items.map (item) -> item.trim()
        file[opts.property] = items
      else if isDotProp
        dotProp.set(file, opts.property, opts.value)
      else
        file[opts.property] = opts.value

      jsonFuture.saveAsync(opts.filename, file, cb)

  loadCSON: (opts, cb) ->
    fs.readFile opts.path, encoding: 'utf8', (err, data) ->
      return cb err if err
      cb null, CSON.parse data

  saveCSON: (opts, cb) ->
    data = CSON.stringify opts.data, null, 2
    fs.writeFile opts.path, data, encoding: 'utf8', cb

  isArray: Array.isArray
  isEmpty: (arr) -> arr.length is 0
  includes: (arr, word) -> arr.indexOf(word) isnt -1
  noop: ->
