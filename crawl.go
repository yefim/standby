package main

import (
	"io/ioutil"
	"net/http"
	"time"
)

func crawl(urls []string) Response {
	resc := make(chan Page)
	pages := make(Response, 0, len(urls))

	for _, url := range urls {
		go func(url string) {
			body, err := fetch(url)
			resc <- Page{
				Url:   url,
				Body:  body,
				Error: err,
			}
		}(url)
	}

	for i := 0; i < len(urls); i++ {
		page := <-resc
		pages = append(pages, page)
	}

	return pages
}

func fetch(url string) (string, error) {
	var httpClient = &http.Client{
		Timeout: time.Second * 6,
	}
	res, err := httpClient.Get(url)
	if err != nil {
		return "", err
	}
	body, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		return "", err
	}
	return string(body), nil
}
