express = require('express')
bodyParser = require('body-parser')
path = require("path")
request = require('superagent')
helper = require('./helper.coffee')
app = express()

if process.env.REDISTOGO_URL
  rtg   = require("url").parse(process.env.REDISTOGO_URL)
  client = require("redis").createClient(rtg.port, rtg.hostname)
  client.auth(rtg.auth.split(":")[1])
else
  client = require("redis").createClient()

app.set('view engine', 'ejs')
app.set("views", path.join(__dirname, "views"))
app.use(express.static(path.join(__dirname, 'public')))
app.use(bodyParser.json())

STANDBY = "http://trystandby.herokuapp.com"
REDDIT = "http://www.reddit.com/r/all.json"
PH = "http://hook-api.herokuapp.com/today"
HN ="http://api.ihackernews.com/page"

app.get '/', (req, res) ->
  # res.render 'index', {
  #   redditPosts: []
  #   hackernewsPosts: []
  #   mediumPosts: []
  # }
  request.get REDDIT, (redditResponse) ->
    console.log "loaded Reddit."
    redditPosts = redditResponse.body.data.children.map((p) -> p.data)
    redditPosts = redditPosts.filter (link) -> link.domain isnt STANDBY and not /nytimes.com/.test(link.url) and not link.over_18
    # redditPosts = []
    request.get HN, (hackernewsResponse) ->
      console.log "loaded HN."
      hackernewsPosts = hackernewsResponse.body?.items or []
      hackernewsPosts = hackernewsPosts.filter (link) -> link isnt STANDBY
      # hackernewsPosts = []
      request.get "https://medium.com/top-100", (mediumResponse) ->
        console.log "loaded Medium."
        mediumPosts = helper.parseMedium(mediumResponse.text)
        res.render 'index', {redditPosts, hackernewsPosts, mediumPosts} 

app.get '/cache', (req, res) ->
  url = req.query.url
  client.get url, (err, html) ->
    if html
      res.send html
    else
      if helper.isImage(url)
        html = "<style>body { margin: 0; padding: 0; }</style><img style='max-width: 100%; max-height: 100%' src='#{url}'>"
        client.set url, html
        res.send html
      else
        request.get url, (response) ->
          html = response.text or ""
          # parse relative css and js links
          if response.headers["content-type"]
            if response.headers["content-type"].indexOf('html') > -1
              html = helper.fixLinks(html, url)
            client.set url, html
            client.expire url, 180
          res.send html

app.get '/add', (req, res) ->
  service = req.query.service
  if service == "reddit"
    subreddit = req.query.subreddit
    url = "http://www.reddit.com/r/#{subreddit}.json"
    request.get url, (redditResponse) ->
      console.log "loaded Reddit."
      redditPosts = redditResponse.body.data.children.map((p) -> p.data)
      redditPosts = redditPosts.filter (link) -> link.domain isnt STANDBY and not /nytimes.com/.test(link.url) and not link.over_18
      res.json redditPosts
  else if service == "producthunt"
    request.get PH, (productHuntResponse) ->
      console.log "loaded Product Hunt."
      if productHuntResponse.ok
        productHuntPosts = productHuntResponse.body.hunts
        productHuntPosts = productHuntPosts.filter (link) -> link.domain isnt STANDBY and not /matterkit/.test(link.url)
        res.json productHuntPosts
      else
        res.json []
  else
    res.json []

port = Number(process.env.PORT or 3000)
app.listen port, -> console.log "Listening on http://localhost:3000"
