package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

func hnHandler(w http.ResponseWriter, r *http.Request) {
	response := crawlHackerNews()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(response); err != nil {
		log.Fatal(err)
	}
}

func phHandler(w http.ResponseWriter, r *http.Request) {
	response := crawlProductHunt()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(response); err != nil {
		log.Fatal(err)
	}
}

func crawlHandler(w http.ResponseWriter, r *http.Request) {
	urls := r.URL.Query()["urls[]"]

	response := crawl(urls)

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
	fs := http.FileServer(http.Dir("static"))

	router.Handle("/", fs)
	router.HandleFunc("/batch", crawlHandler)
	router.HandleFunc("/hn", hnHandler)
	router.HandleFunc("/ph", phHandler)

	fmt.Println("Listing on port", port)
	if err := http.ListenAndServe(":"+port, router); err != nil {
		log.Fatal(err)
	}
}
