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
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("status called")
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

	fileName := ".openpipe.yaml"
	exists := fileExists(fileName)
	if exists {
		fmt.Printf("File '%s' exists in the current working directory.\n", fileName)
	} else {
		fmt.Printf("File '%s' does not exist in the current working directory.\n", fileName)
	}
}
