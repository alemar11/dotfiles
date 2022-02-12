#!/usr/bin/env bash

# Credits:
# https://github.com/bramus/freshinstall/blob/master/steps/1.macos-settings.sh
# https://github.com/keith/dotfiles/blob/master/osx/defaults.sh
# https://github.com/herrbischoff/awesome-macos-command-line
# https://github.com/ctreffs/xcode-defaults

### HouseKeeping

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

### General Preferences

# Show Battery Percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true
# Dark UI
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# Enable key repeats
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

### Terminal

# Setup the correct theme
defaults write com.apple.Terminal "Default Window Settings" -string "AM"
defaults write com.apple.Terminal "Startup Window Settings" -string "AM"

### Finder

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Show the ~/Library folder
chflags nohidden ~/Library
# Show the /Volumes folder
sudo chflags nohidden /Volumes

### Mouse and Trackpad
# Set mouse speed
defaults write -g com.apple.mouse.scaling 1.2
# Set trackpad speed
defaults write -g com.apple.trackpad.scaling 1.2

### Safari & WebKit

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

### Xcode

# Use 2 spaces for indentation
defaults write com.apple.dt.Xcode DVTTextIndentTabWidth -int 2
defaults write com.apple.dt.Xcode DVTTextIndentWidth -int 2
# Page guide
defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 100
# Show build duration
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES
# Trim trailing whitespace
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool true
# Trim whitespace only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true
# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true
# Set custom colorscheme
defaults write com.apple.dt.Xcode XCFontAndColorCurrentTheme -string AM.xccolortheme
defaults write com.apple.dt.Xcode XCFontAndColorCurrentDarkTheme -string AM.xccolortheme
# Enable concurrency when building - Requires RAM!
defaults write com.apple.dt.Xcode BuildSystemScheduleInherentlyParallelCommandsExclusively -bool YES
# Enable full screen mode for the simulator
defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES

### Dock

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36
# Enable magnification
defaults write com.apple.dock largesize -int 72
defaults write com.apple.dock magnification -bool true
# Put the dock on left side
defaults write com.apple.dock orientation -string "left"
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
# Hide recent applications in Dock
defaults write com.apple.dock show-recents -bool false

### TextEdit

# Start TextEdit with a blank document instead of the default file picker
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

### Mix

# Makes crash reports on macOS show up as a notification instead of a modal alert
defaults write com.apple.CrashReporter UseUNC 1
