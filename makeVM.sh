#!/bin/bash

# execpts that vfuse is installed at /usr/local/vfuse/vfuse

/usr/local/vfuse/vfuse \
--input /private/tmp/10.13.1_AutoDMG_17B48.hfs.dmg \
--output /private/tmp \
--name 10.13.1_AutoDMG_17B48 \ #name of the new vmwarevm image
--mem-size 6000 \ #sets memory for VMware Fusion to 6GB

