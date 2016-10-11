import requests


def handler(event, context):
    return [standardize(post['data']) for post in get_all_hot()['data']['children']]


def get_all_hot():
    return requests.get('https://www.reddit.com/r/all/hot.json').json()


def standardize(post):
    print post
    return {
        'id': post['id'],
        'title': post['title'],
        'score': post['score'],
        'url': post['url'],
        'numComments': post['num_comments'],
        'comments': 'https://www.reddit.com/%s' % post['permalink']
    }
