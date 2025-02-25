package main

import (
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

func main() {
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/status", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("running"))
	})

	http.ListenAndServe(":8081", r)
}
