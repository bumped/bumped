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
    @prerelease = @bumped.config.rc.plugins.prerelease
    @postrelease = @bumped.config.rc.plugins.postrelease
    @cache = {}

  exec: (opts, cb) ->
    type = @[opts.type]
    return cb null if @isEmpty type

    async.forEachOfSeries type, (settings, name, next) =>
      ## TODO: instead of require, use force-require
      plugin = @cache[settings.plugin] ?= require settings.plugin

      console.log()
      @bumped.logger.plugin "#{settings.plugin}: #{name}"
      plugin @bumped, settings, next

    , (err) ->
      console.log()
      cb err

  isEmpty: (plugins) ->
    return true unless plugins
    Object.keys(plugins).length is 0
