from utils import success_response
import requests

def handler(event, context):
    return success_response(get_all_hot())

def get_all_hot():
    return requests.get('https://www.reddit.com/r/all/hot.json').json()

