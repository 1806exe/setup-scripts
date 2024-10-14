#!/bin/bash

# Check if root privileges are available
if [[ $EUID -ne 0 ]]; then
  echo "This script requires root privileges. Please run with sudo."
  exit 1
fi

# Download GitLab Runner with checksum verification for security
gitlab_runner_url="https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64"
checksum_url="${gitlab_runner_url}.sha256"

# Download the checksum file
curl -fsSL "$checksum_url" > /tmp/gitlab-runner.sha256

# Download GitLab Runner, ensuring checksum matches
curl -fsSL "$gitlab_runner_url" -o /tmp/gitlab-runner
if ! sha256sum -c /tmp/gitlab-runner.sha256; then
  echo "Checksum verification failed for GitLab Runner download. Aborting."
  exit 1
fi

# Install GitLab Runner with appropriate permissions
sudo install -o root -g root -m 0755 /tmp/gitlab-runner /usr/local/bin/gitlab-runner

# Create the gitlab-runner user with a secure home directory and non-login shell
sudo useradd --comment 'GitLab Runner' --create-home --shell /usr/sbin/nologin gitlab-runner

# Configure and register GitLab Runner (replace with your actual values)
sudo gitlab-runner register \
  --url your_gitlab_url \
  --registration-token your_registration_token \
  --executor shell \
  --description "My GitLab Runner" \
  --working-directory /home/gitlab-runner

# Start GitLab Runner
sudo gitlab-runner start

