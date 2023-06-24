/*
Copyright © 2023 Josephine Pfeiffer <jpfeiffe@redhat.com>

*/
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

// statusCmd represents the status command
var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Show details about your OpenPipe project",
	// Long: ``,
	Run: func(cmd *cobra.Command, args []string) {
	
		fileName := ".openpipe.yaml"
		exists := fileExists(fileName)
		if exists {
			fmt.Printf("'%s' config file exists in the current working directory.\n", fileName)
		} else {
			fmt.Printf("No '%s' config file found in the current working directory.\n\nRun 'openpipe init' to initialize a new openpipe project.\n", fileName)
		}	
	},
}


func fileExists(fileName string) bool {
	_, err := os.Stat(fileName)
	if os.IsNotExist(err) {
		return false
	}
	return true
}

func init() {
	rootCmd.AddCommand(statusCmd)
}
