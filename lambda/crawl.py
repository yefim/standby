import threading
import json

import urllib2
from bs4 import BeautifulSoup
from urlparse import urlparse, urljoin


def handler(event, context):
    return crawl(event.get('urls', []))


def isAbsoluteUrl(url):
    return any([url.startswith(s) for s in ['//', 'http', 'javascript', 'data:']])


def fetch_url(url, pages):
    urlHandler = urllib2.urlopen(url)
    html = urlHandler.read()
    finalUrl = urlHandler.geturl()
    urlObj = urlparse(finalUrl)
    prefix = urlObj.scheme + "://" + urlObj.netloc + urlObj.path

    soup = BeautifulSoup(html, 'html.parser')

    for script in soup.find_all('script'):
        if script.get('src') != None and not isAbsoluteUrl(script.get('src')):
            script['src'] = urljoin(prefix, script.get('src'))

    for stylesheet in soup.find_all('link', rel='stylesheet'):
        if stylesheet.get('href') != None and not isAbsoluteUrl(stylesheet.get('href')):
            stylesheet['href'] = urljoin(prefix, stylesheet.get('href'))

    for img in soup.find_all('img'):
        if img.get('src') != None and not isAbsoluteUrl(img.get('src')):
            img['src'] = urljoin(prefix, img.get('src'))

    pages.append({
        'originalUrl': url,
        'finalUrl': finalUrl,
        'body': str(soup)
    })


def crawl(urls=[]):
    pages = []

    threads = [threading.Thread(
        target=fetch_url,
        args=(url, pages,)
    ) for url in urls]

    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()

    return pages
