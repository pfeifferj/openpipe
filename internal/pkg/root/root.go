// Package root provides the root command for the OpenPipe CLI
package root

import (
	"os"

	"github.com/spf13/cobra"
)

// RootCmd represents the base command when called without any subcommands
var RootCmd = &cobra.Command{
	Use:   "openpipe",
	Short: "Set up OpenShift Local in CI/CD pipelines",
	Long: `OpenPipe lets you run integration tests against an OpenShift local cluster in your GitLab CI pipelines.
It supports running OpenShift Local both directly and using crc-cloud on various cloud providers (AWS, GCP, OpenStack).
	
To get started with setting up your environment run:

openpipe init

For cloud-based deployment use:

openpipe crc-cloud [import|create|destroy]`,
}

func init() {
	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.openpipe.yaml)")
	RootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the RootCmd.
func Execute() {
	err := RootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}
