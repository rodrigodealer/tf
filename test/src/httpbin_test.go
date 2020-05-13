package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestHttpBin(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../deployments/httpbin",
		Upgrade:      true,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	assert.Equal(t, "10.0.0.0/16", vpcCidr)

	elbDNS := terraform.Output(t, terraformOptions, "elb_dns")
	assert.Contains(t, elbDNS, ".us-east-1.elb.amazonaws.com")

	elbName := terraform.Output(t, terraformOptions, "elb_name")
	assert.Contains(t, elbName, "httpbin")
}
