package main

type Page struct {
	Url   string `json:"url"`
	Body  string `json:"body"`
	Error error  `json:"error"`
}

type Response []Page
