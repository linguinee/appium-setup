#!/bin/bash
# appium_env.sh - installs software needed to develop Appium tests on Mac OS X.

# Tested on OS X v10.8 (Mountain Lion).

# Example usage:
#   ./appium_env.sh [options]

# Running the script with no options installs Appium software only (no
# language-specific software).

# Options:
#   -h, --help   Prints usage.
#   -a, --all    Installs all software for all languages.
#   --no-source  Does not clone the appium source code.
#   --haskell    Installs Haskell software.
#   --java       Installs Java software.
#   --obj-c      Installs Objective-C software.
#   --perl       Installs Perl software.
#   --php        Installs PHP software.
#   --python     Installs Python software.
#   --ruby       Installs Ruby software.

# Script adapted from
#   https://github.com/thoughtbot/laptop/blob/master/mac.
# Text color variables adapted from
#   http://linuxtidbits.wordpress.com/2012/01/20/bash-script-templates.

# NOTE TO SELF: exit status 0 is GOOD.

trap "exit 1" TERM
export TOP_PID=$$

txtrst=$(tput sgr0)              # Reset
txtbld=$(tput bold)              # Bold

bldred=${txtbld}$(tput setaf 1)  # Red
bldgrn=${txtbld}$(tput setaf 2)  # Green
bldora=${txtbld}$(tput setaf 3)  # Orange
bldblu=${txtbld}$(tput setaf 4)  # Blue
bldmag=${txtbld}$(tput setaf 5)  # Magenta
bldcer=${txtbld}$(tput setaf 6)  # Cerulean
bldwht=${txtbld}$(tput setaf 7)  # White
bldgry=${txtbld}$(tput setaf 8)  # Grey

chck="${txtbld}*"                # Check symbol
warn="${bldred}VV${txtrst}"      # Warn symbol
inst="${bldmag}==>${txtrst}"     # Install symbol
updt="${bldblu}==>${txtrst}"     # Update symbol

# Software versions.
appium_ver=0.12.0

node_ver=v0.10.13
npm_ver=1.3.2

grunt_cli_ver=v0.1.9
grunt_ver=v0.4.1
mocha_ver=1.12.0

maven_ver=3.1.1

# Flags.
install_all=false
install_none=true
install_force=false
install_src=true

install_hskl=false
install_java=false
install_js=false
install_objc=false
install_perl=false
install_php=false
install_python=false
install_ruby=false

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

usage() {
  echo ""
  echo "Example usage:"
  echo "  ./appium_env.sh [options]"
  echo ""
  echo "Running the script with no options installs Appium software only (no "`
      `"language-specific software)."
  echo ""
  echo "Options:"
  echo "  -h, --help   Prints usage."
  echo "  -a, --all    Installs software for all languages."
  echo "  -f, --force  Ignores certains warnings to force continuation."
  echo "  --no-source  Does not clone the Appium source code."
  echo "  --haskell    Installs Haskell software."
  echo "  --java       Installs Java software."
  echo "  --obj-c      Installs Objective-C software."
  echo "  --php        Installs PHP software."
  echo "  --python     Installs Python software."
  echo "  --ruby       Installs Ruby software."
  echo ""
}

# Parse arguments.
# From http://stackoverflow.com/a/7069755/1282635.
while test $# -gt 0; do
  case "$1" in
    -h|--help)   usage; exit 0;;
    -a|--all)    install_all=true;;
    -f|--force)  install_force=true;;
    --no-source) install_src=false;;
    --haskell)   install_hskl=true;;
    --java)      install_java=true;;
    --obj-c)     install_objc=true;;
    --php)       install_php=true;;
    --python)    install_python=true;;
    --ruby)      install_ruby=true;;
    *)           usage; exit 0;;
  esac
  shift
done

## START
echo -e "\nSetting up Appium environment..."

echo -e "\n$chck Checking for Homebrew...${txtrst}"
  if ! try brew -v; then
    echo -e "$inst Installing Homebrew...${txtrst}"
    successfully ruby <(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)
  fi

  echo -e "$updt Doctoring Homebrew...${txtrst}"
  if ! brew doctor | grep "is ready to brew"; then
    if $install_force; then
      echo -e "${bldred}\nThere are brew problems! Please fix them.${txtrst}"
    else
      echo -e "${bldred}\nFix brew problems and then retry, please.${txtrst}"
      real_exit
    fi
  fi

  echo -e "$updt Updating Homebrew...${txtrst}"
  successfully brew update

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

  g=$(successfully grunt --version | awk '{print $2}' | grep '\.')
  if ! check_version $(echo $g | awk '{print $1}') $grunt_cli_ver || \
     ! check_version $(echo $g | awk '{print $2}') $grunt_ver || \
     ! check_version $(successfully mocha --version) $mocha_ver; then
    echo -e "$updt Updating npm packages...${txtrst}"
    successfully npm update
  fi

echo -e "\n$chck Checking for Maven...${txtrst}"
  if ! try mvn --version; then
    echo -e "$inst Installing Maven...${txtrst}"
    successfully brew install homebrew/versions/maven
  fi

  m=$(successfully mvn --version | awk '{print $3}')
  if ! check_version $maven_ver $(echo $g | awk '{print $1}'); then
    echo -e "$warn Maven is outdated, should be $maven_ver"
    successfully brew install homebrew/versions/maven
  fi

echo -e "\n$chck Checking for Appium command line...${txtrst}"
  if ! successfully appium --version; then
     echo -e "$inst Installing Appium command line...${txtrst}"
     successfully npm install -g appium
  fi

echo -e "$chck Checking Appium command line version...${txtrst}"
  if ! check_version $(appium --version) $appium_ver; then
    echo -e "$warn Appium is outdated, should be $appium_ver"
    successfully npm install -g appium
  fi

if $install_all; then
  source ./haskell.sh;
  source ./java.sh;
  source ./js.sh;
  source ./obj-c.sh;
  source ./perl.sh;
  source ./php.sh;
  source ./python.sh;
  source ./ruby.sh;
else
  if $install_hskl;   then source ./haskell.sh; fi
  if $install_java;   then source ./java.sh;    fi
  if $install_js;     then source ./js.sh;      fi
  if $install_objc;   then source ./obj-c.sh;   fi
  if $install_perl;   then source ./perl.sh;    fi
  if $install_php;    then source ./php.sh;     fi
  if $install_python; then source ./python.sh;  fi
  if $install_ruby;   then source ./ruby.sh;    fi
fi

echo -e "\n$chck Checking for Appium executable...${txtrst}"
  if [ ! -e /Applications/Appium.app ]; then
    echo -e "${bldred} You can download the Appium executable "`
           `"from http://appium.io/index.html.\n${txtrst}"
  fi

if $install_src; then
echo -e "\n$chck Checking for Appium repository...${txtrst}"
  if [ ! -d $HOME/Documents/appium/.git ]
  then
    echo -e "$inst Cloning Appium to $HOME/Documents/appium...${txtrst}"
    successfully git clone https://github.com/appium/appium.git \
                           $HOME/Documents/appium
  fi

echo -e "\nPlease run ${bldcer}git pull${txtrst} and then ${bldcer}"`
       `"./reset.sh --dev${txtrst} on $HOME/Documents/appium."
fi

echo -e "${txtbld}\nDone! Have a great day!\n${txtrst}"
