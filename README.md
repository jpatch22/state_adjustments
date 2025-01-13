# Running background service on Mac based on detection of specific keyboard and remapping keys

cp com.detect.keyboard.plist ~/Library/LaunchAgents/.
cp cust_keys.zsh ~/Library/LaunchAgents/.

from launch agents directory:
- Start: launchctl load ~/Library/LaunchAgents/com.detect.keyboard.plist
- Stop: launchctl unload ~/Library/LaunchAgents/com.detect.keyboard.plist
- Check: launchctl list | grep com.detect.keyboard
    - Says nothing if not running something if running.


