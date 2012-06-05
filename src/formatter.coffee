descriptionLineLength = 70

formatItem = (index, item) -> 

  nbOfChars = item.task.length
  nbOfLines = Math.ceil nbOfChars / descriptionLineLength

  str = "\n#{index}\t"
  line = item.task[0..descriptionLineLength]
  str += line

  if line.length < descriptionLineLength
    str += " " for i in [0..descriptionLineLength-line.length]

  if item.tags.length > 0
    str += "\t"
    for tag in item.tags
      str += "+#{tag} ".cyan

  if item.done
    str += "\t##{item.done} ".green

  if nbOfLines > 1
    for lineIndex in [1..nbOfLines-1]
      str += "\n\t"
      str += item.task[descriptionLineLength*lineIndex+1..descriptionLineLength*(lineIndex+1)]

  return str.yellow if item.priority is 1
  return str.yellow.bold if item.priority is 2
  return str.red if item.priority is 3
  return str.red.bold if item.priority is 4
  str

formatList = (list) ->
  index = 0
  str = ""
  for item in list.tasks
    str += formatItem index, item
    str += '\n'
    index++
  str += "#{index} of #{list.tasks.length} tasks shown".bold if index isnt list.tasks.length
  str

module.exports.formatList = formatList
module.exports.formatItem = formatItem
