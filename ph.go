package main

import (
	"encoding/json"
	"fmt"
)

type ProductHuntPost struct {
	Id          int    `json:"id"`
	Name        string `json:"name"`
	Tagline     string `json:"tagline"`
	Score       int    `json:"votes_count"`
	Url         string `json:"redirect_url"`
	NumComments int    `json:"comments_count"`
	Comments    string `json:"discussion_url"`
}

type ProductHuntResponse struct {
	Posts []ProductHuntPost `json:"posts"`
}

const PH = "https://api.producthunt.com/v1/posts"
const PH_TOKEN = "3c93dd9e925398bf433b0c679fb063e1eefe0c6e7b41fe762e37d5826c9a5991"
const NUM_PH_POSTS = 2

func crawlProductHunt() Posts {
	posts := make(Posts, 0, NUM_PH_POSTS)

	req := request(PH)
	req.Header.Set("Authorization", "Bearer "+PH_TOKEN)

	res, err := get(req)

	if err == nil {
		var phResponse ProductHuntResponse

		decoder := json.NewDecoder(res.Body)
		decoder.Decode(&phResponse)

		for i := 0; i < cap(posts); i++ {
			phPost := phResponse.Posts[i]
			posts = append(posts, Post{
				Id:          fmt.Sprint("ph-", phPost.Id),
				Title:       phPost.Name + " - " + phPost.Tagline,
				Score:       phPost.Score,
				Url:         phPost.Url,
				NumComments: phPost.NumComments,
				Comments:    phPost.Comments,
			})
		}
	}

	return posts
}
