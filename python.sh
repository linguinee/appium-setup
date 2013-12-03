#!/bin/bash
# python.sh - installs software needed to develop Python Appium tests.

# Python 2.7  (http://www.python.org/)
# pip         (http://www.pip-installer.org/en/latest/)
# selenium    (https://pypi.python.org/pypi/selenium)

echo -e "\nSetting up Python environment..."

echo -e "$chck Checking for Python...${txtrst}"
  if ! try python --version; then
    echo -e "$inst Installing Python...${txtrst}"
    successfully brew install python
  fi

echo -e "\n$chck Checking for pip...${txtrst}"
  if ! try pip --version; then
    echo -e "$inst Installing pip...${txtrst}"
    echo -e "$warn This must be done using sudo..."
    successfully sudo easy_install pip
  fi

echo -e "\n$chck Checking for selenium Python bindings...${txtrst}"
  if ! pip list | grep selenium; then
    echo -e "$inst Installing selenium...${txtrst}"
    echo -e "$warn This must be done using sudo..."
    successfully sudo pip install -U selenium
  fi
