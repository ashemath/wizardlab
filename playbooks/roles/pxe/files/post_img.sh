#!/bin/sh

sudo sh -c "echo ', +' | sfdisk -N 3 /dev/vda"
sudo sh -c "ntfsresize -v /dev/vda3"
sudo sh -c "ntfsfix -d /dev/vda3"
