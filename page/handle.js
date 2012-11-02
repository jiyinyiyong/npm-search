var show, socket, query, all, card, slice$ = [].slice;
show = function(){
  var args;
  args = slice$.call(arguments);
  return console.log.apply(console, args);
};
socket = new WebSocket('ws://192.168.1.104:8000');
query = function(it){
  return document.querySelector(it);
};
all = function(it){
  return document.querySelectorAll(it);
};
card = function(it){
  var moduleName, e, moduleUrl, authorName, authorUrl, intro, time, json, ref$;
  try {
    moduleName = it.name;
  } catch (e$) {
    e = e$;
    moduleName = '?';
  }
  moduleUrl = "https://npmjs.org/package/" + moduleName;
  try {
    authorName = it.author.name;
  } catch (e$) {
    e = e$;
    authorName = '?';
  }
  try {
    authorUrl = it.author.url;
  } catch (e$) {
    e = e$;
    authorUrl = '?';
  }
  try {
    intro = it.description;
  } catch (e$) {
    e = e$;
    intro = '?';
  }
  try {
    time = it.time;
  } catch (e$) {
    e = e$;
    time = '?';
  }
  json = {
    ".module": {
      ".line": (ref$ = {}, ref$["a.name href='" + moduleUrl + "'"] = moduleName, ref$["span.auther"] = authorName, ref$),
      ".description": intro,
      ".time": time
    }
  };
  return tmpl(json);
};
window.onload = function(){
  var box;
  box = query('#box');
  box.focus();
  box.onkeydown = function(it){
    var word;
    if (it.keyCode === 13) {
      box.select();
      word = query('#box').value;
      return socket.send(word);
    }
  };
  socket.onopen = function(){
    return socket.send('nodejs');
  };
  return box.onmouseover = function(){
    return box.select();
  };
};
socket.onmessage = function(it){
  var list, listElem, html;
  list = JSON.parse(it.data);
  listElem = query('#list');
  listElem.innerHTML = '';
  html = '';
  list.forEach(function(module){
    var piece;
    if (module != null) {
      piece = card(module);
      return html += piece;
    }
  });
  return listElem.innerHTML = html;
};