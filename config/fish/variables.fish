# Path
set -gx PATH $PATH /usr/local/sbin

# load variables
set -gx VISUAL vim
set -gx EDITOR vim

# Arduino-mk
set -gx ARDUINO_DIR /Applications/Arduino.app/Contents/Java
set -gx ARDMK_DIR /usr/local/Arduino-Makefile
set -gx AVR_TOOLS_DIR /usr/local

# Python
set -gx PYTHONSTARTUP ~/.pystartup
