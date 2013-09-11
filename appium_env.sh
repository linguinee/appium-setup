#!/bin/bash
# appium_env - installs software needed to develop Appium tests on Mac OS X.
# Tested on OS X v10.8 (Mountain Lion).

# Script adapted from
#   https://github.com/thoughtbot/laptop/blob/master/mac
# Text color variables adapted from
#   http://linuxtidbits.wordpress.com/2012/01/20/bash-script-templates/

# NOTE TO SELF: exit status 0 is GOOD.

trap "exit 1" TERM
export TOP_PID=$$

txtrst=$(tput sgr0)              # Reset
txtbld=$(tput bold)              # Bold

bldred=${txtbld}$(tput setaf 1)  # red
bldgrn=${txtbld}$(tput setaf 2)  # green
bldora=${txtbld}$(tput setaf 3)  # orange
bldblu=${txtbld}$(tput setaf 4)  # blue
bldmag=${txtbld}$(tput setaf 5)  # magenta
bldcer=${txtbld}$(tput setaf 6)  # cerulean
bldwht=${txtbld}$(tput setaf 7)  # white
bldgry=${txtbld}$(tput setaf 8)  # grey

chck="${txtbld}*"                # Check symbol
warn="${bldred}VV${txtrst}"      # Warn symbol
inst="${bldmag}==>${txtrst}"     # Install symbol
updt="${bldblu}==>${txtrst}"     # Update symbol

# Software versions
appium_ver=0.8.2

ruby_ver=2.0.0p247
ruby_ver_m=2.0.0
ruby_ver_p=247

rvm_ver=1.21.8

node_ver=v0.10.13
npm_ver=1.3.2

grunt_cli_ver=v0.1.9
grunt_ver=v0.4.1
mocha_ver=1.12.0

rspec_ver=2.14.2

# Terminate the entire script.
# From http://stackoverflow.com/a/9894126/1282635.
real_exit() {
  echo -e "Goodbye :'("
  kill -s TERM $TOP_PID
}

try() {
  if $* 2>&1 | grep -q "command not found"
  then return 1  # command does not exist
  else return 0  # command exists
  fi
}

# From http://stackoverflow.com/a/18711257/1282635.
successfully() {
  echo -e "${bldcer}$*${txtrst}"
  local __A=() __I
  for (( __I = 1; __I <= $#; ++__I )); do
    if [[ "${!__I}" == '|' ]]; then
      __A+=('|')
    else
      __A+=("\"\$$__I\"")
    fi
  done
  eval "${__A[@]}" || (echo -e "${bldred}\nFailed. Check output"`
                       `" and then retry, please.${txtrst}" 1>&2 && real_exit)
}

# Usage: check_version <user_version> <correct_version>
# From http://fitnr.com/bash-comparing-version-strings.html and
#      http://stackoverflow.com/a/4495368/1282635.
check_version() {
  local version=$1 check=$2
  local winner=$(echo -e "$version\n$check" | sed '/^$/d' | \
                 sort -t. -k1,1nr -k2,2nr -k3,3nr -k4,4nr | head -1)
  [[ "$winner" = "$version" ]] && return 0  # user version is good
  return 1                                  # user version is outdated
}


## START
echo -e "\nSetting up Appium environment..."

echo -e "\n$chck Checking for Homebrew...${txtrst}"
  if ! try brew -v; then
    echo -e "$inst Installing Homebrew...${txtrst}"
    successfully ruby <(curl -fsS https://raw.github.com/mxcl/homebrew/go)
  fi

  echo -e "$updt Updating Homebrew...${txtrst}"
  successfully brew update

  echo -e "$updt Doctoring Homebrew...${txtrst}"
  if ! brew doctor | grep "is ready to brew"; then
    echo -e "${bldred}\nFix brew problems and then retry, please.${txtrst}"
    real_exit
  fi

echo -e "\n$chck Checking for Ruby and RVM...${txtrst}"
  if ! brew list | grep -q libyaml; then
    echo -e "$inst Installing libyaml...${txtrst}"
    successfully brew install libyaml
  fi

  if ! try ruby -v || ! try rvm -v; then
    echo -e "$inst Installing Ruby and RVM (this may take "`
              `"a few minutes)...${txtrst}"
    successfully curl -L https://get.rvm.io \| bash -s stable --ruby
    successfully source $HOME/.rvm/scripts/rvm
    successfully rvm reload
  fi

echo -e "$chck Checking Ruby and RVM versions...${txtrst}"
  r=$(successfully rvm -v | awk '{print $2}' | grep "\.")
  if ! check_version $r $rvm_ver; then
    echo -e "$warn RVM is outdated, should be $rvm_ver but is $r ${txtrst}"
    echo -e "$updt Updating Ruby and RVM...${txtrst}"
    if curl -L https://get.rvm.io/ | bash -s stable --ruby | \
       grep "rvm-installer [options]"; then
      successfully rvm-installer
    fi
    successfully rvm reload
  fi

  # Ruby has major and minor versions to account for (separated by 'p')
  r=$(successfully ruby -v | awk '{print $2}' | grep "\.")
  rr=(${r//p/ })

  # Update to 2.0+
  if ! check_version $rr $ruby_ver_m; then
    echo -e "$warn Ruby is majorly outdated, should be $ruby_ver "`
           `"but is $r ${txtrst}"
    echo -e "$updt Resolving OpenSSL compatibility problem (this may take "`
           `"a while)...${txtrst}"
    successfully rvm pkg install openssl
    successfully rvm reinstall all --force
    echo -e "$inst Installing Ruby 2.0...${txtrst}"
    successfully rvm install 2.0.0
    echo -e "$updt Setting Ruby 2.0 as the default...${txtrst}"
    successfully rvm use 2.0.0 --default
  fi

  if ! check_version ${rr[1]} $ruby_ver_p; then
    echo -e "$warn Ruby is outdated, should be $ruby_ver but is $r ${txtrst}"
    echo -e "$updt Updating Ruby and RVM...${txtrst}"
    if curl -L https://get.rvm.io/ | bash -s stable --ruby | \
       grep "rvm-installer [options]"; then
      successfully rvm-installer
    fi
    successfully rvm reload
  fi

echo -e "\n$chck Checking for Node.js and npm..${txtrst}"
  if ! try node --version || ! try npm --version; then
    echo -e "$inst Installing node...${txtrst}"
    successfully brew install node
  fi

echo -e "$chck Checking Node.js and npm versions...${txtrst}"
  updated=true

  if ! successfully node --version || \
     ! check_version $(node --version) $node_ver; then
    updated=false
    echo -e "$warn Node.js is outdated, should be $node_ver"
  fi

  if ! successfully npm --version || \
     ! check_version $(npm --version) $npm_ver; then
    updated=false
    echo -e "$warn npm is outdated, should be $npm_ver"
  fi

  if ! $updated; then
    echo -e "$updt Updating Node.js and npm...${txtrst}"
    if brew upgrade node 2>&1 | grep -q "node not installed"; then
      echo -e "$warn Your node was not installed using Homebrew. Either:"
      echo -e "     - Re-install node from http://nodejs.org/ again "`
                `"in order to update it. OR"
      echo -e "     - Remove node by following the top answer from "`
                `"http://stackoverflow.com/q/9044788, then install node "`
                `"using Homebrew (${bldcer}brew install node${txtrst}). "`
                `"You may have to remove the directory containing node.d "`
                `"for linking to work."
      echo -e "${bldred}\nFailed. Check output and then "`
                `"retry, please.${txtrst}" 1>&2
      real_exit
    fi
  fi

  if ! echo $PATH | grep -q npm; then
    echo -e "$updt Adding /usr/local/share/npm/bin to PATH...${txtrst}"
    echo 'PATH="$PATH:/usr/local/share/npm/bin"' >> $HOME/.bash_profile
    echo 'export PATH' >> $HOME/.bash_profile
    successfully source $HOME/.bash_profile
  fi

echo -e "\n$chck Checking for grunt...${txtrst}"
  if ! try grunt --version; then
    echo -e "$inst Installing grunt...${txtrst}"
    successfully npm install -g grunt grunt-cli
  fi

echo -e "\n$chck Checking for mocha...${txtrst}"
  if ! try mocha --version; then
    echo -e "$inst Installing mocha...${txtrst}"
    successfully npm install -g mocha
  fi

  g=$(successfully grunt --version | awk '{print $2}' | grep "\.")
  if ! check_version $(echo $g | awk '{print $1}') $grunt_cli_ver || \
     ! check_version $(echo $g | awk '{print $2}') $grunt_ver || \
     ! check_version $(successfully mocha --version) $mocha_ver; then
    echo -e "$updt Updating npm packages...${txtrst}"
    successfully npm update
  fi

echo -e "\n$chck Checking for Selenium WebDriver...${txtrst}"
  if ! gem list --local | grep -q selenium-webdriver; then
    echo -e "$inst Installing Selenium WebDriver...${txtrst}"
    successfully gem install selenium-webdriver
  fi

echo -e "\n$chck Checking for appium_lib...${txtrst}"
  if ! gem list --local | grep -q appium_lib; then
    echo -e "$inst Installing appium_lib...${txtrst}"
    successfully gem install appium_lib
  fi

echo -e "$chck Checking for RSpec...${txtrst}"
  if ! try rspec --version; then
    echo -e "$inst Installing RSpec...${txtrst}"
    successfully gem install rspec
  fi

echo -e "$chck Checking for CI::Reporter...${txtrst}"
  if ! gem list --local | grep -q ci_reporter; then
    echo -e "$inst Installing CI::Reporter...${txtrst}"
    successfully gem install ci_reporter
  fi

echo -e "$chck Checking for JSON...${txtrst}"
  if ! gem list --local | grep -q json_pure; then
    echo -e "$inst Installing JSON gem...${txtrst}"
    successfully gem install json
  fi

echo -e "$chck Checking for httparty...${txtrst}"
  if ! gem list --local | grep -q httparty; then
    echo -e "$inst Installing httparty...${txtrst}"
    successfully gem install httparty
  fi

  echo -e "$updt Updating gems...${txtrst}"
  successfully gem update

echo -e "\n$chck Checking for ios-sim...${txtrst}"
  if ! try ios-sim --version; then
    echo -e "$inst Installing ios-sim...${txtrst}"
    successfully brew install ios-sim
  fi

echo -e "\n$chck Checking for Appium repository...${txtrst}"
  if [ ! -d $HOME/Documents/appium/.git ]
  then
    echo -e "$inst Cloning Appium to $HOME/Documents/appium...${txtrst}"
    successfully git clone https://github.com/appium/appium.git \
                           $HOME/Documents/appium
  fi

echo -e "$chck Checking for Appium command line...${txtrst}"
  if ! successfully appium --version; then
     echo -e "$inst Installing Appium command line...${txtrst}"
     successfully npm install -g appium
  fi

echo -e "$chck Checking Appium command line version...${txtrst}"
  if ! check_version $(appium --version) $appium_ver; then
    echo -e "$warn Appium is outdated, should be $appium_ver"
    successfully npm install -g appium
  fi

echo -e "$chck Checking for Appium executable...${txtrst}"
  if [ ! -e /Applications/Appium.app ]; then
    echo -e "${bldred} You can download the Appium executable "`
              `"from http://appium.io/index.html.\n${txtrst}"
  fi

echo -e "\nPlease run ${bldcer}git pull${txtrst} and then ${bldcer}"`
         `"./reset.sh --dev${txtrst} on $HOME/Documents/appium."

echo -e "${txtbld}\nDone! Have a great day!\n${txtrst}"
