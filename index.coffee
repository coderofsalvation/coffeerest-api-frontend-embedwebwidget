mustache = require 'mustache'
fs       = require 'fs'
clone    = (obj) -> JSON.parse( JSON.stringify obj )
extend   = require 'extend'
css2js   = require 'css2js'
jsonp    = require 'jsonp-express'

module.exports = (server, model, lib, urlprefix ) ->

  me = {}

  server.use jsonp

  me.helpers =
    uppercase: () ->
      (text,render) ->
        render(text).toUpperCase()
  
  me.combineOptional = (model,opts) ->      
    cmodel = clone model.webwidget.app
    # check optional includes 
    for include,value of opts 
      model.webwidget.app.optional[ include ](cmodel.files,cmodel.urls) if model.webwidget.app.optional[ include ]?
    return {files: cmodel.files, urls: cmodel.urls }

  lib.events.on 'beforeStart', (data,next) -> 
    if model.webwidget?.urls?.embedcode
      model.resources[model.webwidget.urls.embedcode] =
        get:
          description: "returns the embedcode"
          function: (req, res, next, lib, reply) ->
            optional = me.combineOptional model, req.query
            helpers = extend me.helpers, { querystring: req.url.replace /.*\?/,"" }
            helpers = extend helpers, {query:req.query, optional: optional }
            console.dir extend model,helpers
            body = mustache.render( fs.readFileSync(__dirname+"/mustache/embed.html").toString(), extend model, helpers )
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
            console.log "*TODO*: cache/bundle using express-bundles"
            body = ""; 
            resources = me.combineOptional model, req.query 
            files = resources.files 
            for file in files.css
              console.log css2js.convert file, __dirname+'/node_modules/css2js/templates/vanilla_runner.js.tim', file+".js"
              files.js.push file+".js"
            inlinejs = "var cfg = "+JSON.stringify( { opts: req.query, id: model.webwidget.id, tags: model.webwidget.tags, embed: model.webwidget.embed } )+";"
            if resources.urls.css.length
              inlinejs += mustache.render fs.readFileSync( __dirname+"/mustache/style.js").toString(), {url:url} for url in resources.urls.css
            if resources.urls.js.length
              inlinejs += mustache.render fs.readFileSync( __dirname+"/mustache/script.js").toString(), {url:url} for url in resources.urls.js
            fs.writeFileSync model.webwidget.app.cache+'/inline.js', inlinejs
            files.js.unshift model.webwidget.app.cache+'/inline.js'
            console.log inlinejs
            console.dir files
            # bundle all files into one js
            body += fs.readFileSync file for file in files.js 
            res.writeHead 200, 
              'Content-Length': Buffer.byteLength(body),
              'Content-Type': 'application/javascript'
            res.write(body)
            res.end()
            next()
    next()

  return me
