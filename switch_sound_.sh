#!/bin/sh

# This script toggles sound sink (output) between HDMI and built-in speaker

HDMI_STATUS=$(cat /sys/class/drm/card0/*HDMI*/status)
INPUTS=$(pacmd list-sink-inputs | grep index | awk '{print $2}')

if [ "$HDMI_STATUS" = "connected" ]
then
    ACTIVE_SINK_IDX=$(pacmd list-sinks | grep '* index' | awk '{print $3}')
    # If built-in speaker was the active sink, switch to HDMI
    if [ "$ACTIVE_SINK_IDX" = "4" ]
    then
	# Same profile, no need to switch
        # pactl set-card-profile 0 output:hdmi-stereo
        pactl set-default-sink 3
        for i in $INPUTS; do 
	    pacmd move-sink-input "$i" 3 &> /dev/null;
       	done
    # Otherwise switch to built-in speaker
    else
        # pactl set-card-profile 0 output:analog-stereo
        pactl set-default-sink 4
        for i in $INPUTS; do 
	    pacmd move-sink-input "$i" 4 &> /dev/null;
       	done
    fi
fi

