#!/bin/bash

# run this script as sudo
# execptes that munkipkg is installed /usr/local/bin/munkipkg 
# that you're running this on a 10.13 machine
# that you downloaded High Sierra from the App store and the installer is in the Applications folder
# creates the dmg in the /tmp folder

#mount the install.pp and get version and build numbers
installername="Install macOS High Sierra.app"
upgrade="_upgrade_"
mount_base=$(hdiutil mount "/Applications/$installername/Contents/SharedSupport/BaseSystem.dmg" -mountroot /tmp &>/dev/null)
buildVersion=$(defaults read /private/tmp/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist ProductBuildVersion)
osVersion=$(defaults read /private/tmp/OS\ X\ Base\ System/System/Library/CoreServices/SystemVersion.plist ProductVersion)
unmount_base=$(hdiutil unmount /private/tmp/OS\ X\ Base\ System &>/dev/null)

$mount_base
$unmount_base

#sanity checks when running in terminal
#echo $buildVersion
#echo $osVersion

#use munkipkg to build a High Sierra upgrade pkg
/usr/local/bin/munkipkg --create /tmp/"$osVersion$upgrade$buildVersion"
cp -R "/Applications/Install macOS High Sierra.app" /private/tmp/"$osVersion$upgrade$buildVersion"/payload
touch /private/tmp/"$osVersion$upgrade$buildVersion"/scripts/postinstall
echo "#!/bin/bash" >> "/private/tmp/"$osVersion$upgrade$buildVersion"/scripts/postinstall"
echo "sleep 2" >> "/private/tmp/"$osVersion$upgrade$buildVersion"/scripts/postinstall"
echo "/private/tmp/Install\ macOS\ High\ Sierra.app/Contents/Resources/startosinstall --agreetolicense --converttoapfs NO --nointeraction --volume / &>/dev/null" \
>> "/private/tmp/"$osVersion$upgrade$buildVersion"/scripts/postinstall"
defaults write /private/tmp/"$osVersion$upgrade$buildVersion"/build-info.plist install_location "/private/tmp"
defaults write /private/tmp/"$osVersion$upgrade$buildVersion"/build-info.plist version "$osVersion"
plutil -convert xml1 /private/tmp/"$osVersion$upgrade$buildVersion"/build-info.plist
chmod +x /private/tmp/"$osVersion$upgrade$buildVersion"/scripts/postinstall
chmod 644 /private/tmp/"$osVersion$upgrade$buildVersion"/build-info.plist
sudo /usr/local/bin/munkipkg /private/tmp/"$osVersion$upgrade$buildVersion"


#move the pkg and delete munki project folder
mv /private/tmp/"$osVersion$upgrade$buildVersion"/build/"$osVersion$upgrade$buildVersion".pkg /private/tmp/
rm -rf /private/tmp/"$osVersion$upgrade$buildVersion"
