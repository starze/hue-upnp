#!/bin/bash

#examples:
#./hue-upnp-helper.sh 3 on true
#./hue-upnp-helper.sh 3 xy [0.4544,0.511]
#./hue-upnp-helper.sh 3 ct 396
#./hue-upnp-helper.sh 3 bri 254

#HUE LIGHT 1
if [ "$1" == "1" ]; then 

  #ON/OFF Directive
  if [ "$2" == "on" ]; then
    if [ "$3" == "true" ]; then
      echo 1 on true
      #INSERTING WAKEONLAN
      wakeonlan 11:22:33:44:DD:FF
    elif [ "$3" == "false" ]; then
      echo 1 on false
    fi

  #BRIGHTNESS
  elif [ "$2" == "bri" ]; then
    echo 1 bri $3

  #CT
  elif [ "$2" == "ct" ]; then
    echo 1 ct $3

  #XY
  elif [ "$2" == "xy" ]; then
    echo 1 xy $3
  fi

#HUE LIGHT 2
elif [ "$1" == "2" ]; then

  #ON/OFF Directive
  if [ "$2" == "on" ]; then
    if [ "$3" == "true" ]; then
      echo 2 on true
      #INSERTING WEMO-ON COMMAND
      ./wemo_control.sh 192.168.1.110 ON
    elif [ "$3" == "false" ]; then
      echo 2 on false
      #INSERTING WEMO-OFF COMMAND
      ./wemo_control.sh 192.168.1.110 OFF
    fi

  #BRIGHTNESS
  elif [ "$2" == "bri" ]; then
    echo 2 bri $3

  #CT
  elif [ "$2" == "ct" ]; then
    echo 2 ct $3

  #XY
  elif [ "$2" == "xy" ]; then
    echo 2 xy $3
  fi

#HUE LIGHT 2
elif [ "$1" == "3" ]; then

  #ON/OFF Directive
  if [ "$2" == "on" ]; then
    if [ "$3" == "true" ]; then
      echo 3 on true
    elif [ "$3" == "false" ]; then
      echo 3 on false
    fi

  #BRIGHTNESS
  elif [ "$2" == "bri" ]; then
    echo 3 bri $3

  #CT
  elif [ "$2" == "ct" ]; then
    echo 3 ct $3

  #XY
  elif [ "$2" == "xy" ]; then
    echo 3 xy $3
  fi
else
  echo "Error: Unknown Device '$1' command=$2 $3"
  exit 1
fi
