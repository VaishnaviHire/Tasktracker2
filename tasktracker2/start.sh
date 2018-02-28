#!/bin/bash

export PORT=5103

cd ~/www/tasktracker2
./bin/tasktracker stop || true
./bin/tasktracker start

