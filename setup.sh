#!/bin/bash

scriptDir=$(pwd)

function clean() {
    rm -r logs
    mkdir -p logs
}

function seperator() {
    msg="============================================================="

    echo $msg 
    echo $msg >> logs/setup.log
}

function spacer() {
    seperator;
    echo ""
    echo "" >> logs/setup.log
    seperator;
}

function logger() {
    current_time=$(date "+%H:%M:%S")
    msg="== $current_time - $1"

    echo $msg 
    echo $msg >> logs/setup.log
}

clean;

seperator;
logger "Setup started"

spacer;
logger "Updating packages - this might take a while"
logger "sudo apt update"
# sudo apt update >> logs/apt.log;

logger "sudo apt upgrade"
# sudo apt upgrade -y >> logs/apt.log;

spacer;
logger "Installing Docker"
# curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh >> logs/docker-install.log
# rm get-docker.sh

logger "Installing Docker-Compose"
# sudo apt install docker-compose -y >> logs/docker-install.log

logger "Enabling docker in systemctl"
# sudo systemctl enable docker >> logs/docker-install.log

spacer;
logger "Done - now downloading useful scripts"

logger "Getting backup script"
mkdir -p $scriptDir/scripts/backup
# todo install imgclone and pishrink
# todo get script

logger "Getting fan-control script"
mkdir -p $scriptDir/scripts/fan
# todo get it

logger "Setting up service for starting the fan control"
# actually do it

