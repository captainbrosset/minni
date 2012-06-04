readline    = require 'readline'
inspect     = require('util').inspect

# Start by opening up `stdin` and `stdout`.
stdin = process.openStdin()
stdout = process.stdout

# Require **Minni** module.
Minni        = require './minni'
todoList     = new Minni("#{__dirname}/../../minni.txt")

set_prompt = ->
  name = todoList.get_name()
  length = "minni (#{name})> ".length
  colored_name = name.yellow.bold
  prompt = "minni (#{colored_name})> "
  repl.setPrompt "minni (#{colored_name})> ", length

clear_screen = ->
  stdout.write '\u001B[2J\u001B[0;0f'
  set_prompt()
  repl.prompt()

# Make sure that uncaught exceptions don't kill the REPL.
process.on 'uncaughtException', (e) ->
  #console.log e
  repl.prompt()

## Autocompletion
# Returns a list of completions, and the completed text.
autocomplete = (text) ->
  [[], text]

# The main REPL function. **run** is called every time a new command is entered.
# Attempt to evaluate the command. If there's an exception, print it out instead
# of exiting.
run = (buffer) ->
  # remove trailing newlines
  buffer = buffer.replace /[\r\n]+$/, ""
  if !buffer.toString().trim()
    repl.prompt()
    return

  if buffer is 'quit'
    repl.close()
    return

  result = todoList.process_command buffer

  set_prompt()
  repl.output.write result
  repl.prompt()

# Create the REPL by listening to **stdin**.
if readline.createInterface.length < 3
  repl = readline.createInterface stdin, autocomplete
  stdin.on 'data', (buffer) -> repl.write buffer
else
  repl = readline.createInterface stdin, stdout, autocomplete

repl.on 'close', ->
  repl.output.write '\n'
  repl.output.write 'Bye, have a nice day!\n'.green
  repl.input.destroy()

repl.on 'line', run

set_prompt()
repl.prompt()