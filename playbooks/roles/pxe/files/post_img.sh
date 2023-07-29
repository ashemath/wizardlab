#!/bin/sh
sudo sh -c  "umount /dev/sda3"
sudo sh -c "echo ', +' | sfdisk -N 3 /dev/sda"
sudo sh -c "ntfsresize -v /dev/sda3"
sudo sh -c "ntfsfix -d /dev/sda3"
