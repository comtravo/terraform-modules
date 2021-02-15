// +build localstack

package test

import (
	"fmt"
	"path"
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestVPCApplyEnabled_basic(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 1)
}

func TestVPCApplyEnabled_basicTags(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":   true,
		"vpc_name": vpc_name,
		"vpc_tags": map[string]string{
			"lorem": "ipsum",
			"foo":   "bar",
			"baz":   "jazz",
		},
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags": map[string]string{
				"lorem": "ipsum",
			},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags": map[string]string{
				"lorem": "ipsum",
				"foo":   "bar",
			},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 1)
}

func TestVPCApplyEnabled_twoAvailabilityZones(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 1)
}

func TestVPCApplyEnabled_differentSubnetConfigurations(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 1,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 1)
}

func TestVPCApplyEnabled_noPublicSubdomain(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 1,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 1)
}

func TestVPCApplyEnabled_natPerAZ(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_availability_zone",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 1,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 3)
	ValidatePrivateRoutingTables(t, terraformOptions, 3)
	ValidateElasticIps(t, terraformOptions, 3)
}

func TestVPCApplyEnabled_natPerAZInTwoAZ(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_availability_zone",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 1,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 2)
	ValidatePrivateRoutingTables(t, terraformOptions, 2)
	ValidateElasticIps(t, terraformOptions, 2)
}

func TestVPCApplyEnabled_externalElasticIPsNatPerAZ(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"external_eip_count": 5,
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_availability_zone",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	SetupExternalElasticIPs(t, terraformOptions)
	require.Len(t, terraformOptions.Vars["external_elastic_ips"], terraformOptions.Vars["external_eip_count"].(int))

	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 3)
	ValidatePrivateRoutingTables(t, terraformOptions, 3)
	ValidateElasticIps(t, terraformOptions, 5)
	ValidateExternalElasticIPs(t, terraformOptions)
}

func TestVPCApplyEnabled_externalElasticIPsLessThanDesiredNATCount(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"external_eip_count": 1,
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_availability_zone",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	SetupExternalElasticIPs(t, terraformOptions)
	require.Len(t, terraformOptions.Vars["external_elastic_ips"], terraformOptions.Vars["external_eip_count"].(int))

	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 1)
	ValidateExternalElasticIPs(t, terraformOptions)
}

func TestVPCApplyEnabled_externalElasticIPsSingleNAT(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             true,
		"vpc_name":           vpc_name,
		"subdomain":          "",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"external_eip_count": 5,
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	SetupExternalElasticIPs(t, terraformOptions)
	require.Len(t, terraformOptions.Vars["external_elastic_ips"], terraformOptions.Vars["external_eip_count"].(int))

	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	ValidateTerraformModuleOutputs(t, terraformOptions)
	ValidateNATGateways(t, terraformOptions, 1)
	ValidatePrivateRoutingTables(t, terraformOptions, 1)
	ValidateElasticIps(t, terraformOptions, 5)
	ValidateExternalElasticIPs(t, terraformOptions)
}

func TestVPCApplyDisabled(t *testing.T) {
	t.Parallel()

	vpc_name := fmt.Sprintf("vpc_enabled-%s", random.UniqueId())

	terraformModuleVars := map[string]interface{}{
		"enable":             false,
		"vpc_name":           vpc_name,
		"subdomain":          "foo.bar.baz",
		"cidr":               "10.10.0.0/16",
		"availability_zones": []string{"us-east-1a", "us-east-1b", "us-east-1c"},
		"tags": map[string]string{
			"Name": vpc_name,
		},
		"nat_gateway": map[string]string{
			"behavior": "one_nat_per_vpc",
		},
		"enable_dns_support":               true,
		"assign_generated_ipv6_cidr_block": true,
		"private_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     0,
			"tags":              map[string]string{},
		},
		"public_subnets": map[string]interface{}{
			"number_of_subnets": 3,
			"newbits":           8,
			"netnum_offset":     100,
			"tags":              map[string]string{},
		},
	}

	terraformOptions := SetupTestCase(t, terraformModuleVars)
	t.Logf("Terraform module inputs: %+v", *terraformOptions)
	// defer terraform.Destroy(t, terraformOptions)

	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)
	require.Equal(t, resourceCount.Add, 0)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)
}

func SetupTestCase(t *testing.T, terraformModuleVars map[string]interface{}) *terraform.Options {
	testRunFolder, err := files.CopyTerraformFolderToTemp("../", t.Name())
	require.NoError(t, err)
	t.Logf("Copied files to test folder: %s", testRunFolder)

	localstackConfigDestination := path.Join(testRunFolder, "localstack.tf")
	files.CopyFile("fixtures/localstack.tf", localstackConfigDestination)
	t.Logf("Copied localstack file to: %s", localstackConfigDestination)

	terraformOptions := &terraform.Options{
		TerraformDir: testRunFolder,
		Vars:         terraformModuleVars,
	}
	return terraformOptions
}

func SetupExternalElasticIPs(t *testing.T, terraformOptions *terraform.Options) {
	externalElasticIPsFileDestination := path.Join(terraformOptions.TerraformDir, "eip.tf")
	files.CopyFile("fixtures/eip.tf", externalElasticIPsFileDestination)
	t.Logf("Copied eip file to: %s", externalElasticIPsFileDestination)

	terraformOptions.Targets = []string{"aws_eip.external"}
	t.Logf("Terraform module inputs for Elastic IPs: %+v", *terraformOptions)
	terraformApplyOutput := terraform.InitAndApply(t, terraformOptions)
	resourceCount := terraform.GetResourceCount(t, terraformApplyOutput)
	external_elastic_ips := terraform.OutputList(t, terraformOptions, "external_elastic_ips")

	exptected_external_eip_count := terraformOptions.Vars["external_eip_count"].(int)

	require.Equal(t, resourceCount.Add, exptected_external_eip_count)
	require.Equal(t, resourceCount.Change, 0)
	require.Equal(t, resourceCount.Destroy, 0)
	require.Len(t, external_elastic_ips, exptected_external_eip_count)

	t.Logf("External elastic IPs created: %s", external_elastic_ips)

	terraformOptions.Targets = []string{}
	terraformOptions.Vars["external_elastic_ips"] = external_elastic_ips
}

func ValidateTerraformModuleOutputs(t *testing.T, terraformOptions *terraform.Options) {
	ValidateVPC(t, terraformOptions)

	ValidateVPCDefaultSecurityGroup(t, terraformOptions)

	ValidateVPCRoute53ZoneID(t, terraformOptions)
	ValidateVPCRoute53ZoneName(t, terraformOptions)

	ValidateVPCRoutingTables(t, terraformOptions)

	ValidateVPCSubnets(t, terraformOptions)
	ValidateDependId(t, terraformOptions)
}

func ValidateNATGateways(t *testing.T, terraformOptions *terraform.Options, expectedNumberOfResources int) {
	nat_gateway_ids := terraform.OutputList(t, terraformOptions, "nat_gateway_ids")
	ValidateCount(t, nat_gateway_ids, expectedNumberOfResources)
	ValidateEachElementInArray(t, nat_gateway_ids, "nat-*")
}

func ValidateElasticIps(t *testing.T, terraformOptions *terraform.Options, expectedNumberOfResources int) {
	elastic_ips := terraform.OutputList(t, terraformOptions, "elastic_ips")
	ValidateCount(t, elastic_ips, expectedNumberOfResources)
	ValidateEachElementInArray(t, elastic_ips, "eip-*")
}

func ValidatePrivateRoutingTables(t *testing.T, terraformOptions *terraform.Options, expectedNumberOfResources int) {
	vpc_private_routing_table_ids := terraform.OutputList(t, terraformOptions, "vpc_private_routing_table_ids")
	ValidateCount(t, vpc_private_routing_table_ids, expectedNumberOfResources)
	ValidateEachElementInArray(t, vpc_private_routing_table_ids, "rtb-*")
}

func ValidateEachElementInArray(t *testing.T, array []string, regularExpression string) {

	require.Greater(t, len(array), 0)

	for _, element := range array {
		require.Regexp(t, regularExpression, element)
	}
}

func ValidateVPCSubnets(t *testing.T, terraformOptions *terraform.Options) {
	private_subnets := terraform.OutputList(t, terraformOptions, "private_subnets")
	public_subnets := terraform.OutputList(t, terraformOptions, "public_subnets")

	require.Len(t, private_subnets, terraformOptions.Vars["private_subnets"].(map[string]interface{})["number_of_subnets"].(int))
	require.Len(t, public_subnets, terraformOptions.Vars["public_subnets"].(map[string]interface{})["number_of_subnets"].(int))
	require.NotEqual(t, public_subnets, private_subnets)
	ValidateEachElementInArray(t, private_subnets, "subnet-*")
	ValidateEachElementInArray(t, public_subnets, "subnet-*")
}

func ValidateVPC(t *testing.T, terraformOptions *terraform.Options) {
	vpc_id := terraform.Output(t, terraformOptions, "vpc_id")
	require.Regexp(t, "vpc-*", vpc_id)
}

func ValidateVPCDefaultSecurityGroup(t *testing.T, terraformOptions *terraform.Options) {
	vpc_default_sg := terraform.Output(t, terraformOptions, "vpc_default_sg")
	require.Regexp(t, "sg-*", vpc_default_sg)
}

func ValidateVPCRoute53ZoneID(t *testing.T, terraformOptions *terraform.Options) {
	net0ps_zone_id := terraform.Output(t, terraformOptions, "net0ps_zone_id")
	private_zone_id := terraform.Output(t, terraformOptions, "private_zone_id")

	subdomain_zone_id := terraform.Output(t, terraformOptions, "subdomain_zone_id")
	public_subdomain_zone_id := terraform.Output(t, terraformOptions, "public_subdomain_zone_id")

	require.NotEqual(t, "", net0ps_zone_id)
	require.NotEqual(t, "", private_zone_id)
	require.Equal(t, net0ps_zone_id, private_zone_id)

	publicSubdomainRegex := regexp.MustCompile("^[A-Za-z0-9,-_.\\s]+$")

	if terraformOptions.Vars["subdomain"] == "" {
		publicSubdomainRegex = regexp.MustCompile("^$")
	}

	require.Regexp(t, publicSubdomainRegex, subdomain_zone_id)
	require.Regexp(t, publicSubdomainRegex, public_subdomain_zone_id)
	require.Equal(t, subdomain_zone_id, public_subdomain_zone_id)

	require.NotEqual(t, private_zone_id, public_subdomain_zone_id)
}

func ValidateVPCRoute53ZoneName(t *testing.T, terraformOptions *terraform.Options) {
	public_subdomain := terraform.Output(t, terraformOptions, "public_subdomain")
	private_subdomain := terraform.Output(t, terraformOptions, "private_subdomain")

	require.Equal(t, terraformOptions.Vars["subdomain"], public_subdomain)
	require.Equal(t, fmt.Sprintf("%s-net0ps.com", terraformOptions.Vars["vpc_name"]), private_subdomain)
}

func ValidateVPCRoutingTables(t *testing.T, terraformOptions *terraform.Options) {
	vpc_private_routing_table_ids := terraform.OutputList(t, terraformOptions, "vpc_private_routing_table_ids")
	vpc_public_routing_table_id := terraform.Output(t, terraformOptions, "vpc_public_routing_table_id")

	ValidateEachElementInArray(t, vpc_private_routing_table_ids, "rtb-*")
	require.Regexp(t, "rtb-*", vpc_public_routing_table_id)
}

func ValidateCount(t *testing.T, array []string, expectedCount int) {
	require.Len(t, array, expectedCount)
}

func ValidateDependId(t *testing.T, terraformOptions *terraform.Options) {
	depends_id := terraform.Output(t, terraformOptions, "depends_id")
	require.NotEqual(t, "", depends_id)
}

func ValidateExternalElasticIPs(t *testing.T, terraformOptions *terraform.Options) {
	external_elastic_ips := terraform.Output(t, terraformOptions, "external_elastic_ips")
	elastic_ips := terraform.Output(t, terraformOptions, "elastic_ips")
	require.Equal(t, external_elastic_ips, elastic_ips)
}
