dateFormat = require 'dateformat'

class Item
  constructor: (text) ->
    @task = ''
    @priority = 0
    @done = false
    @tags = []
    @parse(text)

  parse: (text) ->
    [status, task...] = text[3..].split(' ')
    for split in task
      switch split[0]
        when '('
          @priority = parseInt(split[1...], 10)
        when '#'
          @done = split[1..]
        when '+'
          @add_tag(split[1..])
        else
          @task += ' ' if @task.length > 0
          @task += split

  is_done: ->
    @done

  mark_as_done: ->
    @done = dateFormat(new Date(), "yyyy-mm-dd")
    @priority = 0

  add_tag: (tag) ->
    tag = tag.split(" ").join("-")
    return if tag in @tags
    @tags.push tag

  set_priority: (@priority = 0) ->

  toFile: ->
    str = if @done then "[x]" else "[ ]"
    if @priority > 0
      str += " (#{@priority})"
    str += " #{@task} "
    if @done isnt false
      str += " ##{@done} "
    if @tags.length > 0
      for tag in @tags
        str += " +#{tag}"
    str

module.exports = Item
