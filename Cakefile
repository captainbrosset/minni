{exec} = require 'child_process'

task 'build', 'build Minni from source to lib', ->
  exec 'coffee --compile --output lib/minni src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr