#!/bin/bash

# Create the Soundboard virtual device (if it doesn't exist)
if ! pactl list sinks | grep -q "Soundboard"; then
  echo "Creating Soundboard..."
  pactl load-module module-null-sink sink_name="Soundboard" sink_properties=device.description="Soundboard"
fi

# Wait for EasyEffects to be running
echo "Waiting for Easy Effects..."
for i in {1..30}; do
  # Check if easyeffects is broadcasting its input ports
  if pw-link -i | grep -q "easyeffects_source.*FL"; then
    break
  fi
  sleep 1
done

# Disconnect first (prevents duplicate wires if the script is run twice)
pw-link -d Soundboard:monitor_FL easyeffects_source:input_FL 2>/dev/null
pw-link -d Soundboard:monitor_FR easyeffects_source:input_FR 2>/dev/null
pw-link -d Soundboard:monitor_FL easyeffects_source:playback_FL 2>/dev/null
pw-link -d Soundboard:monitor_FR easyeffects_source:playback_FR 2>/dev/null

echo "Wiring Soundboard to Easy Effects Source..."
pw-link Soundboard:monitor_FL easyeffects_source:input_FL 2>/dev/null || pw-link Soundboard:monitor_FL easyeffects_source:playback_FL
pw-link Soundboard:monitor_FR easyeffects_source:input_FR 2>/dev/null || pw-link Soundboard:monitor_FR easyeffects_source:playback_FR

# ROUTING TO HEADPHONES (Dynamic via pw-loopback)
# Kill any existing monitor loopback first to avoid doubling the volume
pkill -f "pw-loopback.*Soundboard-Monitor" 2>/dev/null

echo "Creating dynamic monitor (follows the default output)..."
# By NOT specifying a playback target, PipeWire will always send this to your current default sink.
# Give it a 'node.name' so we can easily find and kill it later.
pw-loopback \
  -C Soundboard \
  --capture-props='{ stream.capture.sink=true }' \
  --playback-props='{ node.name="Soundboard-Monitor" node.description="Soundboard-Monitor" }' >/dev/null 2>&1 &

echo "Done! Soundboard is live."
