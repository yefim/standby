express = require('express')
path = require("path")
request = require('superagent')
app = express()

app.set('view engine', 'ejs')
app.set("views", path.join(__dirname, "views"))
app.use(express.static(path.join(__dirname, 'public')))

app.get '/', (req, res) ->
  url = "http://idlewords.com/2014/07/sana_a.htm"
  request.get url, (response) ->
    html = response.text
    res.render 'index', {url, html}

app.listen 3000
