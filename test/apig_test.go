package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestAPIG_lambda(t *testing.T) {
	t.Parallel()

	apigName := fmt.Sprintf("apig-%s", random.UniqueId())
	exampleDir := "../examples/lambda/"

	terraformOptions := SetupExample(t, apigName, exampleDir)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateOutputs(t, terraformOptions)
}

func SetupExample(t *testing.T, apigName string, exampleDir string) *terraform.Options {
	terraformOptions := &terraform.Options{
		TerraformDir: exampleDir,
		EnvVars: map[string]string{
			"AWS_REGION": "us-east-1",
		},
		Vars: map[string]interface{}{
			"name": apigName,
		},
	}
	return terraformOptions
}

func TerraformApplyAndValidateOutputs(t *testing.T, terraformOptions *terraform.Options) {
	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)

	require.Greater(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)

	aws_apigatewayv2_api_output, err := terraform.OutputMapE(t, terraformOptions, "aws_apigatewayv2_api")
	require.NoError(t, err)
	require.Equal(t, aws_apigatewayv2_api_output["name"], terraformOptions.Vars["name"])
	require.Equal(t, aws_apigatewayv2_api_output["protocol_type"], "HTTP")
	require.Equal(t, aws_apigatewayv2_api_output["disable_execute_api_endpoint"], "false")
	require.NotEqual(t, "", aws_apigatewayv2_api_output["version"])
	require.NotEqual(t, "", aws_apigatewayv2_api_output["body"])
	require.NotEqual(t, "", aws_apigatewayv2_api_output["id"])
	require.Regexp(t, regexp.MustCompile("arn:aws:execute-api:us-east-1:\\d{12}:*"), aws_apigatewayv2_api_output["execution_arn"])
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1::/apis/*"), aws_apigatewayv2_api_output["arn"])

	aws_apigatewayv2_deployment_output, err := terraform.OutputMapE(t, terraformOptions, "aws_apigatewayv2_deployment")
	require.NoError(t, err)
	require.Equal(t, aws_apigatewayv2_deployment_output["auto_deployed"], "false")
	require.Equal(t, aws_apigatewayv2_deployment_output["api_id"], aws_apigatewayv2_api_output["id"])

	aws_apigatewayv2_stage_output, err := terraform.OutputMapE(t, terraformOptions, "aws_apigatewayv2_stage")
	require.NoError(t, err)
	require.Equal(t, aws_apigatewayv2_stage_output["api_id"], aws_apigatewayv2_api_output["id"])
	require.Equal(t, aws_apigatewayv2_stage_output["auto_deploy"], "false")
	require.Equal(t, aws_apigatewayv2_stage_output["deployment_id"], aws_apigatewayv2_deployment_output["id"])
	require.Regexp(t, regexp.MustCompile("arn:aws:apigateway:us-east-1::/apis/*"), aws_apigatewayv2_stage_output["arn"])
	require.NotEqual(t, "", aws_apigatewayv2_stage_output["id"])
	require.NotEqual(t, "", aws_apigatewayv2_stage_output["invoke_url"])

	aws_cloudwatch_log_group_output, err := terraform.OutputMapE(t, terraformOptions, "aws_cloudwatch_log_group")
	require.NoError(t, err)
	require.Regexp(t, regexp.MustCompile("arn:aws:logs:us-east-1:\\d{12}:log-group:*"), aws_cloudwatch_log_group_output["arn"])
	require.NotEqual(t, "", aws_cloudwatch_log_group_output["id"])
	require.NotEqual(t, "", aws_cloudwatch_log_group_output["name"])
	require.Equal(t, "90", aws_cloudwatch_log_group_output["retention_in_days"])
}
