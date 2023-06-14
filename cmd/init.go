/*
Copyright © 2023 Josephine Pfeiffer <jpfeiffe@redhat.com>

*/
package cmd

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

// initCmd represents the init command
var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initialize an OpenPipe project in the current directory",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("init called")
	},
}

func cloneRepository(repoURL, destinationPath string) error {
	cmd := exec.Command("git", "clone", repoURL, destinationPath)
	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("failed to clone repository: %v", err)
	}
	return nil
}

func createConfigFile(repoPath string) error {
	fileName := ".openpipe.yaml"
	fileContent := `# OpenPipe config file
version: foo
`

	repoURL := "https://github.com/pfeifferj/openpipe.git"
	destinationPath := "" // TODO: use cli flag to set

	if destinationPath == "" {
		// Use the current working directory as the destination path
		currentDir, err := os.Getwd()
		if err != nil {
			return fmt.Println("Failed to get current working directory:", err)
		}
		destinationPath = currentDir
	}

	err := cloneRepository(repoURL, destinationPath)
	if err != nil {
		return fmt.Println(err)
	}

	err := os.Chdir(repoPath)
	if err != nil {
		return fmt.Errorf("failed to change directory: %v", err)
	}

	err := ioutil.WriteFile(fileName, []byte(fileContent), 0644)
	if err != nil {
		return fmt.Errorf("failed to create file: %v", err)
	}

	fmt.Printf("File '%s' created successfully.\n", fileName)
	return nil
}

func init() {
	rootCmd.AddCommand(initCmd)

	err := createConfigFile()
	if err != nil {
		fmt.Println(err)
	}
}
