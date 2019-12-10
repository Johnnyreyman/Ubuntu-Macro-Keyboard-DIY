#!/bin/bash
#This script automates the process of creating a macro-keyboard from any second keyboard using actkbd.
#zenity --info --no-wrap --text "This simple wizard will help you enable your second keyboard to be a macro-keyboard."
echo -e "\e[032m This simple wizard will help you enable your second keyboard to be a macro-keyboard \e[0m"
#Test=$("command -v actkbd")
# Check that actkbd exists
if [ "$(command -v actkbd)" ]
then
echo -e "\e[032m actkbd is already installed. \e[0m"
read -p "Do you wish to continue? (y/n)?" user_response
case "$user_response" in
    y|Y ) echo -e "\e[032m Continuing \e[0m";;
    n|N ) echo -e "\e[032m You have chosen to exit \e[0m" ; exit ;;
esac

else
    read -p "actkbd is not installed. Install it now?(y|n)" install_response
    case "$install_response" in
        y|Y ) echo -e "\e[032m Installing actkbd \e[0m" ; cd /tmp ; wget https://github.com/thkala/actkbd/archive/master.zip ; unzip /tmp/master.zip ;sudo -i make install ;;
        n|N ) echo -e "\e[032m Setup was cancelled :) \e[0m" ;;
    esac
    #$(zenity --question --no-wrap --text "Would you like to install 'actkbd' to your computer?")
    #if [ $? -eq 0 ]
	#then
	#	cd /tmp
	#	wget https://github.com/thkala/actkbd/archive/master.zip
	#	unzip /tmp/master.zip
	#	cd /tmp/actkbd-master
     #   cp ../actkbd.config .
	#	sudo -i  make install
    #else
     #   zenity --info --no-wrap --text "Setup cancelled."
      #  exit
    #fi
echo -e  "\e[032m Installation of 'actkbd' completed sucessfully. \e[0m"

fi

echo -e "\e[032m Copy the correct device ID for the second keyboard from the list \e[0m"

#zenity --info --no-wrap --text "Copy the correct device ID for the second keyboard from the list."

cd /tmp

xinput list |  xargs -L 20 > Devices.txt
# Use user's default editor
# Use vim otherwise..It is assumed that nano will be the default
"${EDITOR:-vi}" Devices.txt
#xclip utility is required to paste clipboard contents into script.
# Only install xclip once
if [ ! -x "$(command -v xclip)" ]
then
sudo apt install -y xclip
fi
ID="$(xclip -selection c -o)"
xinput --disable $ID
echo -e "\e[032m Input device number "$ID" is disabled \e[0m"
echo -e "\e[032m Find the name of the correct decice and copy the event number next to sysreq"

#zenity --info --no-wrap --text "Input device number $ID is disabled."
#zenity --info --no-wrap --text "Find the name of the correct device and copy the event number next to sysreq."
cat /proc/bus/input/devices > Inputlist.txt
"${EDITOR:-vi}" Inputlist.txt
EVNUM="$(xclip -selection c -o)"

#zenity --info --no-wrap --text "Press all keys on keyboard that will be used. Remember order of buttons pressed. Press 'ctrl+c' when finished."
echo -e "\e[032m Press all keys on the keyboard that will be used. Remember the order of buttons pressed. Press "CTRTL + C" when done."
sudo actkbd -s -d /dev/input/event$EVNUM > actkbd.config
