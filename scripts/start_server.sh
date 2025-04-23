#!/bin/bash
cd /home/ubuntu/python-app/app
nohup python3 app.py > app.log 2>&1 &
