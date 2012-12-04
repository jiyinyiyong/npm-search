{print} = require "util"
{spawn, exec} = require "child_process"

echo = (child, callback) ->
  child.stderr.on "data", (data) -> print data.toString()
  child.stdout.on "data", (data) -> print data.toString()
  child.on "exit", (code) -> callback?() if code is 0

make = (str) -> str.split " "
d = __dirname

queue = [
  "jade -O #{d}/page/ -wP #{d}/src/index.jade"
  "stylus -o #{d}/page/ -w #{d}/src/"
  "livescript -o #{d}/page/ -wbc #{d}/src/"
  "doodle #{d}/page/ #{d}/server/app.ls"
  "node-dev #{d}/server/app.ls"
]

split = (str) -> str.split " "

task "dev", "watch and convert files", (callback) ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..]), callback