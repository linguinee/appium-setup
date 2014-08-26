#!/bin/bash
# php.sh - installs software needed to develop PHP Appium tests.

# PHP 5.3       (http://www.php.net/)
# Pear          (http://pear.php.net/)
# Xdebug        (http://xdebug.org/index.php)
# PHPUnit       (http://phpunit.de/manual/)
# Composer      (http://getcomposer.org/)

php_ver=5.3.3

xdbg_ver=2.2.1
phpu_ver=3.7.24

echo -e "\nSetting up PHP environment..."

echo -e "$chck Checking for Homebrew PHP...${txtrst}"
  if brew search php | grep -q josegonzalez; then
    echo -e "$inst Tapping into Homebrew PHP...${txtrst}"
    successfully brew tap homebrew/dupes
    successfully brew tap josegonzalez/homebrew-php
  fi

echo -e "\n$chck Checking for PHP...${txtrst}"
  if ! try php -v; then
    echo -e "$inst Installing PHP (this may take a few minutes)...${txtrst}"
    successfully brew install php53
  fi

echo -e "$chck Checking PHP version...${txtrst}"
  p=$(successfully php -v | awk '{print $2}' | grep '\.')
  if ! check_version $p $php_ver; then
    echo -e "$warn PHP is outdated, should be $php_ver but is $p ${txtrst}"
    echo -e "$updt Updating PHP...${txtrst}"
    if ! brew list | grep -q php53; then
      echo -e "$inst Installing PHP using Homebrew...${txtrst}"
      successfully brew install php53
    else
      successfully brew upgrade php53
    fi
  fi

echo -e "\n$chck Checking for Xdebug...${txtrst}"
  if ! php --ini | grep -q xdebug; then
    echo -e "$inst Installing Xdebug...${txtrst}"
    successfully brew install php53-xdebug
  fi

echo -e "$chck Checking Xdebug version...${txtrst}"
  x=$(successfully php -i | grep -A1 'xdebug support' | \
      awk '{print $3}' | grep '\.')
  if ! check_version $x $xdbg_ver; then
    echo -e "$warn Xdebug is outdated, should be $xdbg_ver but is $x ${txtrst}"
    echo -e "$updt Updating Xdebug...${txtrst}"
    if ! brew list | grep -q php53-xdebug; then
      echo -e "$inst Installing Xdebug using Homebrew...${txtrst}"
      successfully brew install php53-xdebug
    else
      successfully brew upgrade php53-xdebug
    fi
  fi

echo -e "\n$chck Checking for PHPUnit...${txtrst}"
  if ! try phpunit --version; then
    echo -e "$inst Installing PHPUnit...${txtrst}"
    successfully brew install phpunit
  fi

echo -e "$chck Checking PHPUnit version...${txtrst}"
  p=$(successfully phpunit --version | awk '{print $2}' | grep '\.')
  if ! check_version $p $phpu_ver; then
    echo -e "$warn PHPUnit is outdated, should be $phpu_ver "`
           `"but is $p ${txtrst}"
    echo -e "$updt Updating PHPUnit...${txtrst}"
    if ! brew list | grep -q phpunit; then
      echo -e "$inst Installing PHPUnit using Homebrew...${txtrst}"
      successfully brew install phpunit
    else
      successfully brew upgrade phpunit
    fi
  fi

echo -e "\n$chck Checking for Composer...${txtrst}"
  if ! try composer --version; then
    echo -e "$inst Installing Composer...${txtrst}"
    successfully brew install composer
  fi
