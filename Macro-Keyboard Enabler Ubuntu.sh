#!/bin/bash
#This script automates the process of creating a macro-keyboard from any second keyboard using actkbd.
zenity --info --text "This simple wizard will help you enable your second keyboard to be a macro-keyboard."
Test=$(actkbd --help)
if [ $Test -eq "Command 'actkbd' not found" ]
then
	Install=$(zenity --question --text "Would you like to install 'actkbd' to your computer?")
	if [ $Install -eq 0 ]
	then
		cd /tmp
		wget https://github.com/thkala/actkbd/archive/master.zip
		unzip /tmp/master.zip
		cd /tmp/actkbd-master
		gksudo make install
	fi
	if [ $Install -eq 1 ]
	then
		zenity --info --text "Setup cancelled."
		exit
	fi
zenity --info --text "Install of 'actkbd' completed sucessfully."
fi

if [ $Test -d "Command 'actkbd' not found" ]
then
	zenity --info --text "Command 'actkbd' is installed. Click OK to continue."
fi

zenity --info --text "Copy correct device ID for second keyboard from list."
cd /tmp
xinput list |& xargs -L 20 > Devices.txt
leafpad Devices.txt
#xclip utility is required to paste clipboard contents into script.
sudo apt install -y xclip
ID=$(xclip -selection c -o)
xinput --disable $ID
zenity --info --text "Input device number $ID is disabled."
zenity --info --text "Find the name of the correct device and copy event number next to sysreq."
cat /proc/bus/input/devices > Inputlist.txt
leafpad Inputlist.txt
EVNUM=$(xclip -selection c -o)
zenity --info --text "Press all keys on keyboard that will be used. Remember order of buttons pressed. Press 'ctrl+c' when finished."
sudo actkbd -s -d /dev/input/event$EVNUM > actkbd.config