formatter = require './formatter'
Item = require './item'

List = class List
  constructor: (list_items) ->
    @tasks = (new Item(item) for item in list_items when item isnt '') if list_items
    @tasks ?= []

  add: (text_or_task) ->
    if typeof text_or_task is 'string'
      @tasks.push new Item("[ ] "+text_or_task)
    else
      @tasks.push text_or_task
    @sort_by_prio()

  removeAt: (index) ->
    task = @tasks.splice(index, 1)
    task

  sort_by_prio: ->
    @tasks.sort (a, b) ->
      return 1 if a.priority < b.priority
      return -1 if a.priority > b.priority
      0

  get: (index) ->
    @tasks[index]

  toFile: ->
    #TODO This is method is way too crappy, refactor needed
    str = ''
    for item in @tasks
      str += item.toFile()
      str += '\n'
    str

  toString: ->
    formatter.formatList this

module.exports = List
