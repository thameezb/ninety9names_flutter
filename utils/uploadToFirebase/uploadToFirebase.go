package main

import (
	"context"
	"encoding/csv"
	"fmt"
	"log"
	"os"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/db"
	"google.golang.org/api/option"
)

type Name struct {
	ID              string `json:"id"`
	Arabic          string `json:"arabic"`
	Transliteration string `json:"transliteration"`
	MeaningShaykh   string `json:"meaning_shaykh"`
	Explanation     string `json:"explanation"`
}

func main() {
	dbURL := os.Getenv("FIREBASEDB_URL")
	if dbURL == "" {
		dbURL = "https://ninety9names-76425-default-rtdb.europe-west1.firebaseio.com"
	}
	db, err := mustInitDB(dbURL)
	if err != nil {
		log.Fatalf("error connecting to db %s", err)
	}

	csvPath := os.Getenv("CSV_PATH")
	if csvPath == "" {
		csvPath = "../../names.csv"
	}
	names, err := readCSVData(csvPath)
	if err != nil {
		log.Fatalf("error reading CSV %s", err)
	}

	if err := writeToFireBase(names, db); err != nil {
		log.Fatalf("error writing to DB %s", err)
	}
	log.Print("Upload Complete")
}

func mustInitDB(dbURL string) (*db.Client, error) {
	opt := option.WithCredentialsFile("sa.json")
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return nil, err
	}

	db, err := app.DatabaseWithURL(context.Background(), dbURL)
	if err != nil {
		return nil, err
	}
	return db, nil
}

func readCSVData(path string) (*[]Name, error) {
	log.Printf("Reading CSV from %s", path)
	csv_file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer csv_file.Close()

	r := csv.NewReader(csv_file)
	records, err := r.ReadAll()
	if err != nil {
		return nil, err
	}

	names := make([]Name, len(records))
	for i, rec := range records {
		names[i] = Name{
			ID:              rec[0],
			Arabic:          rec[1],
			Transliteration: rec[2],
			MeaningShaykh:   rec[3],
			Explanation:     rec[4],
		}
	}

	return &names, nil
}

func writeToFireBase(names *[]Name, db *db.Client) error {
	for _, n := range *names {
		if err := db.NewRef(fmt.Sprintf("names/%s", n.ID)).Set(context.Background(), names); err != nil {
			return err
		}
	}
	return nil
}
