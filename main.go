package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

func indexHander(w http.ResponseWriter, r *http.Request) {
	response := crawlHackerNews()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(response); err != nil {
		log.Fatal(err)
	}
}

func main() {
	port := os.Getenv("PORT")

	if port == "" {
		port = "5555"
	}

	router := http.NewServeMux()

	router.HandleFunc("/", indexHander)

	fmt.Println("Listing on port", port)
	if err := http.ListenAndServe(":"+port, router); err != nil {
		log.Fatal(err)
	}
}
