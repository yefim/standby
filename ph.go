package main

const PH = "https://api.producthunt.com/v1/posts"
const PH_TOKEN = "3c93dd9e925398bf433b0c679fb063e1eefe0c6e7b41fe762e37d5826c9a5991"

func crawlProductHunt() Response {
	req := request(PH)
	req.Header.Set("Authorization", "Bearer "+PH_TOKEN)

	body, err := fetch(req)

	return Response{
		Page{
			Url:   PH,
			Body:  body,
			Error: err,
		},
	}
}
