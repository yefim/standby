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
			finalUrl, body, err := fetch(request(url))
			resc <- Page{
				Url:   finalUrl,
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

func request(url string) *http.Request {
	req, _ := http.NewRequest("GET", url, nil)
	return req
}

func fetch(req *http.Request) (string, string, error) {
	res, err := get(req)
	if err != nil {
		return req.URL.String(), "", err
	}
	body, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		return req.URL.String(), "", err
	}
	return res.Request.URL.String(), string(body), nil
}

func get(req *http.Request) (*http.Response, error) {
	httpClient := &http.Client{
		Timeout: time.Second * 6,
	}
	return httpClient.Do(req)
}
