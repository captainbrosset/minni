Item = require './item'

class List
  constructor: (list_items) ->
    @items = (new Item(item) for item in list_items when item isnt '')

  add: (text) ->
    @items.push new Item(text)

  remove: (index) ->
    @items.splice(index, 1)

  toString: ->
    console.log "pouet"
    str = ''
    for item in @items
      str += (item.toString() + '\n')

    str


module.exports = List