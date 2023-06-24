/*
Copyright © 2023 Josephine Pfeiffer <jpfeiffe@redhat.com>

*/
package cmd

import (
	"os"

	"github.com/spf13/cobra"
)



// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "openpipe",
	Short: "Set up OpenShift Local in CI/CD pipelines",
	Long: `OpenPipe lets you run integration tests against an OpenShift local cluster in you GitLab CI pipelines
	
To get started with setting up your environment run:

openpipe init`,
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.openpipe.yaml)")

	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}


