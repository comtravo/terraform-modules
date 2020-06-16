
// +build unit

package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestFirehosePlan(t *testing.T) {

	terratestOptions := &terraform.Options{
		TerraformDir: ".",
		Vars:         map[string]interface{}{},
	}

	defer terraform.Destroy(t, terratestOptions)

	output := terraform.InitAndPlan(t, terratestOptions)

	assert.Contains(t, output, "4 to add, 0 to change, 0 to destroy.")
}
