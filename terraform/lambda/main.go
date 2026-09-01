package main

import (
	"context"
	"encoding/json"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"strconv"
)

type Response struct {
	ViewCount int `json:"view_count"`
}

var dbClient *dynamodb.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		panic("Failed to load AWS SDK config: " + err.Error())
	}
	dbClient = dynamodb.NewFromConfig(cfg)
}

func handler(ctx context.Context) (events.APIGatewayProxyResponse, error) {
	pageID := "home-page"

	input := &dynamodb.UpdateItemInput{
		TableName: aws.String("PageViews"),
		Key: map[string]types.AttributeValue{
			"id": &types.AttributeValueMemberS{Value: pageID},
		},
		UpdateExpression: aws.String("SET #v = if_not_exists(#v, :zero) + :inc"),
		ExpressionAttributeNames: map[string]string{
			"#v": "views",
		},
		ExpressionAttributeValues: map[string]types.AttributeValue{
			":inc":  &types.AttributeValueMemberN{Value: "1"},
			":zero": &types.AttributeValueMemberN{Value: "0"},
		},
		ReturnValues: types.ReturnValueUpdatedNew,
	}

	result, err := dbClient.UpdateItem(ctx, input)
	if err != nil {
		log.Printf("Error: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Headers: map[string]string{
				"Content-Type": "application/json",
			},
			Body: `{"error":"Failed to update database"}`,
		}, nil
	}

	viewsAttr := result.Attributes["views"].(*types.AttributeValueMemberN).Value
	viewsCount, _ := strconv.Atoi(viewsAttr)

	body, err := json.Marshal(Response{
		ViewCount: viewsCount,
	})

	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Headers: map[string]string{
				"Content-Type": "application/json",
			},
			Body: `{"error":"Failed to marshall"}`,
		}, err
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(body),
	}, nil
}

func main() {
	lambda.Start(handler)
}
