// +build integration

package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFirehoseApply(t *testing.T) {

	terratestOptions := &terraform.Options{
		TerraformDir: "../firehose/examples/",
		Vars:         map[string]interface{}{},
	}

	defer terraform.Destroy(t, terratestOptions)

	output := terraform.InitAndApply(t, terratestOptions)
	assert.Contains(t, output, "Apply complete! Resources: 5 added, 0 changed, 0 destroyed.")

	firehose_disabled_output := terraform.Output(t, terratestOptions, "firehose_disabled")
	assert.Equal(t, firehose_disabled_output, "")

	firehose_enabled_output := terraform.Output(t, terratestOptions, "firehose_enabled")
	assert.Regexp(t,
		regexp.MustCompile(fmt.Sprintf("arn:aws:firehose:us-east-1:\\d{12}:deliverystream/firehose_enabled")),
		firehose_enabled_output,
	)
}
