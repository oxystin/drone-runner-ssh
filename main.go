// Copyright 2019 Drone.IO Inc. All rights reserved.
// Use of this source code is governed by the Polyform License
// that can be found in the LICENSE file.

package main

import (
	_ "github.com/joho/godotenv/autoload"
	"github.com/oxystin/drone-runner-ssh/command"
)

func main() {
	command.Command()
}
