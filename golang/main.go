package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

var coldStartTime time.Time

func init() {
	coldStartTime = time.Now()
}

func isPrime(n int) bool {
	if n <= 1 {
		return false
	}
	for i := 2; i*i <= n; i++ {
		if n%i == 0 {
			return false
		}
	}
	return true
}

func handler(ctx context.Context) (string, error) {
	N, err := strconv.Atoi(os.Getenv("N"))
	if err != nil {
		return "", err
	}

	bucket := os.Getenv("BUCKET_NAME")
	startTime := time.Now()

	isPrime(N)
	endTime := time.Now()

	result := map[string]interface{}{
		"language":          "Go",
		"cold_started_at":   coldStartTime.Format(time.RFC3339),
		"warm_started_at":   startTime.Format(time.RFC3339),
		"finished_at":       endTime.Format(time.RFC3339),
		"cold_elapsed_time": endTime.Sub(coldStartTime).String(),
		"warm_elapsed_time": endTime.Sub(startTime).String(),
		"n":                 N,
	}

	jsonData, err := json.Marshal(result)
	if err != nil {
		return "", err
	}

	// Salvando no S3
	sess := session.Must(session.NewSession())
	uploader := s3manager.NewUploader(sess)

	_, err = uploader.Upload(&s3manager.UploadInput{
		Bucket: aws.String(bucket),
		Key:    aws.String("result_go.json"),
		Body:   bytes.NewReader(jsonData),
	})
	if err != nil {
		return "", err
	}

	return fmt.Sprintf("Dados salvos no S3: %v", result), nil
}

func main() {
	lambda.Start(handler)
}
