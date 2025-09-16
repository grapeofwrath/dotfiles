#!/usr/bin/env bash

charge=$(<"/sys/class/power_supply/BAT1/charge_now")
full=$(<"/sys/class/power_supply/BAT1/charge_full")
p=$((100 * charge / full))
stat=$(<"/sys/class/power_supply/BAT1/status")

if [[ p == 100 ]]; then
  icon="󰁹"
fi
if [[ p -lt 100 ]]; then
  icon="󰂂"
fi
if [[ p -lt 90 ]]; then
  icon="󰂁"
fi
if [[ p -lt 80 ]]; then
  icon="󰂀"
fi
if [[ p -lt 70 ]]; then
  icon="󰁿"
fi
if [[ p -lt 60 ]]; then
  icon="󰁾"
fi
if [[ p -lt 50 ]]; then
  icon="󰁽"
fi
if [[ p -lt 40 ]]; then
  icon="󰁼"
fi
if [[ p -lt 30 ]]; then
  icon="󰁻"
fi
if [[ p -lt 20 ]]; then
  icon="󰂎"
fi

if [[ $stat != "Discharging" ]]; then
  echo "󰉁 $p"
else
  echo "$icon $p"
fi
