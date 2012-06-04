fs    = require 'fs'
List   = require './list'

# The current Minni version number.
exports.VERSION = '0.0.1'

Todo = class Todo
  constructor: (@file) ->
    @load()

  load: ->
    lines = fs.readFileSync(@file, 'utf8');
    [@name, items, done] = lines.split(Todo.separotor)
    @name = @name.replace /[\r\n]+$/, ''
    @items = new List(items.split('\n'))
    @done = new List(done.split('\n'))

  save: ->
    fs.writeFileSync(@file, @get_content(), 'utf8')

  get_name: ->
    @name

  get_content: ->
    """#{@name}
    #{Todo.separotor}
    #{@items}
    #{Todo.separotor}
    #{@done}
    """

  process_command: (buffer) ->
    #console.log "PROCESSING THE COMMAND"
    [action, args...] = buffer.split(" ")
    args = args.join(" ")
    result = switch action
      when "help"
        Todo.help
      when "add", "a"
        @add_item args
      when "remove", "r"
        @remove_item args
      when "list", "l"
        @list_items()
      when "listall", "la"
        @list_all_items()
      when "rename"
        @rename args
      else
        #@send_response "Unknown command:".red, action.grey
    @send_response result

  remove_item: (index) ->
    @items.remove index

  add_item: (item_name) ->
    @items.add item_name

  list_all_items: ->
    result = @list_items()
    result += @done.toString()
    result

  list_items: ->
    @items.toString()

  rename: (new_name) ->
    old = @name
    @name = new_name
    @save()
    "'#{old}' has been renamed to '#{@name}'"

  send_response: (text...) ->
    text = text.join(' ')
    return text+'\n' if text[-1..] isnt '\n'
    text

module.exports = Todo


Todo.separotor = '================================================================================'

Todo.help = """

Minni - Minimalistic Command Line Todo List
Usage:
  help, h
      Displays this help content
  add, a
      Add a task to the list
  remane, r
      Renames the list
  list, l
      Displays all tasks


"""