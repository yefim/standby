express = require('express')
bodyParser = require('body-parser')
path = require("path")
request = require('superagent')
helper = require('./helper.coffee')
app = express()

app.set('view engine', 'ejs')
app.set("views", path.join(__dirname, "views"))
app.use(express.static(path.join(__dirname, 'public')))
app.use(bodyParser.json())

standby = "OUR.URL.COM"

app.get '/', (req, res) ->
  url = "http://idlewords.com/2014/07/sana_a.htm"
  request.get "http://www.reddit.com/r/all.json", (redditResponse) ->
    redditPosts = redditResponse.body.data.children.map((p) -> p.data)[0..10]
    redditPosts = redditPosts.filter (link) -> link isnt standby
    request.get "http://hook-api.herokuapp.com/today", (productHuntResponse) ->
      productHuntPosts = productHuntResponse.body.hunts[0..1]
      productHuntPosts = productHuntPosts.filter (link) -> link isnt standby
      request.get "http://api.ihackernews.com/page", (hackernewsResponse) ->
        hackernewsPosts = hackernewsResponse.body.items[0..1]
        hackernewsPosts = hackernewsPosts.filter (link) -> link isnt standby
        res.render 'index', {redditPosts, productHuntPosts, hackernewsPosts}

app.get '/cache', (req, res) ->
  url = req.query.url
  if helper.isImage(url)
    console.log(url)
    res.send "<img src='#{url}'>"
  else
    request.get url, (response) ->
      html = response.text
      # parse relative css and js links
      if response.headers["content-type"].indexOf('html') > -1
        html = helper.fixLinks(html, url)

      res.send html

app.listen 3000, -> console.log "Listening on 3000"

