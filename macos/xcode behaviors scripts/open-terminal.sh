#!/bin/bash

# Project Name:  $XcodeProject
# Project Dir:   $XcodeProjectPath
# Workspace Dir: $XcodeWorkspacePath

# shellcheck disable=SC2154 # Provided by Xcode Behaviors runtime.
open -a Terminal "$(dirname "$XcodeProjectPath")"
