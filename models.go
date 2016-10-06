package main

type Page struct {
	Url   string `json:"url"`
	Body  string `json:"body"`
	Error error  `json:"error"`
}

type Response []Page

type Post struct {
	Id          string `json:"id"`
	Title       string `json:"title"`
	Score       int    `json:"score"`
	Url         string `json:"url"`
	NumComments int    `json:"numComments"`
	Comments    string `json:"comments"`
	Error       error  `json:"error"`
}

type Posts []Post
