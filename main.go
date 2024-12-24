/*
Copyright © 2023 Josephine Pfeiffer <jpfeiffe@redhat.com>
*/
package main

import (
	_ "github.com/pfeifferj/openpipe/internal/pkg/commands" // Initialize commands
	"github.com/pfeifferj/openpipe/internal/pkg/root"
)

func main() {
	root.Execute()
}
