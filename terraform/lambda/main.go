package main

import (
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	ViewCount int `json:"view_count"`
}

func handler(ctx context.Context) (events.APIGatewayProxyResponse, error) {
	body, err := json.Marshal(Response{
		ViewCount: 100,
	})

	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       `{"error":"Failed to marshall"}`,
		}, err
	}

	response := events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(body),
	}

	return response, nil
}

func main() {
	lambda.Start(handler)
}
