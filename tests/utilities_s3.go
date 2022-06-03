package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testS3(t *testing.T, variant string) {
	t.Parallel()

	terraformDir := fmt.Sprintf("../examples/%s", variant)

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		LockTimeout:  "5m",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.Init(t, terraformOptions)

	// The inventory variant requires a separate targetted
	// apply step to create the inventory bucket.
	if variant == "inventory" {
		targetInventoryBucketOptions := &terraform.Options{
			TerraformDir: terraformDir,
			LockTimeout:  "5m",
			Targets:      []string{"module.s3_inventory"},
		}
		terraform.Apply(t, targetInventoryBucketOptions)
	}

	terraform.Apply(t, terraformOptions)

	if variant == "replication" {
		sourceBucketName := terraform.Output(t, terraformOptions, "source_bucket_name")
		sourceBucketARN := terraform.Output(t, terraformOptions, "source_bucket_arn")
		targetBucketName := terraform.Output(t, terraformOptions, "target_bucket_name")
		targetBucketARN := terraform.Output(t, terraformOptions, "target_bucket_arn")

		partialExpectedSourceName := fmt.Sprintf("example-tf-s3-%s-source", variant)
		partialExpectedTargetName := fmt.Sprintf("example-tf-s3-%s-target", variant)

		assert.Contains(t, sourceBucketName, partialExpectedSourceName)
		assert.Contains(t, sourceBucketARN, partialExpectedSourceName)
		assert.Contains(t, targetBucketName, partialExpectedTargetName)
		assert.Contains(t, targetBucketARN, partialExpectedTargetName)

		// If we upload the object before the replication configuration can take
		// hold, we'll need to re-upload the object to the source bucket to force replication.
		err := overwriteObject(t, sourceBucketName, "index.html")

		if err != nil {
			t.Fatal(err)
		}

		status, err := getReplicationStatus(t, sourceBucketName, "index.html")

		t.Log("Replication status:", status)

		if err != nil {
			t.Fatal(err)
		}

		for status == "PENDING" {
			status, err = getReplicationStatus(t, sourceBucketName, "index.html")
			if err != nil {
				t.Fatal(err)
			}
			if status == "FAILED" {
				t.Fatal("Replication failed")
			}
		}

		exists, err := keyExists(t, targetBucketName, "index.html")

		if err != nil {
			t.Fatal(err)
		}

		if !exists {
			t.Fatal("Object not replicated to target bucket")
		}

	} else {
		name := terraform.Output(t, terraformOptions, "name")
		arn := terraform.Output(t, terraformOptions, "arn")

		partialExpectedName := fmt.Sprintf("example-tf-s3-%s", variant)

		assert.Contains(t, name, partialExpectedName)
		assert.Contains(t, arn, partialExpectedName)
	}

}
