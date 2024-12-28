#!/bin/zsh

# File to track the last state
STATE_FILE="/tmp/keyboard_state"

# Specific keyboard details
TARGET_VENDOR="12951"  # idVendor for Moonlander Mark I
TARGET_PRODUCT="6505"  # idProduct for Moonlander Mark I

# Function to check if the specific keyboard is connected
check_specific_keyboard() {
  # Filter ioreg output for the specific idVendor and idProduct
  ioreg -p IOUSB -l | grep -q "\"idVendor\" = $TARGET_VENDOR" && \
  ioreg -p IOUSB -l | grep -q "\"idProduct\" = $TARGET_PRODUCT"
}

# Initialize the state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
  echo "not_detected" > "$STATE_FILE"
fi

# Read the last known state
last_state=$(<"$STATE_FILE")

# Infinite loop to monitor the keyboard connection
while true; do
  current_state="not_detected"
  
  if check_specific_keyboard; then
    current_state="detected"
  fi

  if [[ "$last_state" != "$current_state" ]]; then
    if [[ "$current_state" == "detected" ]]; then
      echo "Moonlander Mark I plugged in"
      hidutil property --set '{"UserKeyMapping":[]}'
      # Add your command here for when the keyboard is plugged in
    else
      echo "Moonlander Mark I unplugged"
      hidutil property --set '{
        "UserKeyMapping": [
        {
          "HIDKeyboardModifierMappingSrc": 30064771114,
          "HIDKeyboardModifierMappingDst": 30064771113
        },
        {
          "HIDKeyboardModifierMappingSrc": 30064771129,
          "HIDKeyboardModifierMappingDst": 30064771114
        }
        ]
      }'

      # Add your command here for when the keyboard is unplugged
    fi
    echo "$current_state" > "$STATE_FILE"
  fi

  last_state="$current_state"
  sleep 0.01 # Adjust the polling interval as needed
done

