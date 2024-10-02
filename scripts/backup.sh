#!/bin/bash

skriptPath=$(pwd)

nasIP='cardinal.local' # ip where to find the nas
nasExternalPath='/aincrad/simon/Backups/Home-Services' # where to put the backup inside the nas
nasMountPath='/media/nasMount' # mount point for the nas on this machine
credentialsFile='/media/Credentials/.nasMount'

backupFolder=$(date +'%d-%m-%Y') # just use the date as the folder name
backupRootDir='Pi-Home' # root folder for all backups of this instance
backupFileName='homeBackup' # the name for the .img file

# check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# make sure folder exist
sudo mkdir -p ${nasMountPath}

# mount nas storage
echo "Mounting Nas"
sudo mount -t cifs //${nasIP}/${nasExternalPath} ${nasMountPath} \
     -o rw,credentials=${credentialsFile},uid=1000,gid=1000,file_mode=0660,dir_mode=0770,vers=3.0,iocharset=utf8,x-systemd.automount
echo "Done.."

# create storage inside the mount
mkdir -p ${nasMountPath}/${backupRootDir}/${backupFolder}/logs
touch    ${nasMountPath}/${backupRootDir}/${backupFolder}/logs/backup.log
touch    ${nasMountPath}/${backupRootDir}/${backupFolder}/logs/shrink.log


# backup
echo "Making backup File"
sudo  imgclone -p -d ${nasMountPath}/${backupRootDir}/${backupFolder}/${backupFileName}.img &> ${nasMountPath}/${backupRootDir}/${backupFolder}/logs/backup.log
echo "Done.."

# shrink file system
echo "Shrinking Image"
sudo pishrink.sh ${nasMountPath}/${backupRootDir}/${backupFolder}/${backupFileName}.img \
     ${nasMountPath}/${backupRootDir}/${backupFolder}/${backupFileName}_shrink.img \
     &> ${nasMountPath}/${backupRootDir}/${backupFolder}/logs/shrink.log
echo "Done.."

# unmounting nas
sudo umount ${nasMountPath}

echo "All done"
