#!/bin/sh
#
# WeMo Control Script
#
# rich@netmagi.com
# from: http://wemo.forumatic.com/viewtopic.php?f=2&t=5
# Changed logic to find port
#
# Usage: ./wemo_control.sh IP_ADDRESS ON/OFF/GETSTATE/GETSIGNALSTRENGTH/GETFRIENDLYNAME
#
#
IP=$1
COMMAND=$2

if [ "$2" = "" ]
   then
      echo "Usage: ./wemo_control.sh IP_ADDRESS ON|OFF|GETSTATE [PORT]"
else

    PORT=0
    PREVIOUSPORT=""

    #check for a previous working port
    if [ -e "${1}.port" ]; then
      PREVIOUSPORT=`cat "${1}.port"`;
    fi

    #The default port loves to change after power outages
    #added in the ability to pass in the port to use as the first check ($3)
    #Also added in the ability to reuse the last successful port
    for PTEST in $3 $PREVIOUSPORT 49153 49154 49152 49155
    do
            PORTTEST=$(curl -s -m 3 $IP:$PTEST | grep "404")

            if [ "$PORTTEST" != "" ]
               then
               PORT=$PTEST
               #save port if current dir is writable
               echo -n "$PTEST" > "${1}.port" 2>/dev/null
               break
            fi
    done

    if [ $PORT = 0 ]
             then
       echo "Cannot find a port"
       exit
    fi


    if [ "$1" = "" ]
       then
          echo "Usage: ./wemo_control.sh IP_ADDRESS ON|OFF"
    else
       echo "Port = "$PORT


       if [ "$2" = "ON" ]

          then

             curl -0 -A '' -X POST -H 'Accept: ' -H 'Content-type: text/xml; charset="utf-8"' -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" --data '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>1</BinaryState></u:SetBinaryState></s:Body></s:Envelope>' -s http://$IP:$PORT/upnp/control/basicevent1 |
    grep "<BinaryState"  | cut -d">" -f2 | cut -d "<" -f1

       elif [ "$2" = "OFF" ]

          then

             curl -0 -A '' -X POST -H 'Accept: ' -H 'Content-type: text/xml; charset="utf-8"' -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" --data '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>0</BinaryState></u:SetBinaryState></s:Body></s:Envelope>' -s http://$IP:$PORT/upnp/control/basicevent1 |
    grep "<BinaryState"  | cut -d">" -f2 | cut -d "<" -f1

   elif [ "$2" = "GETSTATE" ]

      then

         curl -0 -A '' -X POST -H 'Accept: ' -H 'Content-type: text/xml; charset="utf-8"' -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#GetBinaryState\"" --data '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:GetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>1</BinaryState></u:GetBinaryState></s:Body></s:Envelope>' -s http://$IP:$PORT/upnp/control/basicevent1 |
grep "<BinaryState"  | cut -d">" -f2 | cut -d "<" -f1 | sed 's/0/OFF/g' | sed 's/1/ON/g'


       else

          echo "COMMAND NOT RECOGNIZED"
          echo ""
          echo "Usage: ./wemo_control.sh IP_ADDRESS ON|OFF|GETSTATE [PORT]"
          echo ""

       fi

    fi
fi
