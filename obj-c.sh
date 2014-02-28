#!/bin/bash
# obj-c.sh - installs software needed to develop Objective-C Appium tests.

echo -e "\nSetting up Objective-C environment..."

echo -e "$chck Checking for xctool...${txtrst}"
  if ! try xctool --version; then
    echo -e "$inst Installing xctool...${txtrst}"
    successfully brew install xctool
  fi

echo -e "${bldred}Download the binding from "`
       `"https://github.com/appium/selenium-objective-c.${txtrst}"
