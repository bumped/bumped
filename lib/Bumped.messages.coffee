'use strict'

chalk = require 'chalk'

module.exports =

  # Positive
  CONFIG_CREATED      : -> 'Config file created!.'
  ADD_FILE            : (file) -> "'#{chalk.green(file)}' has been added."
  ADD_ALREADY_FILE    : (file) -> "'#{chalk.green(file)}' is already added."
  REMOVE_FILE         : (file) -> "'#{chalk.green(file)}' has been removed."
  DETECTED_FILE       : (file) -> "Detected '#{chalk.green(file)}' in the directory."
  CREATED_VERSION     : (version) -> "Releases version #{chalk.green(version)}"
  CURRENT_VERSION     : (version) -> "Current version is #{chalk.green(version)}."
  SET_PROPERTY        : (property, value) -> "property '#{property}' set as '#{value}'."

  # Negative
  NOT_REMOVE_FILE     : (file) ->
    message: "#{file} can't be removed because previously hasn't been added."
    code: 2
  NOT_DETECTED_FILE   : (file) ->
    message: "'#{file}' hasn't been detected in the directory."
    code: 3
  NOT_VALID_VERSION   : (version) ->
    message: "Version '#{version}' provided to release is not valid."
    code: 4
  NOT_GREATER_VERSION : (last, old) ->
    message: "Version '#{last}' is not greater that the current '#{old}' version."
    code: 5
  NOT_CURRENT_VERSION : ->
    message: "There isn't version declared."
    code: 6
  NOT_AUTODETECTED    : ->
    message: "It has been impossible to detect files automatically."
    code: 7
  NOT_AUTODETECTED_2  : ->
    message: "Try to add manually with 'add' command."
    code: 8
  NOT_SET_PROPERTY    : ->
    message: "You need to provide the property and the value to be set."
    code: 9
  NOT_SET_VERSION     : ->
    message: "Use 'bumped release' instead."
    code: 10
  NOT_RELEASED        : ->
    message: "Something is wrong. Resolve #{chalk.red('red')} messages to continue."
    code: 11
