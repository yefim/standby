import requests
import json
from gevent import pool

def handler(event, context):
    return {
        'statusCode': 200,
        'headers': {"Access-Control-Allow-Origin":"*","Access-Control-Allow-Methods":"OPTIONS","Access-Control-Allow-Headers":"Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token","Content-Type":"application/json"},
        'body': json.dumps(top_stories()),
    }

def top_story_ids():
    return requests.get('https://hacker-news.firebaseio.com/v0/topstories.json').json()

def story(id):
    return requests.get('https://hacker-news.firebaseio.com/v0/item/%d.json' % id).json()

def top_stories(limit=25):
    rpool = pool.Pool(size=25)
    return rpool.map(story, list(top_story_ids())[:limit])
