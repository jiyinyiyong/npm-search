
require! \ws
require! \http
require! \fs
require! \path

repeat = -> setInterval &1, &0
delay = -> setTimeout &1, &0
show = console.log
{exec} = require \child_process

data-url = \http://registry.npmjs.org/-/all
# data-url = \http://registry.npmjs.vitecho.com/-/all
# data-url = \http://localhost/npm-search/server/data.json
time = ''

make-data = ->
  # show 'make data'
  time := new Date!.getTime!
  delay (3600 * 6 * 1000), make-data
  exec "rm data.json"  

  req = http.get data-url, (res) ->
    res.on \data -> show it
    res.on \end -> show "end"
    res.on "error", show
    res.pipe (fs.createWriteStream \data.json)

wss = new ws.Server host: \0.0.0.0, port: 3011

wss.on \connection, (socket) ->
  show \connection
  socket.send JSON.stringify type: \time, data: time
  socket.on \message (message) ->
    # show message
    msg = JSON.parse message
    type = msg.type
    fs.readFile "data.json", "utf8", (err, file) ->
      data = JSON.parse file
      list = []
      delete data._update
      for key, value of data
        list.push key, value
        # show key
      # show list.length, list[to 10]
      if type is \query
        try
          regex = RegExp msg.data
          # show \exp
          result = []
          for module in list
            if result.length < 50
              if regex.test module
                result.push data[module]
          # show "result" result
          json = type: \query, data: result
          socket.send JSON.stringify json
        catch err then show err