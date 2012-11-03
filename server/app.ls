
require! \ws
require! \http
require! \fs
require! \path

repeat = -> setInterval &1, &0
delay = -> setTimeout &1, &0
show = console.log

data-url = \http://registry.npmjs.org/-/all
# data-url = \http://localhost/npm-search/server/data.json
data = {}
list = []
time = ''

make-data = ->
  show 'make data'
  http.get data-url, (res) ->
    show 'response'
    str = ''
    res.on \data (piece) -> str += piece
    res.on \end ->
      show \end
      fs.write-file (path.join __dirname, \data.json), str
      data := JSON.parse str
      time := new Date!.getTime!
      delete data._updated
      list := []
      for key of data then list.push key
      show \refresh

make-data!
repeat (3600 * 6 * 1000), make-data

make-list = ->
  try regex = RegExp it
  catch e then regex = /wrong/
  result = []
  for module in list
    if regex.test module
      result.push data[module]
  result.splice 0 40

# delay 2000 -> show make-list \mongo

wss = new ws.Server host: \0.0.0.0, port: 3011

wss.on \connection, (socket) ->
  show \connection
  socket.send JSON.stringify type: \time, data: time
  socket.on \message (message) ->
    show message
    msg = JSON.parse message
    type = msg.type
    if type is \query
      data = type: \query, data: (make-list msg.data)
      socket.send JSON.stringify data
      # show msg