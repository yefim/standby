import threading
import json
import urllib2
from bs4 import BeautifulSoup
from urlparse import urlparse, urljoin


def handler(event, context):
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
            'Content-Type': 'application/json'
        },
        'body': json.dumps(crawl(event['urls']))
    }

def isAbsoluteUrl(url):
    return any([url.startswith(s) for s in ['//','http','javascript','data:']])

def fetch_url(url, pages):
    urlHandler = urllib2.urlopen(url)
    html = urlHandler.read()
    urlObj = urlparse(url)
    prefix = urlObj.scheme + "://" + urlObj.netloc + urlObj.path

    soup = BeautifulSoup(html, 'html.parser')

    for script in soup.find_all('script'):
        if script.get('src') != None and not isAbsoluteUrl(script.get('src')):
            print script.get('src')
            print script
            script['src'] = urljoin(prefix, script.get('src'))
            print script.get('src')

    for stylesheet in soup.find_all('link[rel="stylesheet"]'):
        if stylesheet.get('href') != None and not isAbsoluteUrl(stylesheet.get('href')):
            print stylesheet.get('href')
            stylehseet.href = urljoin(prefix, stylesheet.href)
            print stylesheet.get('href')

    for img in soup.find_all('img'):
        if img.get('src') != None and not isAbsoluteUrl(img.get('src')):
            print img.get('src')
            img['src'] = urljoin(prefix, img.get('src'))
            print img.get('src')

    pages.append({
        'originalUrl': url,
        'finalUrl': urlHandler.geturl(),
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
