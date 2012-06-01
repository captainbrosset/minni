
# Start by opening up `stdin` and `stdout`.
stdin = process.openStdin()
stdout = process.stdout

# Require **Minni** module.
Minni        = require './minni'
readline     = require 'readline'

# REPL Setup
# Config
REPL_PROMPT = 'minni> '

# Log an error
error = (err) ->
  stdout.wite (err.stack or err.toString()) + '\n'

# Make sure that uncaught exceptions don't kill the REPL.
process.on 'uncaughtException', error

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

  repl.setPrompt REPL_PROMPT
  Minni.exec buffer
  repl.prompt()

if stdin.readable and stdin.isRaw
  # handle piped input
  pipedInput = ''
  repl =
    prompt: -> stdout.write @_prompt
    setPrompt: (p) -> @_prompt = p
    input: stdin
    output: stdout
    on: ->
  stdin.on 'data', (chunk) ->
    pipedInput += chunk
    return unless /\n/.test pipedInput
    lines = pipedInput.split "\n"
    pipedInput = lines[lines.length - 1]
    for line in lines[...-1] when line
      stdout.write "#{line}\n"
      run line
    return
  stdin.on 'end', ->
    for line in pipedInput.trim().split "\n" when line
      stdout.write "#{line}\n"
      run line
    stdout.write '\n'
    process.exit 0
else
  # Create the REPL by listening to **stdin**.
  if readline.createInterface.length < 3
    repl = readline.createInterface stdin, autocomplete
    stdin.on 'data', (buffer) -> repl.write buffer
  else
    repl = readline.createInterface stdin, stdout, autocomplete

repl.on 'close', ->
  repl.output.write '\n\n'
  repl.output.write 'Bye, have a nice day!\n\n'
  repl.input.destroy()

repl.on 'line', run

repl.setPrompt REPL_PROMPT
repl.prompt()