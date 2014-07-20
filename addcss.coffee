cheerio = require('cheerio')
urllib = require('url')

exports.fixLinks = (html, url) ->
  $ = cheerio.load(html)
  for key,val of $('link[rel=stylesheet]')
    if val.attribs and val.attribs.href
      console.log(val.attribs.href)
      val.attribs.href = remotizeURL(val.attribs.href, url)
      console.log(val.attribs.href)
  for key,val of $('script')
    if val.attribs and val.attribs.src
      console.log(val.attribs.src)
      val.attribs.src = remotizeURL(val.attribs.src, url)
      console.log(val.attribs.src)

  for key,val of $('img')
    if val.attribs and val.attribs.src
      console.log(val.attribs.src)
      val.attribs.src = remotizeURL(val.attribs.src, url)
      console.log(val.attribs.src)

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
