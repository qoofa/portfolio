module "dynamodb_table" {
  source = "../../../modules/database/dynamodb"

  table_name = "PageViews"
}

module "go_lambda_api" {
  source = "../../../modules/services/go-lambda"

  ecr_name = "portfolio_go_api"
  function_name = "view_count"
}