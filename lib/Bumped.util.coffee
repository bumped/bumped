'use strict'

rc          = require 'rc'
async       = require 'async'
fs          = require 'fs-extra'
dotProp     = require 'dot-prop'
jsonFuture  = require 'json-future'
parser      = require 'parse-config-file'
parserAsync = async.asyncify parser
serializer  = require('yaml-parser').safeDump

module.exports =

  createJSON: (opts, cb)->
    jsonFuture.saveAsync opts.file, opts.data, (err) -> cb err

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
        file[opts.property] = opts.value if file[opts.property]? or opts.force

      jsonFuture.saveAsync(opts.filename, file, cb)

  initConfig: (opts) ->
    rc opts.appname, opts.default, null, parser

  loadConfig: (opts, cb) ->
    tasks = [
      (next) -> fs.readFile opts.path, encoding:'utf8', next
      parserAsync
    ]

    async.waterfall tasks, cb

  saveConfig: (opts, cb) ->
    data = serializer opts.data
    fs.writeFile opts.path, data, encoding: 'utf8', (err) -> cb(err)

  isBoolean: (n) ->
    typeof n is 'boolean'

  isArray: Array.isArray

  isEmpty: (arr) ->
    arr.length is 0

  includes: (arr, word) ->
    arr.indexOf(word) isnt -1

  noop: ->

  size: (arr) ->
    return 0 unless arr
    arr.length
