package testS3

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestS3_disabled(t *testing.T) {
	t.Parallel()

	name := fmt.Sprintf("ct-s3-%s", strings.ToLower(random.UniqueId()))
	exampleDir := "../s3/examples/disabled/"

	terraformOptions := SetupExample(t, name, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)

	require.Equal(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)
}

func TestS3_basic(t *testing.T) {
	t.Parallel()

	name := fmt.Sprintf("ct-s3-%s", strings.ToLower(random.UniqueId()))
	exampleDir := "../s3/examples/basic/"

	terraformOptions := SetupExample(t, name, exampleDir, nil)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	TerraformApplyAndValidateBasicOutputs(t, terraformOptions)
}

func SetupExample(t *testing.T, name string, exampleDir string, targets []string) *terraform.Options {

	terraformOptions := &terraform.Options{
		TerraformDir: exampleDir,
		Vars: map[string]interface{}{
			"name": name,
		},
		Targets:            targets,
		MaxRetries:         20,
		TimeBetweenRetries: 1 * time.Second,
		RetryableTerraformErrors: map[string]string{
			".*status code: 409.*": "Retry transient errors",
		},
	}

	return terraformOptions
}

func TerraformApplyAndValidateBasicOutputs(t *testing.T, terraformOptions *terraform.Options) {
	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)

	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)

	require.Greater(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)

	bucket := terraform.OutputMapOfObjects(t, terraformOptions, "bucket")
	require.Equal(t, bucket["bucket"], terraformOptions.Vars["name"])
	require.Equal(t, bucket["id"], terraformOptions.Vars["name"])
	require.Equal(t, bucket["arn"], fmt.Sprintf("arn:aws:s3:::%s", terraformOptions.Vars["name"]))
	require.Equal(t, bucket["bucket_domain_name"], fmt.Sprintf("%s.s3.amazonaws.com", terraformOptions.Vars["name"]))
	require.Equal(t, bucket["force_destroy"], false)
	require.Equal(t, bucket["acl"], "private")

	expectedServerSideEncryptionConfiguration := []map[string]interface{}([]map[string]interface{}{{"rule": []map[string]interface{}{{"apply_server_side_encryption_by_default": []map[string]interface{}{{"kms_master_key_id": "", "sse_algorithm": "AES256"}}, "bucket_key_enabled": false}}}})
	require.Equal(t, bucket["server_side_encryption_configuration"], expectedServerSideEncryptionConfiguration)

	awsS3BucketOwnershipControls := terraform.OutputMapOfObjects(t, terraformOptions, "aws_s3_bucket_ownership_controls")
	expectedAwsS3BucketOwnershipControls := map[string]interface{}(map[string]interface{}{"bucket": terraformOptions.Vars["name"], "id": terraformOptions.Vars["name"], "rule": []map[string]interface{}{{"object_ownership": "BucketOwnerPreferred"}}})
	require.Equal(t, expectedAwsS3BucketOwnershipControls, awsS3BucketOwnershipControls)
}
