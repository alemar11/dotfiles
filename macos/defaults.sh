#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

SAFARI_ACCESS_HINT_SHOWN=false

safari_defaults_write() {
  local key="$1"
  shift

  local err
  if err="$(defaults write com.apple.Safari "$key" "$@" 2>&1)"; then
    return 0
  fi

  if [[ "$err" == *"Could not write domain"*com.apple.Safari* ]]; then
    if [[ "$SAFARI_ACCESS_HINT_SHOWN" == "false" ]]; then
      echo "⚠️ Safari preferences are not writable from this shell."
      echo "   Suggestions:"
      echo "   1) Run this script as your regular user (not sudo/root)."
      echo "   2) Grant Full Disk Access to your terminal app."
      echo "   3) Open Safari once, then quit it and rerun."
      SAFARI_ACCESS_HINT_SHOWN=true
    fi
    echo "⚠️ Skipping Safari key '$key'."
    return 0
  fi

  echo "error: failed to write Safari key '$key'" >&2
  echo "$err" >&2
  return 1
}

# Credits:
# https://github.com/bramus/freshinstall/blob/master/steps/1.macos-settings.sh
# https://github.com/keith/dotfiles/blob/master/osx/defaults.sh
# https://github.com/herrbischoff/awesome-macos-command-line
# https://github.com/ctreffs/xcode-defaults
# https://macos-defaults.com/xcode/showbuildoperationduration.html

# - Your terminal needs full disk access
# - .plist files are usually located here ~/Library/Preferences but you can read/write app specific settings using "default read -app APPNAME"

### HouseKeeping

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Settings" to quit' 2>/dev/null \
  || osascript -e 'tell application "System Preferences" to quit' 2>/dev/null \
  || true

### General Preferences

# Show Battery Percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true
# Dark UI
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# Enable key repeats
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

### Finder

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
# Don't show hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Show the ~/Library folder
chflags nohidden ~/Library
# Show the /Volumes folder
if [[ $EUID -eq 0 ]]; then
  chflags nohidden /Volumes
elif sudo -n true 2>/dev/null; then
  sudo chflags nohidden /Volumes
else
  echo "⚠️ Skipping /Volumes visibility change (sudo requires password)."
fi

### Mouse and Trackpad
# Set mouse speed
defaults write -g com.apple.mouse.scaling 1.2
# Set trackpad speed
defaults write -g com.apple.trackpad.scaling 1.2
# Disable natural scroll
defaults write -g com.apple.swipescrolldirection -bool false
# Enable right click, use "OneButton" to revert it
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

### Safari & WebKit

# Show the full URL in the address bar (note: this still hides the scheme)
safari_defaults_write ShowFullURLInSmartSearchField -bool true
# Set Safari’s home page to `about:blank` for faster loading
safari_defaults_write HomePage -string "about:blank"
# Enable the Develop menu and the Web Inspector in Safari
safari_defaults_write IncludeDevelopMenu -bool true
safari_defaults_write WebKitDeveloperExtrasEnabledPreferenceKey -bool true
safari_defaults_write com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

### Xcode

# Use 2 spaces for indentation
defaults write com.apple.dt.Xcode DVTTextIndentTabWidth -int 2
defaults write com.apple.dt.Xcode DVTTextIndentWidth -int 2
# Page guide
defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 120
# Show build duration
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true
# Trim trailing whitespace
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool true
# Trim whitespace only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true
# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true
# Show all scope guides
defaults write com.apple.dt.Xcode DVTTextScopeGuidesDisplayStyle -string "All"
# Set custom colorscheme
defaults write com.apple.dt.Xcode XCFontAndColorCurrentTheme -string "Default (Light).xccolortheme"
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string "Default (Dark).xccolortheme"
# Disable default devices creation
defaults write com.apple.CoreSimulator EnableDefaultSetCreation -bool false

### Dock

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36
# Enable magnification
defaults write com.apple.dock largesize -int 72
defaults write com.apple.dock magnification -bool true
# Put the dock on bottom
defaults write com.apple.dock orientation -string "bottom"
# Enable autohide
defaults write com.apple.dock autohide -bool false
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
# Hide recent applications in Dock
defaults write com.apple.dock show-recents -bool false

### Windows

# Remove margins from tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

### Mission Control

# Group windows by application
defaults write com.apple.dock "expose-group-apps" -bool true

# Stage Manager
# https://gist.github.com/GreyAsteroid/c73028e447d716b02063b0870c12c6be

# Enable stage manager
defaults write com.apple.WindowManager GloballyEnabled -bool true
# "Hide recent Apps"
defaults write com.apple.WindowManager AutoHide -bool false
# Click desktop to reveal it
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool true
# Keep desktop icons visible when revealing the desktop
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool false

### TextEdit

# Start TextEdit with a blank document instead of the default file picker
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

### Mix

# Makes crash reports on macOS show up as a notification instead of a modal alert
defaults write com.apple.CrashReporter UseUNC -int 1
