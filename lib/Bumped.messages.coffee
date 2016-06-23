'use strict'

chalk = require 'chalk'

module.exports =

  # Positive
  CONFIG_CREATED  : -> 'Config file created!.'
  ADD_FILE        : (file) -> "File #{chalk.green(file)} has been added."
  REMOVE_FILE     : (file) -> "File #{chalk.green(file)} has been removed."
  CREATED_VERSION : (version) -> "Releases version #{chalk.green(version)}."
  CURRENT_VERSION : (version) -> "Current version is #{chalk.green(version)}."
  SET_PROPERTY    : (property, value) -> "Property #{chalk.green(property)} set as #{chalk.green(value)}."
  INSTALLING_PLUGIN : (plugin) -> "Plugin #{chalk.green(plugin)} not detected on the system."
  INSTALLING_PLUGIN_2 : -> "Installing it as global, might take a while."

  # Negative
  NOT_ALREADY_ADD_FILE : (file) ->
    message: "File #{chalk.red(file)} is already added."
    code: 2
  NOT_ADD_FILE         : (file) ->
    message: "File #{chalk.red(file)} can't be added because doesn't exist."
    code: 3
  NOT_REMOVE_FILE      : (file) ->
    message: "File #{chalk.red(file)} can't be removed because previously hasn't been added."
    code: 4
  NOT_VALID_VERSION    : (version) ->
    message: "Version #{chalk.red(version)} provided to release is not valid."
    code: 5
  NOT_GREATER_VERSION  : (last, old) ->
    message: "Version #{chalk.red(last)} is not greater that the current #{chalk.green(old)} version."
    code: 6
  NOT_CURRENT_VERSION  : ->
    message: "There isn't version declared. Maybe you need to init first?"
    code: 7
  NOT_SET_PROPERTY     : ->
    message: "You need to provide the property and the value to be set."
    code: 8
  NOT_SET_VERSION      : ->
    message: "Use 'bumped release' instead."
    code: 9
  NOT_PROPERLY_FINISHED: (status) ->
    message: "Something is wrong. Resolve #{chalk.red('red')} messages to continue."
    code: 10
