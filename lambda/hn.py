import threading
import json
import urllib2


def handler(event, context):
    return top_stories()


def standardize(story):
    return {
        'id': 'hn-%d' % story['id'],
        'title': story['title'],
        'score': story['score'],
        'url': story['url'],
        'numComments': story['descendants'],
        'comments': 'https://news.ycombinator.com/item?id=%d' % story['id']
    }


def fetch_url(url):
    urlHandler = urllib2.urlopen(url)
    html = urlHandler.read()
    return html


def fetch_story(id, stories):
    url = 'https://hacker-news.firebaseio.com/v0/item/%s.json' % id
    html = fetch_url(url)
    stories.append(standardize(json.loads(html)))


def top_story_ids():
    url = 'https://hacker-news.firebaseio.com/v0/topstories.json'
    response = fetch_url(url)
    response = response[1:-1]
    return response.split(',')


def top_stories(limit=15):
    stories = []
    ids = top_story_ids()

    threads = [threading.Thread(
        target=fetch_story,
        args=(id, stories,)
    ) for id in ids[:limit]]

    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()

    return stories
