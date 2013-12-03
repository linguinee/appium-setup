#!/bin/bash
# haskell.sh - installs software needed to develop Haskell Appium tests.

# Haskell Platform  (http://www.haskell.org/platform/)
# Cabal             (http://www.haskell.org/cabal/users-guide/index.html)
# hs-webdriver      (https://github.com/kallisti-dev/hs-webdriver)

echo -e "\nSetting up Haskell environment..."

echo -e "$chck Checking for Haskell...${txtrst}"
  if ! try ghc --version; then
    echo -e "$inst Installing Haskell Platform...${txtrst}"
    echo -e "${bldred}This will take a long time (around 15 minutes)!${txtrst}"
    successfully brew install haskell-platform
  fi

echo -e "\n$chck Checking for Cabal...${txtrst}"
  if ! try cabal --version; then
    echo -e "$inst Installing Cabal...${txtrst}"
    successfully brew install cabal-install
    successfully cabal update
  fi

echo -e "\n$chck Checking for hs-webdriver...${txtrst}"
  successfully cabal update
  if cabal list webdriver | grep -q "Not installed"
    echo -e "$inst Installing hs-webdriver...${txtrst}"
    successfully cabal install webdriver
  fi
