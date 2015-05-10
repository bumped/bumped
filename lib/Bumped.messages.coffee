'use strict'

module.exports =

  CONFIG_CREATED    : -> 'Config file created!.'
  DETECTED_FILE     : (file) -> "Detected '#{file}' in the directory."
  CREATED_VERSION   : (version) -> "Created version '#{version}'."
  CURRENT_VERSION   : (version) -> "Current version is '#{version}'."
  NOT_VALID_VERSION : (version) -> "version '#{version}' provided to release is not valid."
  NOT_GREATER_VERSION: (last, old) -> "version '#{last}' is not greater that the current '#{old}' version."
