express = require('express')
bodyParser = require('body-parser')
path = require("path")
request = require('superagent')
htmlFixer = require('./addcss.coffee')
app = express()

app.set('view engine', 'ejs')
app.set("views", path.join(__dirname, "views"))
app.use(express.static(path.join(__dirname, 'public')))
app.use(bodyParser.json())

app.get '/', (req, res) ->
  url = "http://idlewords.com/2014/07/sana_a.htm"
  request.get "http://www.reddit.com/r/all.json", (redditResponse) ->
    redditPosts = redditResponse.body.data.children.map((p) -> p.data)
    request.get "http://hook-api.herokuapp.com/today", (productHuntResponse) ->
      productHuntPosts = productHuntResponse.body.hunts
      res.render 'index', {redditPosts, productHuntPosts}

app.get '/cache', (req, res) ->
  url = req.query.url
  if isImage(url)
    res.send "<img src='#{url}'>"
  else
    request.get url, (response) ->
      html = response.text
      # parse relative css and js links
      if response.headers["content-type"].indexOf('html') > -1
        html = htmlFixer.fixLinks(html, url)

      res.send html

app.listen 3000, -> console.log "Listening on 3000"

types = ["gif", "jpg", "jpeg", "png", "tiff", "tif"]
isImage = (url) ->
  arr = url.toLowerCase().split('.')
  arr[arr.length-1] in types
