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
  NOT_REMOVE_FILE     : (file) -> "#{file} can't be removed because previously hasn't been added."
  NOT_DETECTED_FILE   : (file) -> "'#{file}' hasn't been detected in the directory."
  NOT_VALID_VERSION   : (version) -> "Version '#{version}' provided to release is not valid."
  NOT_GREATER_VERSION : (last, old) -> "Version '#{last}' is not greater that the current '#{old}' version."
  NOT_CURRENT_VERSION : -> "There isn't version declared."
  NOT_AUTODETECTED    : -> "It has been impossible to detect files automatically."
  NOT_AUTODETECTED_2  : -> "Try to add manually with 'add' command."
  NOT_SET_PROPERTY    : -> "You need to provide the property and the value to be set."
  NOT_SET_VERSION     : -> "Use 'bumped release' instead."
  NOT_RELEASED        : -> "Something is wrong. Resolve red messages to continue."
