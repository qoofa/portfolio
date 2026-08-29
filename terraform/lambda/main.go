package main

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.context) {
	return "Hello world"
}

func main() {
	lambda.Start(handler)
}
