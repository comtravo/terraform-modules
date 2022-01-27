#!/bin/bash


# https://github.com/aws/amazon-ecs-agent/blob/v1.55.3/agent/config/config.go
# Ssr = 4000 / Ci

# Br = Ssr * 1.5

# Where "Ssr" = SteadyStateRate
#       "Bsr" = BurstRate
#        "Ci" = Number of containers running in the Container Instance

# Thus, for ECS_TASK_METADATA_RPS_LIMIT you set as following in the "ecs.config":
# ECS_TASK_METADATA_RPS_LIMIT=SSr,Br

# For example, if among all container instance in the cluster you identified the highest number of containers running in the same instance is 10. In that case
# Ssr = 4000 / Ci(10)
# Ssr = 400

# Br = Ssr(400) * 1.5
# Br = 600

# Then:
# ECS_TASK_METADATA_RPS_LIMIT=400,600.

ctLog() {
  echo "Comtravo>>>> $1"
}


Update_docker_daemon() {
  ctLog "Updating docker daemon"

  cat <<'EOF' > /etc/sysconfig/docker
# The max number of open files for the daemon itself, and all
# running containers.  The default value of 1048576 mirrors the value
# used by the systemd service unit.
DAEMON_MAXFILES=1048576

# Additional startup options for the Docker daemon, for example:
# OPTIONS="--ip-forward=true --iptables=true"
# By default we limit the number of open files per container
OPTIONS="--default-ulimit nofile=65535:65535"

# How many seconds the sysvinit script waits for the pidfile to appear
# when starting the daemon.
DAEMON_PIDFILE_TIMEOUT=10
EOF

  ctLog "Restarting docker daemon"

  systemctl restart docker.service

  ctLog "Updating docker daemon done!"

}

block_ecs_services_access_to_ec2_metadata() {

  # To prevent containers in tasks that use the bridge network mode
  # from accessing the credential information supplied to the container instance profile
  # (while still allowing the permissions that are provided by the task role)
  # by running the following iptables command on your container instances.

  ctLog "Blocking ECS services access to EC2 metadata"

  yum install -y iptables-services
  iptables --insert FORWARD 1 --in-interface docker+ --destination 169.254.169.254/32 --jump DROP
  iptables-save | tee /etc/sysconfig/iptables && systemctl enable --now iptables

  ctLog "Blocking ECS services access to EC2 metadata done!"
}

update_ecs_config() {
  ctLog "Updating ECS agent configuration"

  {
    echo 'ECS_CLUSTER=${cluster_name}'
    echo 'ECS_INSTANCE_ATTRIBUTES=${attributes}'
    echo 'ECS_AVAILABLE_LOGGING_DRIVERS=${ecs_logging}'
    echo 'ECS_ENABLE_TASK_IAM_ROLE=true'
    echo 'ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true'
    echo 'ECS_ENABLE_CONTAINER_METADATA=true'
    echo 'ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=60m'
    echo 'ECS_IMAGE_CLEANUP_INTERVAL=60m'
    echo 'ECS_RESERVED_MEMORY=256'
    echo 'ECS_TASK_METADATA_RPS_LIMIT=400,600'
  } >> /etc/ecs/ecs.config

  ctLog "Updating ECS agent configuration done!"
}


main() {
  ctLog "main"

  update_ecs_config
  Update_docker_daemon
  block_ecs_services_access_to_ec2_metadata

  ctLog "Done!"
}


# entrypoint
main

# Custom userdata script code
${custom_userdata}
