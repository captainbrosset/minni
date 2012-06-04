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
        when '#'
          @done = split
        when '+'
          @add_tag(split[1..])
        else
          @task += ' ' if @task.length > 0
          @task += split

  is_done: ->
    @done

  mark_as_done: ->
    @done = dateFormat(new Date(), "yyyy-mm-dd")

  add_tag: (tag) ->
    tag = tag.split(" ").join("-")
    return if tag in @tags
    @tags.push tag

  toString: ->
    str = if @done "[x]" else "[ ]"
    str += " #{@task} "
    if @done
      str += " ##{@done} "
    if @tags.length > 0
      str += " +#{tag}" for tag in @tags
    str

module.exports = Item