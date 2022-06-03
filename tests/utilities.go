package test

import (
	"net/url"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func getReplicationStatus(t *testing.T, bucket string, key string) (string, error) {
	sess, err := session.NewSession()
	if err != nil {
		t.Errorf("Session assumption failed: %v", err)
		return "", err
	}
	S3Svc := s3.New(sess)
	output, err := S3Svc.HeadObject(&s3.HeadObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		t.Errorf("HeadObject failed: %v", err)
		return "", err
	}

	replicationStatus := *output.ReplicationStatus

	return replicationStatus, nil
}

func keyExists(t *testing.T, bucket string, key string) (bool, error) {
	sess, err := session.NewSession()
	if err != nil {
		t.Errorf("Session assumption failed: %v", err)
		return false, err
	}
	S3Svc := s3.New(sess)
	_, err = S3Svc.HeadObject(&s3.HeadObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case "NotFound": // s3.ErrCodeNoSuchKey does not work, aws is missing this error code so we hardwire a string
				return false, nil
			default:
				return false, err
			}
		}
		return false, err
	}
	return true, nil
}

func overwriteObject(t *testing.T, bucket string, key string) error {
	sess, err := session.NewSession()
	if err != nil {
		t.Errorf("Session assumption failed: %v", err)
		return err
	}
	S3Svc := s3.New(sess)
	_, err = S3Svc.CopyObject(&s3.CopyObjectInput{
		Bucket:     aws.String(bucket),
		CopySource: aws.String(url.PathEscape(bucket + "/" + key)),
		Key:        aws.String(key),
	})
	if err != nil {
		t.Errorf("CopyObject failed: %v", err)
		return err
	}
	return nil
}
