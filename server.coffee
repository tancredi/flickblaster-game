express = require 'express'
http = require 'http'
fs = require 'fs'
path = require 'path'

app = express()

app.configure 'development', () -> app.use express.logger 'dev'

app.get '/cordova.js', (req, res) -> res.send ' '

app.use express.static path.resolve './www/'
app.use express.bodyParser()

server = http.createServer app

server.listen process.env.PORT || 3000, -> console.log 'Running...'