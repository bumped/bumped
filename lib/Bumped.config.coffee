'use strict'

fs      = require 'fs'
async   = require 'neo-async'
pkg     = require '../package.json'
DEFAULT = require './Bumped.default'
MSG     = require './Bumped.messages'

module.exports = class Config

  constructor: (bumped) ->
    @bumped = bumped
    @bumped.config = require('rc')(pkg.name, DEFAULT.fileStructure)

  detect: (opts, cb) =>
    @bumped.config.files = []
    async.each DEFAULT.checkFiles, (file, next) =>
      fs.exists "#{process.cwd()}/#{file}", (exists) =>
        return next() unless exists
        @bumped.logger.info MSG.DETECTED_FILE(file) if opts.outputMessage
        @add filename:file, next
    , cb

  add: (opts, cb) ->
    @bumped.config.files.push opts.filename
    cb()

  save: (opts, cb) =>
    file = files: @bumped.config.files, plugins: []
    fs.writeFile ".#{pkg.name}rc", JSON.stringify(file, null, 2), encoding: 'utf8', cb
