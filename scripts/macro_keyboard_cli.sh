#!/bin/bash

#Print formatted text in green color
print_green() {
  printf "\e[32m%s\e[0m\n" "$*"
}

# Print introduction message
print_green "This simple wizard will help you enable your second keyboard to be a macro-keyboard"

# Check if actkbd is installed and prompt user to continue
if [ $(command -v actkbd >/dev/null 2>&1; echo $?) -eq 0 ]; then
  print_green "actkbd is already installed."
  read -p "Do you wish to continue? (y/n) " user_response
  case "$user_response" in
    y|Y ) print_green "Continuing";;
    n|N ) print_green "You have chosen to exit." ; exit ;;
  esac
else
  # Prompt user to install actkbd
  read -p "actkbd is not installed. Install it now?(y/n) " install_response
  case "$install_response" in
    y|Y )
      print_green "Installing actkbd"
      cd /tmp && wget -q https://github.com/thkala/actkbd/archive/master.zip && unzip master.zip &&
      sudo make -C actkbd-master install >/dev/null;;
    * ) print_green "Setup was cancelled :)";;
  esac
  print_green "Installation of 'actkbd' completed successfully."
fi

# Print message to copy device ID
print_green "Copy the correct device ID for the second keyboard from the list."

# Save a list of input devices for the user to choose from
xinput list | xargs -L 20 > /tmp/devices.txt

# Open the file with the user's default editor, or vim if none exists
"${EDITOR:-vi}" /tmp/devices.txt

# Install xclip if necessary to paste clipboard contents into script
if ! command -v xclip >/dev/null 2>&1; then
  sudo apt install -y xclip >/dev/null
fi

# Disable the selected input device by ID
ID="$(xclip -selection c -o)"
xinput --disable "$ID"
print_green "Input device number $ID is disabled."

# Print message to find event number
print_green "Find the name of the correct device and copy the event number next to sysreq."

# Save a list of input devices and their properties to a file for the user to choose from
cat /proc/bus/input/devices > /tmp/inputlist.txt

# Open the file with the user's default editor, or vim if none exists
"${EDITOR:-vi}" /tmp/inputlist.txt

# Save the event number of the selected device
EVNUM="$(xclip -selection c -o)"

# Prompt user to press keys on the keyboard to be used
print_green "Press all keys on the keyboard that will be used. Remember the order of buttons pressed. Press 'CTRL + C' when done."

# Save the key mapping to a config file
sudo actkbd -s -d "/dev/input/event$EVNUM" > actkbd.config

# Run the configuration file as a daemon
sudo actkbd -f actkbd.config -d &