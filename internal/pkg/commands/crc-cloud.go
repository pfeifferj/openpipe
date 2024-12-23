// Package commands implements the OpenPipe CLI commands
package commands

import (
	"github.com/pfeifferj/openpipe/internal/pkg/root"
	"github.com/spf13/cobra"
)

var (
	backedURL          string
	projectName        string
	outputPath         string
	tags               string
	provider           string
	keyFilepath        string
	pullsecretFilepath string
	bundleURL          string
	bundleShasumURL    string
)

// crcCloudCmd represents the crc-cloud command
var crcCloudCmd = &cobra.Command{
	Use:   "crc-cloud",
	Short: "Run OpenShift Local using crc-cloud",
	Long: `Run OpenShift Local using crc-cloud on various cloud providers (AWS, GCP, OpenStack).
Supports import, create, and destroy operations.`,
}

// importCmd represents the import command
var importCmd = &cobra.Command{
	Use:   "import",
	Short: "Import crc cloud image",
	Long: `Import operation uses crc official bundles, transforms them and imports as an AMI on the user account.
It is required to run import operation on each region where you want to spin the cluster.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		// TODO: Implement import logic
		return nil
	},
}

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create",
	Short: "Create crc cloud instance",
	Long: `Create operation is responsible for creating all required resources on the cloud provider 
to spin the OpenShift Single Node Cluster.`,
}

// createAWSCmd represents the AWS create subcommand
var createAWSCmd = &cobra.Command{
	Use:   "aws",
	Short: "Create crc cloud instance on AWS",
	RunE: func(cmd *cobra.Command, args []string) error {
		// TODO: Implement AWS create logic
		return nil
	},
}

// createGCPCmd represents the GCP create subcommand
var createGCPCmd = &cobra.Command{
	Use:   "gcp",
	Short: "Create crc cloud instance on GCP",
	RunE: func(cmd *cobra.Command, args []string) error {
		// TODO: Implement GCP create logic
		return nil
	},
}

// createOpenStackCmd represents the OpenStack create subcommand
var createOpenStackCmd = &cobra.Command{
	Use:   "openstack",
	Short: "Create crc cloud instance on OpenStack",
	RunE: func(cmd *cobra.Command, args []string) error {
		// TODO: Implement OpenStack create logic
		return nil
	},
}

// destroyCmd represents the destroy command
var destroyCmd = &cobra.Command{
	Use:   "destroy",
	Short: "Destroy crc cloud instance",
	Long: `Destroy operation will remove any resource created at the cloud provider.
It uses the files holding the state of the infrastructure which has been stored at the location 
defined by parameter backed-url on create operation.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		// TODO: Implement destroy logic
		return nil
	},
}

func initImportFlags() {
	importCmd.Flags().StringVar(&backedURL, "backed-url", "", "backed for stack state. Can be a local path with format file:///path/subpath or s3 s3://existing-bucket")
	importCmd.Flags().StringVar(&bundleURL, "bundle-url", "", "custom url to download the bundle artifact")
	importCmd.Flags().StringVar(&bundleShasumURL, "bundle-shasumfile-url", "", "custom url to download the shasum file to verify the bundle artifact")
	importCmd.Flags().StringVar(&outputPath, "output", "", "path to export assets")
	importCmd.Flags().StringVar(&tags, "tags", "", "tags to add on each resource (--tags name1=value1,name2=value2)")
	importCmd.Flags().StringVar(&projectName, "project-name", "", "project name to identify the instance of the stack")
	importCmd.Flags().StringVar(&provider, "provider", "", "target cloud provider")

	// Required flags
	for _, flag := range []string{"backed-url", "output", "project-name", "provider"} {
		if err := importCmd.MarkFlagRequired(flag); err != nil {
			panic(err)
		}
	}
}

func initCreateFlags() {
	// Global create flags
	createCmd.PersistentFlags().StringVar(&backedURL, "backed-url", "", "backed for stack state. Can be a local path with format file:///path/subpath or s3 s3://existing-bucket")
	createCmd.PersistentFlags().StringVar(&keyFilepath, "key-filepath", "", "path to init key obtained when importing the image")
	createCmd.PersistentFlags().StringVar(&outputPath, "output", "", "path to export assets")
	createCmd.PersistentFlags().StringVar(&projectName, "project-name", "", "project name to identify the instance of the stack")
	createCmd.PersistentFlags().StringVar(&pullsecretFilepath, "pullsecret-filepath", "", "path for pullsecret file")
	createCmd.PersistentFlags().StringVar(&tags, "tags", "", "tags to add on each resource (--tags name1=value1,name2=value2)")

	// Required flags
	for _, flag := range []string{"backed-url", "key-filepath", "output", "project-name", "pullsecret-filepath"} {
		if err := createCmd.MarkPersistentFlagRequired(flag); err != nil {
			panic(err)
		}
	}
}

func initProviderFlags() {
	// AWS specific flags
	createAWSCmd.Flags().String("aws-ami-id", "", "AMI identifier")
	createAWSCmd.Flags().String("aws-disk-size", "100", "Disk size in GB for the machine running the cluster")
	createAWSCmd.Flags().String("aws-instance-type", "c6a.2xlarge", "Instance type for the machine running the cluster")
	if err := createAWSCmd.MarkFlagRequired("aws-ami-id"); err != nil {
		panic(err)
	}

	// GCP specific flags
	createGCPCmd.Flags().String("gcp-disk-size", "100", "Disk size in GB for the machine running the cluster")
	createGCPCmd.Flags().String("gcp-image-id", "", "GCP image identifier")
	createGCPCmd.Flags().String("gcp-instance-type", "n1-standard-8", "Instance type for the machine running the cluster")
	if err := createGCPCmd.MarkFlagRequired("gcp-image-id"); err != nil {
		panic(err)
	}

	// OpenStack specific flags
	createOpenStackCmd.Flags().String("disk-size", "100", "Disk size in GB for the machine running the cluster")
	createOpenStackCmd.Flags().String("flavor", "m1.xlarge", "OpenStack flavor type for the machine running the cluster")
	createOpenStackCmd.Flags().String("image", "", "OpenStack image identifier")
	createOpenStackCmd.Flags().String("network", "", "OpenStack network name for the machine running the cluster")
	for _, flag := range []string{"image", "network"} {
		if err := createOpenStackCmd.MarkFlagRequired(flag); err != nil {
			panic(err)
		}
	}
}

func initDestroyFlags() {
	destroyCmd.Flags().StringVar(&backedURL, "backed-url", "", "backed for stack state. Can be a local path with format file:///path/subpath or s3 s3://existing-bucket")
	destroyCmd.Flags().StringVar(&projectName, "project-name", "", "project name to identify the instance of the stack")
	destroyCmd.Flags().StringVar(&provider, "provider", "", "target cloud provider")

	// Required flags
	for _, flag := range []string{"backed-url", "project-name", "provider"} {
		if err := destroyCmd.MarkFlagRequired(flag); err != nil {
			panic(err)
		}
	}
}

func init() {
	root.RootCmd.AddCommand(crcCloudCmd)
	crcCloudCmd.AddCommand(importCmd, createCmd, destroyCmd)
	createCmd.AddCommand(createAWSCmd, createGCPCmd, createOpenStackCmd)

	initImportFlags()
	initCreateFlags()
	initProviderFlags()
	initDestroyFlags()
}
