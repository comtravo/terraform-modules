
// +build integration

package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestFirehoseApply(t *testing.T) {

	terratestOptions := &terraform.Options{
		TerraformDir: ".",
		Vars:         map[string]interface{}{},
	}

	defer terraform.Destroy(t, terratestOptions)

	output := terraform.InitAndApply(t, terratestOptions)
	assert.Contains(t, output, "Apply complete! Resources: 4 added, 0 changed, 0 destroyed.")

	firehose_disabled_output := terraform.Output(t, terratestOptions, "firehose_disabled")
	assert.Equal(t, firehose_disabled_output, "")

	firehose_enabled_output := terraform.Output(t, terratestOptions, "firehose_enabled")
	assert.Equal(t, firehose_enabled_output, "arn:aws:firehose:us-east-1:000000000000:deliverystream/firehose_enabled")
}
