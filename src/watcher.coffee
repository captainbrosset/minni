fs = require "fs"

Watcher = class Watcher

  constructor: (@file, @callback, interval = 500) ->
    @lastModifiedTime = @getModifiedTime()
    @started = true
    self = this
    @interval = setInterval ->
      self.checkForChanges()
    , interval

  checkForChanges: ->
    newModifiedTime = @getModifiedTime()
    if newModifiedTime > @lastModifiedTime
      @lastModifiedTime = newModifiedTime
      return @callback() if @started

  pause: ->
    @started = false

  resume: ->
    @started = true

  stop: ->
    clearInterval @interval

  getModifiedTime: ->
    fs.statSync(@file).mtime.getTime()


module.exports = Watcher
