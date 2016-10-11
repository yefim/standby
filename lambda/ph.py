import requests

PH = "https://api.producthunt.com/v1/posts"
PH_TOKEN = "3c93dd9e925398bf433b0c679fb063e1eefe0c6e7b41fe762e37d5826c9a5991"


def handler(event, context):
    return [standardize(post) for post in top_posts()['posts']]


def top_posts():
    return requests.get(PH, headers={'Authorization': 'Bearer %s' % PH_TOKEN}).json()


def standardize(post):
    return {
        'id': post['id'],
        'title': post['name'],
        'score': post['votes_count'],
        'url': post['redirect_url'],
        'numComments': post['comments_count'],
        'comments': post['discussion_url']
    }
