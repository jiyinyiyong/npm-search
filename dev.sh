
cd `dirname $0`

jade -O page/ -wP src/*jade &
stylus -o page/ -w src/*styl &
livescript -o page/ -wbc src/*ls &
doodle page/ &
node-dev server/app.ls &

read

pkill -f jade
pkill -f stylus
pkill -f livescript
pkill -f doodle
pkill -f node-dev