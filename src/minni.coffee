# The current Minni version number.
exports.VERSION = '0.0.1'


processCommand = (buffer) ->
  console.log buffer

exports.exec = (buffer) ->
  processCommand buffer