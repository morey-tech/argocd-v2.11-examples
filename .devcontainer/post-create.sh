#!/bin/bash

echo "post-create start" >> ~/status

# this runs in background after UI is available

k3d cluster create --config .devcontainer/k3d.yaml --wait | tee -a ~/.status.log

echo "post-create complete" >> ~/status
