module "dynamodb_table" {
  source = "../../../modules/database/dynamodb"

  table_name = "PageViews"
}