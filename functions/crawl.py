import threading
import json
import urllib2


def handler(event, context):
    urls = event.get('queryStringParameters', {}).get('urls').split(' ')
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
            'Content-Type': 'application/json'
        },
        'body': json.dumps(crawl(urls))
    }


def fetch_url(url, pages):
    urlHandler = urllib2.urlopen(url)
    html = urlHandler.read()

    pages.append({
        'originalUrl': url,
        'finalUrl': urlHandler.geturl(),
        'body': html
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
