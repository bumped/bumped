'use strict'

path           = require 'path'
async          = require 'async'
forceResolve   = require 'force-resolve'
updateNotifier = require 'update-notifier'
cloneDeep      = require 'lodash.clonedeep'
Animation      = require './Bumped.animation'

###*
 * Bumped.plugins
 *
 * Module to call each plugin declared for the user in the configuration file.
 * Modules follow a duck type interface and are sorted.
 * If any plugin throw and error, automatically stop the rest of the plugins.
###
module.exports = class Plugin

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

      pluginObjt = cloneDeep settings
      pluginObjt.logger = @bumped.logger

      animation = new Animation
        text: description
        logger: @bumped.logger
        plugin: settings.plugin

      animation.start =>
        plugin @bumped, pluginObjt, (err) ->
          animation.stop err, next
    , cb


  isEmpty: (plugins = []) ->
    Object.keys(plugins).length is 0

  notifyPlugin: (pluginPath) ->
    pkgPath = path.join pluginPath, 'package.json'
    updateNotifier({pkg: require(pkgPath)}).notify()
