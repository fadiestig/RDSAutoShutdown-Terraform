resource "aws_lambda_function" "rdsstart_lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "startlambda.zip"
  function_name = "rdsstart_lambda"
  role          = aws_iam_role.rdsstopstart-role.arn
  handler       = "start_lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("start_lambda_function.py")

  runtime = "python3.7"

  environment {
    variables = {
      REGION = "us-east-1"
      KEY    = "RDSAutoShutdown"
      VALUE  = "Yes"
    }
  }
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_event_rule" "rdsstart_lambda_rule" {
  name                = "rdsstart_lambda-rule"
  schedule_expression = "cron(1 * * * ? *)" # every hour, 40 mns passed the hour
}

resource "aws_cloudwatch_event_target" "rdsstart_lambda_target" {
  rule = aws_cloudwatch_event_rule.rdsstart_lambda_rule.name
  arn  = aws_lambda_function.rdsstart_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rdsstart_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rdsstart_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rdsstart_lambda_rule.arn
}