# DRONE SSH RUNNER

The ssh runner executes pipelines on a remote server using the ssh protocol. This runner is intended for workloads that are not suitable for running inside containers. Posix and Windows workloads supported. Drone server 1.2.1 or higher is required.

## Installation

The below command creates a container and starts the ssh runner:

```yaml
version: "3.8"
services:
  runner-ssh:
    container_name: runner-ssh
    image: oxystin/drone-runner-ssh
    restart: unless-stopped
    ports:
      - 3002:3000
    environment:
      # Required parameter
      - DRONE_RPC_PROTO=http
      - DRONE_RPC_HOST=drone
      - DRONE_RPC_SECRET=c579832b2f935079d5ae6fdaed813b48
      # Optional parameter
      - DRONE_RUNNER_CAPACITY=2
      - DRONE_RUNNER_NAME=drone-runner-ssh
      - DRONE_UI_DISABLE=true 
      - DRONE_ENV_PLUGIN_SKIP_VERIFY=false
      - DRONE_RPC_SKIP_VERIFY=true
      - DRONE_RUNNER_ENVIRON=GIT_SSL_NO_VERIFY:true
      # Web UI
      - DRONE_UI_DISABLE=false
      - DRONE_UI_USERNAME=ssh
      - DRONE_UI_PASSWORD=ssh
```

Remember to replace the environment variables below with your Drone server details:

- **DRONE_RPC_HOST**<br/>
Provides the hostname (and optional port) of your Drone server. The runner connects to the server at the host address to receive pipelines for execution.

- **DRONE_RPC_PROTO**<br/>
Provides the protocol used to connect to your Drone server. The value must be either http or https.

- **DRONE_RPC_SECRET**<br/>
Provides the shared secret used to authenticate with your Drone server. This must match the secret defined in your Drone server configuration.

## Usage

Use the `server` section to configure the remote ssh server. The runner connects to this server and executes pipeline commands using the ssh protocol:

```yaml
kind: pipeline
type: ssh
name: default

server:
  host: 1.2.3.4
  user: admin
  sftp_dir: /home/admin # Optional
  current_dir: drone    # Optional
  password:
    from_secret: password

steps:
- name: greeting
  commands:
  - echo hello world
```
- Optional parameters:<br/>
`sftp_dir` - SFTP user root directory<br/>
`current_dir` - Working directory (by default **«/tmp»**, for windows **«C:\Windows\Temp»**)

## Other

Documentation:<br/>
https://docs.drone.io/runner/ssh/overview/

Technical Support:<br/>
https://discourse.drone.io

Issue Tracker and Roadmap:<br/>
https://trello.com/b/ttae5E5o/drone
