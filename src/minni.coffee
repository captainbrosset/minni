fs    = require 'fs'
List  = require './list'
Item  = require './item'

# The current Minni version number.
exports.VERSION = '0.0.1'

Todo = class Todo
  constructor: (@file) ->
    @load()

  load: ->
    lines = fs.readFileSync(@file, 'utf8');
    [@name, items] = lines.split(Todo.TASKS_SEP)
    @name = @name.replace /[\r\n]+$/, ''
    @todo = new List()
    @done = new List()
    for item in items.split('\n') when item isnt ''
      task = new Item(item)
      if task.is_done()
        @done.add task
      else
        @todo.add task

  save: ->
    fs.writeFileSync(@file, @get_content(), 'utf8')

  reload: ->
    @load()
    "Tasks list reloaded".green

  get_name: ->
    @name

  get_content: ->
    """#{@name}
    #{Todo.TASKS_SEP}
    #{@todo.toFile()}
    #{@done.toFile()}
    """

  process_command: (buffer) ->
    #console.log "PROCESSING THE COMMAND"
    [action, args...] = buffer.split(" ")
    args = args.join(" ")
    result = switch action
      when "reload", "R"
        @reload()
      when "help", "h"
        Todo.help
      when "add", "a"
        @add_item args
      when "remove", "r"
        @remove_item args
      when "list", "l"
        @list_items()
      when "listall", "la"
        @list_all_items()
      when "done", "d"
        @mark_as_done args
      when "rename", "ren"
        @rename args
      when "tag", "t"
        @tag args
      when "prio", "p"
        @priority args
      else
        @send_response ''
        #@send_response "Unknown command:".red, action.grey
    @send_response result

  mark_as_done: (index) ->
    index = parseInt(index, 10) - 1;
    task = @todo.get index
    task.mark_as_done()
    @todo.removeAt index
    @done.add task
    @save()
    "Task sucessfully marked as done".grey

  remove_item: (index) ->
    index = parseInt(index, 10) - 1;
    @todo.remove index
    @save()
    "Task sucessfully deleted".grey

  add_item: (item_name) ->
    @todo.add item_name
    @save()
    "New task sucessfully created".grey

  list_all_items: ->
    result = "Ongoing\n".bold
    result += @list_items()
    result += "\nDone\n".bold
    result += @done.toString()
    result

  list_items: ->
    @todo.toString()

  rename: (new_name) ->
    old = @name
    @name = new_name
    @save()
    "'#{old}' has been renamed to '#{@name}'"

  tag: (args) ->
    [index, tags...] = args.split(" ")
    index = parseInt(index, 10) - 1
    task = @todo.get index
    for tag in tags
      task.add_tag tag
    @save()
    "#{tags.length} Tag(s) successfully added"

  priority: (args) ->
    [index, prio, trash...] = args.split(" ")
    index = parseInt(index, 10) - 1
    prio = parseInt(prio, 10)
    task = @todo.get index
    task.set_priority prio
    @todo.sort_by_prio()
    @save()
    "Priority successfully updated"

  send_response: (text...) ->
    text = text.join(' ')
    return text+'\n' if text[-1..] isnt '\n' and text isnt ''
    text

module.exports = Todo


Todo.TASKS_SEP = '================================================================================'
Todo.LIST_SEP = '--------------------------------------------------------------------------------'

Todo.help = [
  "",
  "Minni - Minimalistic Command Line Todo List",
  "  Usage:",
  "  help, h".bold,
  "\tDisplays this help content",
  "  add, a".bold,
  "\tAdd a task to the list",
  "  remane, r".bold,
  "\tRenames the list",
  "  list, l".bold,
  "\tDisplays all tasks",
  ""
].join('\n')