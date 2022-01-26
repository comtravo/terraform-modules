package test

import (
	"fmt"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestLegacyVPCApplyEnabledBasic(t *testing.T) {

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"azs":                []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"nat_az_number":      1,
		"environment":        vpc_name,
		"replication_factor": 3,
	}

	terraformOptions := LegacyVPCSetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t, terraformOptions, 25)
	LegacyVPCValidateTerraformModuleOutputs(t, terraformOptions)
}

func TestLegacyVPCApplyEnabledBasic_tags(t *testing.T) {
	t.Skip()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"azs":                []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"nat_az_number":      1,
		"environment":        vpc_name,
		"replication_factor": 3,
		"tags": map[string]string{
			"kubernetes.io/cluster/foo": "shared",
		},
		"public_subnet_tags": map[string]string{
			"kubernetes.io/cluster/foo": "shared",
			"kubernetes.io/role/elb":    "1",
		},
		"private_subnet_tags": map[string]string{
			"kubernetes.io/cluster/foo":       "shared",
			"kubernetes.io/role/internal-elb": "1",
		},
	}

	terraformOptions := LegacyVPCSetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t, terraformOptions, 25)
	LegacyVPCValidateTerraformModuleOutputs(t, terraformOptions)
}

func TestLegacyVPCApplyEnabledReplicationFactor(t *testing.T) {
	t.Skip()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"azs":                []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"nat_az_number":      1,
		"environment":        vpc_name,
		"replication_factor": 2,
	}

	terraformOptions := LegacyVPCSetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t, terraformOptions, 21)
	LegacyVPCValidateTerraformModuleOutputs(t, terraformOptions)
}

func TestLegacyVPCApplyEnabledSingleAvailabilityZone(t *testing.T) {
	t.Skip()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"azs":                []string{"us-east-1a"},
		"nat_az_number":      1,
		"environment":        vpc_name,
		"replication_factor": 2,
	}

	terraformOptions := LegacyVPCSetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t, terraformOptions, 21)
	LegacyVPCValidateTerraformModuleOutputs(t, terraformOptions)
}

func TestLegacyVPCApplyEnabledNoPublicSubdomain(t *testing.T) {
	t.Skip()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.11.0.0/16",
		"azs":                []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"nat_az_number":      1,
		"environment":        vpc_name,
		"replication_factor": 3,
	}

	terraformOptions := LegacyVPCSetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t, terraformOptions, 24)
	LegacyVPCValidateTerraformModuleOutputs(t, terraformOptions)
}

func TestLegacyVPCApplyDisabled_Basic(t *testing.T) {
	t.Skip()

	vpc_name := fmt.Sprintf("vpc_disabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             false,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.12.0.0/16",
		"azs":                []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"nat_az_number":      1,
		"environment":        vpc_name,
		"replication_factor": 3,
	}

	terraformOptions := LegacyVPCSetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t, terraformOptions, 0)
}

func LegacyVPCSetupTestCase(t *testing.T, terraformModuleVars map[string]interface{}) *terraform.Options {
	testRunFolder, err := files.CopyTerraformFolderToTemp("../vpc-legacy", t.Name())
	assert.NoError(t, err)
	t.Logf("Copied files to test folder: %s", testRunFolder)

	terraformOptions := &terraform.Options{
		TerraformDir: testRunFolder,
		Vars:         terraformModuleVars,
	}
	return terraformOptions
}

func LegacyVPCValidateTerraformModuleOutputs(t *testing.T, terraformOptions *terraform.Options) {
	LegacyVPCValidateVPC(t, terraformOptions)

	LegacyVPCValidateVPCDefaultSecurityGroup(t, terraformOptions)

	LegacyVPCValidateVPCRoute53ZoneID(t, terraformOptions)
	LegacyVPCValidateVPCRoute53ZoneName(t, terraformOptions)

	LegacyVPCValidateVPCSubdomainNameServers(t, terraformOptions)

	LegacyVPCValidateVPCRoute53ZoneName(t, terraformOptions)

	LegacyVPCValidateVPCRoutingTables(t, terraformOptions)

	LegacyVPCValidateVPCSubnets(t, terraformOptions)
	LegacyVPCValidateDependId(t, terraformOptions)
}

func LegacyVPCValidateVPCSubnets(t *testing.T, terraformOptions *terraform.Options) {
	private_subnets := terraform.OutputList(t, terraformOptions, "private_subnets")
	public_subnets := terraform.OutputList(t, terraformOptions, "public_subnets")

	assert.Len(t, private_subnets, terraformOptions.Vars["replication_factor"].(int))
	assert.Len(t, public_subnets, terraformOptions.Vars["replication_factor"].(int))
	assert.NotEqual(t, public_subnets, private_subnets)
}

func LegacyVPCValidateVPCSubdomainNameServers(t *testing.T, terraformOptions *terraform.Options) {
	publicSubdomainNameServers := terraform.OutputList(t, terraformOptions, "public_subdomain_name_servers")

	if terraformOptions.Vars["subdomain"] == "" {
		assert.Len(t, publicSubdomainNameServers, 0)
	} else {
		assert.Greater(t, len(publicSubdomainNameServers), 0)
	}

}

func LegacyVPCValidateVPC(t *testing.T, terraformOptions *terraform.Options) {
	vpc_id := terraform.Output(t, terraformOptions, "vpc_id")
	assert.Regexp(t, "vpc-*", vpc_id)
}

func LegacyVPCValidateVPCDefaultSecurityGroup(t *testing.T, terraformOptions *terraform.Options) {
	vpc_default_sg := terraform.Output(t, terraformOptions, "vpc_default_sg")
	assert.Regexp(t, "sg-*", vpc_default_sg)
}

func LegacyVPCValidateVPCRoute53ZoneID(t *testing.T, terraformOptions *terraform.Options) {
	net0ps_zone_id := terraform.Output(t, terraformOptions, "net0ps_zone_id")
	private_zone_id := terraform.Output(t, terraformOptions, "private_zone_id")

	subdomain_zone_id := terraform.Output(t, terraformOptions, "subdomain_zone_id")
	public_subdomain_zone_id := terraform.Output(t, terraformOptions, "public_subdomain_zone_id")

	assert.NotEqual(t, "", net0ps_zone_id)
	assert.NotEqual(t, "", private_zone_id)
	assert.Equal(t, net0ps_zone_id, private_zone_id)

	publicSubdomainRegex := regexp.MustCompile("^[A-Za-z0-9,-_.\\s]+$")

	if terraformOptions.Vars["subdomain"] == "" {
		publicSubdomainRegex = regexp.MustCompile("^$")
	}

	assert.Regexp(t, publicSubdomainRegex, subdomain_zone_id)
	assert.Regexp(t, publicSubdomainRegex, public_subdomain_zone_id)
	assert.Equal(t, subdomain_zone_id, public_subdomain_zone_id)

	assert.NotEqual(t, private_zone_id, public_subdomain_zone_id)
}

func LegacyVPCValidateVPCRoute53ZoneName(t *testing.T, terraformOptions *terraform.Options) {
	public_subdomain := terraform.Output(t, terraformOptions, "public_subdomain")
	private_subdomain := terraform.Output(t, terraformOptions, "private_subdomain")

	assert.Equal(t, terraformOptions.Vars["subdomain"], public_subdomain)
	assert.Equal(t, fmt.Sprintf("%s-net0ps.com", terraformOptions.Vars["vpc_name"]), private_subdomain)
}

func LegacyVPCValidateVPCRoutingTables(t *testing.T, terraformOptions *terraform.Options) {
	vpc_private_routing_table_id := terraform.Output(t, terraformOptions, "vpc_private_routing_table_id")
	vpc_public_routing_table_id := terraform.Output(t, terraformOptions, "vpc_public_routing_table_id")

	assert.Regexp(t, "rtb-*", vpc_private_routing_table_id)
	assert.Regexp(t, "rtb-*", vpc_public_routing_table_id)
	assert.NotEqual(t, vpc_private_routing_table_id, vpc_public_routing_table_id)
}

func LegacyVPCValidateDependId(t *testing.T, terraformOptions *terraform.Options) {
	depends_id := terraform.Output(t, terraformOptions, "depends_id")
	assert.NotEqual(t, "", depends_id)
}

func LegacyVPCModuleTerraformApplyAndVerifyResourcesCreated(t *testing.T, terraformOptions *terraform.Options, expectedNumberOfResourcesCreated int) {
	terraform_apply_output := terraform.InitAndApply(t, terraformOptions)
	assert.Contains(t, terraform_apply_output, fmt.Sprintf("Apply complete! Resources: %d added, 0 changed, 0 destroyed.", expectedNumberOfResourcesCreated))
}
