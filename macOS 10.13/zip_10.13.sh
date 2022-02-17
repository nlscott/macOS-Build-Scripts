#!/bin/bash

installername="Install macOS High Sierra.app"
space="_"

#gets the build and OS version of the installer ... execepting to find it in the Applications folder
mount_base=$(hdiutil mount "/Applications/$installername/Contents/SharedSupport/BaseSystem.dmg" -mountroot /tmp &>/dev/null)
buildVersion=$(defaults read /private/tmp/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist ProductBuildVersion)
osVersion=$(defaults read /private/tmp/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist ProductVersion)
unmount_base=$(hdiutil unmount /private/tmp/OS\ X\ Base\ System &>/dev/null)

$mount_base
$unmount_base
echo $buildVersion
echo $osVersion

cd /Applications
tar -zcvf "Install macOS Sierra $osVersion$space$buildVersion.tar.gz" "Install macOS High Sierra.app"

#Move the archive and change permissions .. .. uncomment if you want to move to a different directory
#mv "Install macOS Sierra $osVersion$space$buildVersion.tar.gz" /private/var/jenkins/builds
#chmod 644 "/private/var/jenkins/builds/Install macOS Sierra $osVersion$space$buildVersion.tar.gz"