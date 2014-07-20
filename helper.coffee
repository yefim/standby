cheerio = require('cheerio')
urllib = require('url')

exports.fixLinks = (html, url) ->
  $ = cheerio.load(html)
  for key,val of $('link[rel=stylesheet]')
    if val.attribs and val.attribs.href
      val.attribs.href = remotizeURL(val.attribs.href, url)
  for key,val of $('script')
    if val.attribs and val.attribs.src
      val.attribs.src = remotizeURL(val.attribs.src, url)

  for key,val of $('img')
    if val.attribs and val.attribs.src
      val.attribs.src = remotizeURL(val.attribs.src, url)

  $.html()


remotizeURL = (url, page_url) ->
  parsedProxiedUrl = urllib.parse(page_url)
  host = parsedProxiedUrl.protocol + "//" + parsedProxiedUrl.hostname
  path = removeEndOfPath(parsedProxiedUrl.pathname)

  isAbsoluteURLRegex = /^(\/\/|http|javascript|data:)/i
  unless isAbsoluteURLRegex.test(url)
    if host[host.length - 1] is "/" and url[0] is "/"
      url = host + url.substring(1)
    else if host[host.length - 1] isnt "/" and url[0] isnt "/"
      url = host + path + "/" + url
    else
      url = host + url

  url

removeEndOfPath = (path) ->
  arr = path.split('/')
  return arr.splice(0, arr.length-1).join('/')

TYPES = [".gif", ".jpg", ".jpeg", ".png", ".tiff", ".tif"]
exports.isImage = (url) ->
  file = url.toLowerCase().split('/').pop()
  for t in TYPES
    if file.indexOf(t) > -1
      return true
  return false

exports.parseMedium = (html) ->
  $ = cheerio.load(html)
  mediumPosts = []
  for val,i in $('a[data-action="open-post"]')
    spl = val.attribs.title.split(' by ')
    title = spl[0]
    author = spl[1]
    url = remotizeURL(val.attribs.href, "https://medium.com/top-100")
    mediumPosts.push({title,author,url})
    console.log(val.attribs.title)

  for val,i in $('span.readingTime')
    mediumPosts[i].time = parseInt(val.children[0].data)

  mediumPosts

