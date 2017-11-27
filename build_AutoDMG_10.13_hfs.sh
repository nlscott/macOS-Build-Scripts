#!/bin/bash

# execptes that AutoDMG is installed in the Applications folder
# that you're running this on a 10.13 machine
# that you downloaded High Sierra from the App store and the installer is in the Applications folder
# creates the dmg in the /tmp folder


installername="Install macOS High Sierra.app"
autoDMG="/Applications/AutoDMG.app/Contents/MacOS/AutoDMG"
auto="_AutoDMG_"

#gets the build and OS version of the installer
mount_base=$(hdiutil mount "/Applications/$installername/Contents/SharedSupport/BaseSystem.dmg" -mountroot /tmp &>/dev/null)
buildVersion=$(defaults read /private/tmp/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist ProductBuildVersion)
osVersion=$(defaults read /private/tmp/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist ProductVersion)
unmount_base=$(hdiutil unmount /private/tmp/OS\ X\ Base\ System &>/dev/null)

$mount_base
$unmount_base

#sanity checks ... uncomment to see build and os version printed in the termianl output
#echo $buildVersion
#echo $osVersion

#update profiles
/Applications/AutoDMG.app/Contents/MacOS/AutoDMG update

#download available updates
/Applications/AutoDMG.app/Contents/MacOS/AutoDMG download $osVersion $buildVersion

#build DMG with autoDMG CLI
$autoDMG --root --logfile /tmp/autodmg.txt --log-level 7 build "/Applications/$installername" --output /private/tmp/"$osVersion$auto$buildVersion".hfs.dmg --filesystem hfs --updates

#change permissions
chmod 644 /private/tmp/"$osVersion$auto$buildVersion".hfs.dmg

