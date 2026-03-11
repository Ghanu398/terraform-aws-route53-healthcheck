package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

# -----------------------------
# 1️⃣ Endpoint Health Check Test
# -----------------------------
func TestEndpointHealthCheck(t *testing.T) {
	t.Parallel()

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/endpoint",
		NoColor:      true,
	}

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	hcID := terraform.Output(t, tfOptions, "health_check_id")

	assert.NotEmpty(t, hcID)
}

# -----------------------------
# 2️⃣ CloudWatch Health Check Test
# -----------------------------
func TestCloudWatchHealthCheck(t *testing.T) {
	t.Parallel()

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/cloudwatch",
		NoColor:      true,
	}

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	hcID := terraform.Output(t, tfOptions, "health_check_id")

	assert.NotEmpty(t, hcID)
}

# -----------------------------
# 3️⃣ Calculated Health Check Test
# -----------------------------
func TestCalculatedHealthCheck(t *testing.T) {
	t.Parallel()

	tfOptions := &terraform.Options{
		TerraformDir: "../examples/calculated",
		NoColor:      true,
	}

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	hcID := terraform.Output(t, tfOptions, "health_check_id")

	assert.NotEmpty(t, hcID)
}