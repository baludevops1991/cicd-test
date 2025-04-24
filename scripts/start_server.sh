#!/bin/bash
cd /home/ubuntu/python-app/app
echo "Starting app at $(date)" >>/home/ubuntu/python-app/app.log
nohup python3 app.py >>/home/ubuntu/python-app/app.log 2>&1 &
