#!/bin/bash

timer=10 #seconds

# Directory for notification files
current_dir="$HOME/BatteryInfo"
notification_sound="scifi-reject-notification.wav"


notification_dir="$current_dir/NotificationFiles"
echo "$notification_dir"
mkdir -p "$notification_dir"

# File to track notification states
medium_notification_file="$notification_dir/.battery_medium_sent"
low_notification_file="$notification_dir/.battery_low_sent"
very_low_notification_file="$notification_dir/.battery_very_low_sent"

# Battery thresholds
medium_at=30
low_at=20
very_low_at=10


# Function to send notifications
send_notification() {
	urgency=$1
	message=$2
	paplay "$current_dir/$notification_sound"
	notify-send -u "$urgency" "Battery Status" "$message"
}




while true; do
	# Check battery state and send notifications
	#notify-send -t 1000 "monitoring"


	# Check battery status
	battery_info=$(acpi -b)
	#battery_info=$("$current_dir/mock_acpi.sh")




	status=$(echo "$battery_info" | grep -oE "Charging|Discharging|Low|Full")
	percentage=$(echo "$battery_info" | grep -o '[0-9]\+%' | tr -d '%')
	#notify-send -u low -t 1000 "1: $status"

	if [[ "$status" == "Discharging" ]]; then


		if [[ "$percentage" -le $very_low_at ]]; then
			if [[ ! -f $very_low_notification_file ]]; then
				send_notification "critical" "Battery is very low at ${percentage}%!"
				touch $very_low_notification_file
			fi
		elif [[ "$percentage" -le $low_at ]]; then
			if [[ ! -f $low_notification_file ]]; then
				send_notification "normal" "Battery is low at ${percentage}%!"
				touch $low_notification_file
			fi
		elif [[ "$percentage" -le $medium_at ]]; then
			if [[ ! -f $medium_notification_file ]]; then
				send_notification "low" "Battery is at ${percentage}%."
				touch $medium_notification_file
			fi
		fi




	else # Reset notification state if charging or logged in
   		if [[ "$status" == "Charging" ]] || [[ $1 == "login" ]] && \
  	 	[[ -e "$medium_notification_file" ]] || \
   		[[ -e "$low_notification_file" ]] || \
   		[[ -e "$very_low_notification_file" ]]; then
			notify-send -u normal -t 1000 "Charging, removing the notification files"
        	rm -f "$medium_notification_file"
        	rm -f "$low_notification_file"
    	    rm -f "$very_low_notification_file"
		fi
	fi



	sleep $timer

done
