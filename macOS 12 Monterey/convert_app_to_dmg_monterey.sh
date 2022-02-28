#!/bin/sh

#variables -----------------------------------------------------------------------------------------
installername="Install macOS Monterey.app"
mount_name="Install macOS Monterey"
space="_"

#gets the build and OS version of the installer ----------------------------------------------------
mount_base=$(hdiutil mount "/Applications/$installername/Contents/SharedSupport/SharedSupport.dmg" -mountroot /tmp &>/dev/null)
buildVersion=$(/usr/libexec/PlistBuddy -c "print Assets:0:Build" "/private/tmp/Shared Support/com_apple_MobileAsset_MacSoftwareUpdate/com_apple_MobileAsset_MacSoftwareUpdate.xml")
osVersion=$(/usr/libexec/PlistBuddy -c "print Assets:0:OSVersion" "/private/tmp/Shared Support/com_apple_MobileAsset_MacSoftwareUpdate/com_apple_MobileAsset_MacSoftwareUpdate.xml")
unmount_base=$(hdiutil unmount "/private/tmp/Shared Support" &>/dev/null)

$mount_base
$unmount_base

#sanity checks, output to log
echo "Build: $buildVersion"
echo "OS: $osVersion"
echo "$adminpass" # credential saved in jenkins

#---------------------------------------------------------------------------------------------------

dmg_name="Install macOS Monterey $osVersion$space$buildVersion"


#Create a DMG Disk Image
hdiutil create -o /tmp/"$dmg_name" -size 15000m -volname "$mount_name" -layout SPUD -fs HFS+J

#Mount it to your macOS
hdiutil attach /tmp/"$dmg_name".dmg -noverify -mountpoint /Volumes/"$mount_name"

#Create macOS Installer
echo "$adminpass" | sudo -S "/Applications/$installername/Contents/Resources/createinstallmedia" --volume /Volumes/"$mount_name" --nointeraction


# #Unmount  Disk
hdiutil detach /Volumes/"$mount_name" -force


if test -e /Volumes/Shared\ Support; then
    hdiutil detach /Volumes/Shared\ Support 
fi

# #Rename and Move to Desktop
current_user=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
mv /private/tmp/*.dmg  /Users/$current_user/Desktop 

