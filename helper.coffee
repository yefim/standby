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

  $('video').removeAttr('autoplay')

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
  # for val,i in $('a[data-action="open-post"]')
    # spl = val.attribs.title.split(' by ')
    # title = val.attribs.title
    # author = spl[1]
    # url = remotizeURL(val.attribs.href, "https://medium.com/top-100")
    # console.log {title, author, url}
    # mediumPosts.push({title,author,url})

  # for val,i in $('span.readingTime')
  #   mediumPosts[i].time = parseInt(val.children[0].data)

  imageRegex = new RegExp(".*?(\\(.*\\))",["i"])

  for val, i in $('.block--list')
    image = imageRegex.exec(String(val.children[0].attribs.style));
    if image != null
      image = image[1].replace(/([()])/g, '') #.match(imageRegex)[0]
    else
      image = ""

    url = "https://medium.com"+val.children[0].attribs.href
    mediumPosts.push({image, url})


  for val, i in $('h3.block-title')
    # title = val.
    # title = val.children[0].data
    title = val.children[0].children[0].data
    url = "https://medium.com"+val.children[0].attribs.href
    # console.log val
    mediumPosts[i].title = title
    mediumPosts[i].url = url

  for val, i in $('.block-postMeta')
    mediumPosts[i].author = val.children[0].children[0].data
    mediumPosts[i].time = val.children[1].children[0].children[0].data

  # console.log mediumPosts

  mediumPosts

