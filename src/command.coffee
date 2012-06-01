

printLine = (line) -> process.stdout.write line + '\n'

exports.run = ->
  return require './repl'