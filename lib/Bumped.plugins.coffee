'use strict'

async = require 'async'

###*
 * Bumped.plugins
 *
 * Module to call each plugin declared for the user in the configuration file.
 * Modules follow a duck type interface and are sorted.
 * If any plugin throw and error, automatically stop the rest of the plugins.
###
module.exports = class Plugins

  constructor: (bumped) ->
    @bumped = bumped
    [ @prerelease, @postrelease ] = @bumped.config.rc.plugins
    @cache = {}

  execPreReleases: (opts, cb) ->

    async.eachSeries @prerelease, (objt, next) ->
      plugin = @cache[objt.plugin] ?= require objt.plugin
      config = @prerelease.objt.key
      plugin @bumped, config, next
    , (err) =>
      @abort err if err
      cb()

  abort: (err) ->
