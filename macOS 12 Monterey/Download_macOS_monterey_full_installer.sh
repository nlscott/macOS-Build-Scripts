#!/bin/sh


# script_name=$0
script_full_path=$(dirname "$0")
version_to_download=$(bash $script_full_path/_version_check.sh)


## Sanity Checks -----------------------------------------------------------------------------------
echo $version_to_download #sanity check to output into Jenkins logs for transparency and debugging
echo "softwareupdate --fetch-full-installer --full-installer-version "$version_to_download""


#download full installer for version listed in "version_check.sh"
softwareupdate --fetch-full-installer --full-installer-version "$version_to_download"

