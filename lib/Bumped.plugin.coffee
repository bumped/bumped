'use strict'

path           = require 'path'
async          = require 'async'
resolveUp      = require 'resolve-up'
spawnSync      = require 'spawn-sync'
globalNpmPath  = require 'global-modules'
updateNotifier = require 'update-notifier'
clone          = require 'lodash.clonedeep'
MSG            = require './Bumped.messages'
Animation      = require './Bumped.animation'
isEmpty        = require('./Bumped.util').isEmpty

npmInstallGlobal = (pkg) ->
  spawnSync 'npm', [ 'install', pkg ],
    stdio: 'inherit'
    cwd: globalNpmPath

###*
 * Bumped.plugin
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

  pluginPath: (plugin) ->
    pluginPath = resolveUp plugin
    return pluginPath[0] if pluginPath.length > 0
    @bumped.logger.warn MSG.INSTALLING_PLUGIN plugin
    @bumped.logger.warn MSG.INSTALLING_PLUGIN_2()
    npmInstallGlobal plugin
    path.resolve globalNpmPath, plugin

  exec: (opts, cb) ->
    pluginType = @[opts.type]
    return cb null if isEmpty Object.keys pluginType

    async.forEachOfSeries pluginType, (settings, description, next) =>
      pluginPath = @pluginPath settings.plugin
      @notifyPlugin pluginPath
      plugin = @cache[settings.plugin] ?= require pluginPath

      pluginObjt = clone settings
      pluginObjt.logger = @bumped.logger

      animation = new Animation
        text   : description
        logger : @bumped.logger
        plugin : settings.plugin
        type   : opts.type

      animation.start =>
        plugin @bumped, pluginObjt, (err) ->
          animation.stop err, next
    , cb

  notifyPlugin: (pluginPath) ->
    pkgPath = path.join pluginPath, 'package.json'
    updateNotifier({pkg: require(pkgPath)}).notify()
