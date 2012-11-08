
show = (...args) -> console.log.apply console, args
host = location.host
socket = new WebSocket "ws://#host:3011"

query = -> document.querySelector it
all = -> document.querySelectorAll it

card = ->
  # show it
  try module-name = it.name
  catch e then module-name = \?
  module-url = "https://npmjs.org/package/#module-name"
  try author-name = it.author.name
  catch e then author-name = \?
  try author-url = it.author.url
  catch e then author-url = \?
  try intro = it.description
  catch e then intro = \?
  try time = it.time
  catch e then time = \?
    
  json =
    ".module":
      ".line":
        "a.name href='#{module-url}' target='_blank'": module-name
        "span.auther": author-name
      ".description": intro
      ".time": time

  tmpl json

window.onload = ->
  box = query \#box
  box.focus!
  box.onkeydown = ->
    if it.keyCode is 13
      box.select!
      word = query \#box .value
      localStorage.query = word
      socket.send JSON.stringify type: \query, data: word
  socket.onopen = ->
    show \onopen
    word = if localStorage.query? then that else \nodejs
    box .value = word
    box.select!
    socket.send JSON.stringify type: \query, data: word

  box.onmouseover = -> box.select!
  # all \a .click -> socket.close!

socket.onmessage = ->
  # show \message, it.data
  res = JSON.parse it.data
  # show it.data
  if res.type is \time
    time = new Date res.data
    query \#time .innerText = time.toString!
  else if res.type is \query
    list =  res.data
    # show res.data
    list-elem = query \#list
    list-elem.innerHTML = ''
    html = ''
    list.forEach (module) ->
      # show module
      if module?
        piece = card module
        html += piece
    list-elem.innerHTML = html