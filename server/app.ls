
require! \ws
require! \http

repeat = -> setInterval &1, &0
delay = -> setTimeout &1, &0
show = -> console.log

data-url = \http://registry.npmjs.org/-/all
# data-url = \http://up/npm-search/server/data.json
data = {}
list = []

make-data = ->
  show 'make data'
  http.get data-url, (res) ->
    show 'response'
    str = ''
    res.on \data (piece) -> str += piece
    res.on \end ->
      show \end
      data := JSON.parse str
      delete data._updated
      list := []
      for key of data then list.push key
      show \refresh

make-data!
repeat (3600 * 24 * 1000), make-data

make-list = ->
  regex = RegExp it
  result = []
  for module in list
    if regex.test module
      result.push data[module]
  result = result[0 to 50]
  JSON.stringify result

# delay 2000 -> show make-list \mongo

wss = new ws.Server host: \0.0.0.0, port: 3011

wss.on \connection, (socket) ->
  show \connection
  socket.on \message (message) ->
    show message
    socket.send make-list message