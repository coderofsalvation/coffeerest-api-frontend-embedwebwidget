mustache = require 'mustache'
fs       = require 'fs'
clone    = (obj) -> JSON.parse( JSON.stringify obj )
extend   = require 'extend'

module.exports = (server, model, lib, urlprefix ) ->

  me = {}

  me.helpers =
    uppercase: () ->
      (text,render) ->
        render(text).toUpperCase()

  lib.events.on 'beforeStart', (data,next) -> 
    if model.webwidget?.urls?.test
      model.resources[model.webwidget.urls.test] =
        get:
          description: "returns the embedcode"
          function: (req, res, next, lib, reply) ->
            body = mustache.render( fs.readFileSync(__dirname+"/mustache/embed.html").toString(), extend model, me.helpers )
            res.writeHead 200, 
              'Content-Length': Buffer.byteLength(body),
              'Content-Type': 'text/html'
            res.write(body)
            res.end()
            next()

    if model.webwidget?.urls?.js
      model.resources[model.webwidget.urls.js] =
        get:
          description: "returns the webwidget javascript code"
          function: (req, res, next, lib, reply) ->
            console.log "*TODO*: bundle using express-bundles"
            body = ""; for file in model.webwidget.app.files.js 
              body += fs.readFileSync file
            res.writeHead 200, 
              'Content-Length': Buffer.byteLength(body),
              'Content-Type': 'application/javascript'
            res.write(body)
            res.end()
            next()
    next()

  return me
