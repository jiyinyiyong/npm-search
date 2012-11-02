
show = (...args) -> console.log.apply console, args
socket = new WebSocket \ws://jiyinyiyong.info:3011

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
        "a.name href='#{module-url}'": module-name
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
      socket.send word
  socket.onopen = -> socket.send \nodejs

  box.onmouseover = -> box.select!
  # all \a .click -> socket.close!

socket.onmessage = ->
  # show \message, it.data
  list = JSON.parse it.data
  list-elem = query \#list
  list-elem.innerHTML = ''
  html = ''
  list.forEach (module) ->
    # show module
    if module?
      piece = card module
      html += piece
  list-elem.innerHTML = html