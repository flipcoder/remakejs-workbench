#!/usr/bin/lsc
express = require 'express'
path = require 'path'
cookieParser = require 'cookie-parser'
jsonfile = require 'jsonfile'
#nunjucks = require 'nunjucks'
pug = require 'pug'
deepExtend = require 'deep-extend'
parseUrl = require('parseurl');
#nunjucks.configure do
#    autoescape: true

app = express()
app.use cookieParser()
app.use express.static('public')
app.use express.urlencoded do
    extended: false
app.use express.json()

app.get '/', (req,res)->
    console.log '/'
    err, data <- jsonfile.readFile 'data.json'
    if err
        console.log 'unable to load json data'
        res.end()
        return

    res.send pug.renderFile 'views/index.pug', do
        title: 'index'
        data: data
        params: req.params
        query: req.query
        pathname: parseUrl(req).pathname

app.post '/save', (req,res)->
    console.log '/save'
    console.log req.body

    fn = path.join(__dirname, 'data.json')
    err, data <- josnfile.readFile fn
    if err
        res.end()
        return

    data = deepExtend data, req.body.data

    err <- json.writeFile fn, data, {spaces:2}

    console.log data

    res.json do
        data: data

app.post '/new', (req,res)->
    console.log '/new'
    console.log req.body

    templateName = req.body.templateName;
    partialPath = path.join(__dirname, "views/" + templateName + ".pug")
    startingDataPath = path.join(__dirname, "views/" + templateName + ".json")
    err, startingData <- jsonfile.readFile startingDataPath
    htmlString = pug.renderFile partialPath, startingData
    console.log {htmlString}

    res.json({htmlString});

const PORT = process.env.PORT || 3000
app.listen PORT, ->
    console.log 'server listening on port ' + PORT
    if process.send
        process.send 'online'

