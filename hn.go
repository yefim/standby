package main

import (
	"encoding/json"
	"fmt"
)

type HackerNewsResponse []int

const HN = "https://hacker-news.firebaseio.com/v0/topstories.json"

func itemUrl(id int) string {
	return fmt.Sprint("https://hacker-news.firebaseio.com/v0/item/", id, ".json")
}

func crawlHackerNews() Response {
	res, err := get(HN)

	if err != nil {
		return Response{
			Page{
				Url:   HN,
				Error: err,
			},
		}
	}

	var ids HackerNewsResponse
	decoder := json.NewDecoder(res.Body)
	decoder.Decode(&ids)

	urls := make([]string, 0, 2)

	for i := 0; i < cap(urls); i++ {
		urls = append(urls, itemUrl(ids[i]))
	}

	return crawl(urls)
}
