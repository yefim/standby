package main

import (
	"encoding/json"
	"fmt"
)

type HackerNewsResponse []int

type HackerNewsPost struct {
	Id          int    `json:"id"`
	Title       string `json:"title"`
	Score       int    `json:"score"`
	Url         string `json:"url"`
	NumComments int    `json:"descendants"`
}

const HN = "https://hacker-news.firebaseio.com/v0/topstories.json"
const NUM_POSTS = 20

func itemUrl(id int) string {
	return fmt.Sprint("https://hacker-news.firebaseio.com/v0/item/", id, ".json")
}

func crawlHackerNews() Posts {
	res, err := get(request(HN))

	if err != nil {
		return make(Posts, 0)
	}

	var ids HackerNewsResponse
	urls := make([]string, 0, NUM_POSTS)

	decoder := json.NewDecoder(res.Body)
	decoder.Decode(&ids)

	for i := 0; i < cap(urls); i++ {
		urls = append(urls, itemUrl(ids[i]))
	}

	return crawlHackerNewsPosts(urls)
}

func crawlHackerNewsPosts(urls []string) Posts {
	resc := make(chan Post)
	posts := make(Posts, 0, len(urls))

	for _, url := range urls {
		go func(url string) {
			res, err := get(request(url))
			var hnPost HackerNewsPost

			if err == nil {
				decoder := json.NewDecoder(res.Body)
				decoder.Decode(&hnPost)
			}

			resc <- Post{
				Id:          fmt.Sprint("hn-", hnPost.Id),
				Title:       hnPost.Title,
				Score:       hnPost.Score,
				Url:         hnPost.Url,
				NumComments: hnPost.NumComments,
				Comments:    fmt.Sprint("https://news.ycombinator.com/item?id=", hnPost.Id),
				Error:       err,
			}
		}(url)
	}

	for i := 0; i < len(urls); i++ {
		post := <-resc
		posts = append(posts, post)
	}

	return posts
}
