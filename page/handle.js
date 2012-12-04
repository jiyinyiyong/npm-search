var show, host, socket, query, all, card, slice$ = [].slice;
show = function(){
  var args;
  args = slice$.call(arguments);
  return console.log.apply(console, args);
};
host = "jiyinyiyong.info";
socket = new WebSocket("ws://" + host + ":3011");
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
      ".line": (ref$ = {}, ref$["a.name href='" + moduleUrl + "' target='_blank'"] = moduleName, ref$["span.auther"] = authorName, ref$),
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
      localStorage.query = word;
      return socket.send(JSON.stringify({
        type: 'query',
        data: word
      }));
    }
  };
  socket.onopen = function(){
    var word, that;
    show('onopen');
    word = (that = localStorage.query) != null ? that : 'nodejs';
    box.value = word;
    box.select();
    return socket.send(JSON.stringify({
      type: 'query',
      data: word
    }));
  };
  return box.onmouseover = function(){
    return box.select();
  };
};
socket.onmessage = function(it){
  var res, time, list, listElem, html;
  res = JSON.parse(it.data);
  if (res.type === 'time') {
    time = new Date(res.data);
    return query('#time').innerText = time.toString();
  } else if (res.type === 'query') {
    list = res.data;
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
  }
};