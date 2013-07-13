connect = require 'connect'
port = process.env.PORT or 3000

console.log port

connect.createServer(connect.static './www/').listen port