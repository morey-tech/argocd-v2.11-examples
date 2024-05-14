#!/bin/bash
set -e  # Exit on non-zero exit code from commands

echo "$(date): Running post-create.sh" >> ~/.status.log

# this runs in background after UI is available

# https://github.com/k3d-io/k3d/issues/1169#issuecomment-1274554683
sudo prlimit --pid $$ --nofile=1048576:1048576
sudo sysctl fs.inotify.max_user_instances=1280
sudo sysctl fs.inotify.max_user_watches=655360

k3d cluster create --config .devcontainer/k3d.yaml --wait --verbose 2>&1 | tee -a ~/.status.log

echo "$(date): Finished post-create.sh" >> ~/.status.log
