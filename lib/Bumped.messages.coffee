'use strict'

module.exports =

  # Positive
  CONFIG_CREATED      : -> 'Config file created!.'
  ADD_FILE            : (file) -> "'#{file}' has been added."
  ADD_ALREADY_FILE    : (file) -> "'#{file}' is already added."
  REMOVE_FILE         : (file) -> "'#{file}' has been removed."
  DETECTED_FILE       : (file) -> "Detected '#{file}' in the directory."
  CREATED_VERSION     : (version) -> "Created version '#{version}'."
  CURRENT_VERSION     : (version) -> "Current version is '#{version}'."

  # Negative
  NOT_REMOVE_FILE     : (file) -> "#{file} can\'t be removed because isn\'t declared."
  NOT_DETECTED_FILE   : (file) -> "'#{file}' hasn\'t beedn detect in the directory."
  NOT_VALID_VERSION   : (version) -> "version '#{version}' provided to release is not valid."
  NOT_GREATER_VERSION : (last, old) -> "version '#{last}' is not greater that the current '#{old}' version."
