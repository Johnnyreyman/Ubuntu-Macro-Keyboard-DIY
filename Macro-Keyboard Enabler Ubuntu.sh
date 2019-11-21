#!/bin/bash
#This script automates the process of creating a macro-keyboard from any second keyboard using actkbd.
zenity --info --no-wrap --text "This simple wizard will help you enable your second keyboard to be a macro-keyboard."
#Test=$("command -v actkbd")
# Check that actkbd exists
if [ "$(command -v actkbd)" ]
then
    zenity --info --no-wrap --text "actkbd is already installed. Click OK to continue."
else
    $(zenity --question --no-wrap --text "Would you like to install 'actkbd' to your computer?")
    if [ $? -eq 0 ]
	then
		cd /tmp
		wget https://github.com/thkala/actkbd/archive/master.zip
		unzip /tmp/master.zip
		cd /tmp/actkbd-master
        cp ../actkbd.config .
		sudo -i  make install
    else
        zenity --info --no-wrap --text "Setup cancelled."
        exit
    fi
zenity --info --no-wrap --text "Installation of 'actkbd' completed sucessfully."

fi

zenity --info --no-wrap --text "Copy the correct device ID for the second keyboard from the list."
cd /tmp
xinput list |  xargs -L 20 > Devices.txt
# Check that leafpad exists
if [ "$(command -v leafpad)" ]
then
    leafpad Devices.txt
else
    sudo apt install -y leafpad
    leafpad Devices.txt
fi
#xclip utility is required to paste clipboard contents into script.
# Only install xclip once
if [ ! -x "$(command -v xclip)" ]
then
sudo apt install -y xclip
fi
ID="$(xclip -selection c -o)"
xinput --disable $ID
zenity --info --no-wrap --text "Input device number $ID is disabled."
zenity --info --no-wrap --text "Find the name of the correct device and copy the event number next to sysreq."
cat /proc/bus/input/devices > Inputlist.txt
leafpad Inputlist.txt
EVNUM="$(xclip -selection c -o)"
zenity --info --no-wrap --text "Press all keys on keyboard that will be used. Remember order of buttons pressed. Press 'ctrl+c' when finished."
sudo actkbd -s -d /dev/input/event$EVNUM > actkbd.config
