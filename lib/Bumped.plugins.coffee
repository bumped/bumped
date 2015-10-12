'use strict'

path           = require 'path'
async          = require 'async'
forceResolve   = require 'force-resolve'
updateNotifier = require 'update-notifier'
Animation      = require './Bumped.animation'

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

    async.forEachOfSeries type, (settings, description, next) =>
      pluginPath = forceResolve(settings.plugin)[0]
      @notifyPlugin pluginPath
      plugin = @cache[settings.plugin] ?= require pluginPath

      animation = new Animation
        logger: @bumped.logger
        logLevel: 'plugin'
        text: "#{settings.plugin}: #{description}"

      animation.start =>
        plugin @bumped, settings, (err, message) =>
          animation.stop =>
            @print err, message, next
    , cb

  print: (err, message, cb) ->
    return cb err if err
    if message?
      message = message.replace /\n$/, '' # deletes last line break
      @bumped.logger.output message
    cb()

  isEmpty: (plugins = []) ->
    Object.keys(plugins).length is 0

  notifyPlugin: (pluginPath) ->
    pkgPath = path.join pluginPath, 'package.json'
    updateNotifier({pkg: require(pkgPath)}).notify()
