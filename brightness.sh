#!/usr/bin/env bash

option=$1
monitor=$2

case $option in
  "-o")
    # brightness level
    brightness_level=$(xrandr --prop --verbose | grep -A10 $monitor | grep "Brightness" | awk '{print $2; exit}')
    brightness_level=$(bc <<<"scale=0;$brightness_level*100" | cut -f1 -d ".")
    echo "$brightness_level"% ;;

  "-s")
    # set brightness
    set_brightness_level=$3
    # detect the connected monitor and adjust its brightness
    screenname=$(xrandr | grep $monitor | cut -f1 -d " ")
    level=$(bc <<<"scale=0;$set_brightness_level*100" | cut -f1 -d ".")
    if [ $level -le 100 ] && [ $level -ge 0 ]; then
      xrandr --output $screenname --brightness $set_brightness_level
      echo "screen brightness is set to $set_brightness_level"
    else
      echo "Error: choose brightness level between 0 and 1"
    fi ;;

  "-i")
    # increase the screen brightness level by the specified amount
    increase_by=$3
    # detect the current brightness level of the connected screen
    brightness_level=$(xrandr --prop --verbose | grep -A10 $monitor | grep "Brightness" | awk '{print $2; exit}')
    # new_brightness_level
    new_brightness_level=`echo $brightness_level + $increase_by | bc -l`
    # detect the connected screen name
    screenname=$(xrandr | grep $monitor | cut -f1 -d " ")
    # adjust the brightness level to the new level
    level=$(bc <<<"scale=0;$new_brightness_level*100" | cut -f1 -d ".")
    if [ $level -le 100 ]; then
      xrandr --output $screenname --brightness $new_brightness_level
      echo "screen brightness is increased by $increase_by"
    else
      echo "screen brightness is already 100%"
    fi ;;

  "-d")
    # decrease the screen brightness level by the specified amount
    decrease_by=$3
    # detect the current brightness level of the connected screen
    brightness_level=$(xrandr --prop --verbose | grep -A10 $monitor | grep "Brightness" | awk '{print $2; exit}')
    # new_brightness_level
    new_brightness_level=`echo $brightness_level - $decrease_by | bc -l`
    # detect the connected screen name
    screenname=$(xrandr | grep $monitor | cut -f1 -d " ")
    # adjust the brightness level to the new level
    level=$(bc <<<"scale=0;$new_brightness_level*100" | cut -f1 -d ".")
    if [ $level -ge 0 ]; then
      xrandr --output $screenname --brightness $new_brightness_level
      echo "screen brightness is increased by $decrease_by"
    else
      echo "screen brightness is already 0%"
    fi ;;

esac
