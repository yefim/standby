express = require('express')
bodyParser = require('body-parser')
path = require("path")
request = require('superagent')
redis = require("redis")
htmlFixer = require('./addcss.coffee')
client = redis.createClient()
app = express()

app.set('view engine', 'ejs')
app.set("views", path.join(__dirname, "views"))
app.use(express.static(path.join(__dirname, 'public')))
app.use(bodyParser.json())

STANDBY = "OUR.URL.COM"

app.get '/', (req, res) ->
  request.get "http://www.reddit.com/r/all.json", (redditResponse) ->
    redditPosts = redditResponse.body.data.children.map((p) -> p.data)[0..10]
    redditPosts = redditPosts.filter (link) -> link isnt STANDBY
    request.get "http://hook-api.herokuapp.com/today", (productHuntResponse) ->
      productHuntPosts = productHuntResponse.body.hunts[0..1]
      productHuntPosts = productHuntPosts.filter (link) -> link isnt STANDBY
      request.get "http://api.ihackernews.com/page", (hackernewsResponse) ->
        # hackernewsPosts = hackernewsResponse.body.items[0..1]
        hackernewsPosts = []
        hackernewsPosts = hackernewsPosts.filter (link) -> link isnt STANDBY
        res.render 'index', {redditPosts, productHuntPosts, hackernewsPosts}

app.get '/cache', (req, res) ->
  url = req.query.url
  client.get url, (err, html) ->
    if html
      res.send html
    else
      if isImage(url)
        html = "<img src='#{url}'>"
        client.set url, html
        res.send html
      else
        request.get url, (response) ->
          html = response.text or ""
          # parse relative css and js links
          if response.headers["content-type"].indexOf('html') > -1
            html = htmlFixer.fixLinks(html, url)
          client.set url, html
          res.send html

app.listen 3000, -> console.log "Listening on 3000"

types = ["gif", "jpg", "jpeg", "png", "tiff", "tif"]
isImage = (url) ->
  arr = url.toLowerCase().split('.')
  arr[arr.length-1] in types
