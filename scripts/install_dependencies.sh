#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

cd /home/ubuntu/python-app

# Install pip3 if it's not already available
if ! command -v pip3 &>/dev/null; then
    echo "pip3 not found, installing..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
fi

# Install Python dependencies
pip3 install -r requirements.txt
