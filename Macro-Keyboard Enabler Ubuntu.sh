#!/bin/bash
#This script automates the process of creating a macro-keyboard from any second keyboard using actkbd.
zenity --info --text "This simple wizard will help you enable your second keyboard to be a macro-keyboard."
#Test=$("command -v actkbd")
# Check that actkbd exists
if [ "$(command -v actkbd)" ]
then
    zenity --info --text "actkbd is already installed. Click OK to continue."
else
    $(zenity --question --text "Would you like to install 'actkbd' to your computer?")
    if [ $? -eq 0 ]
	then
		cd /tmp
		wget https://github.com/thkala/actkbd/archive/master.zip
		unzip /tmp/master.zip
		cd /tmp/actkbd-master
		gksudo make install
    else
        zenity --info --text "Setup cancelled."
        exit
    fi
zenity --info --text "Installation of 'actkbd' completed sucessfully."

fi

zenity --info --text "Copy the correct device ID for the second keyboard from the list."
cd /tmp
xinput list |  xargs -L 20 > Devices.txt
leafpad Devices.txt
#xclip utility is required to paste clipboard contents into script.
sudo apt install -y xclip
ID="$(xclip -selection c -o)"
xinput --disable $ID
zenity --info --text "Input device number $ID is disabled."
zenity --info --text "Find the name of the correct device and copy the event number next to sysreq."
cat /proc/bus/input/devices > Inputlist.txt
leafpad Inputlist.txt
EVNUM="$(xclip -selection c -o)"
zenity --info --text "Press all keys on keyboard that will be used. Remember order of buttons pressed. Press 'ctrl+c' when finished."
sudo actkbd -s -d /dev/input/event$EVNUM > actkbd.config
