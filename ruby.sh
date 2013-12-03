#!/bin/bash
# ruby.sh - installs software needed to develop Ruby Appium tests.

# Ruby 2.0+           (http://www.ruby-lang.org/en/)
# RVM                 (https://rvm.io/)
# selenium-webdriver  (http://rubygems.org/gems/selenium-webdriver)
# appium_lib          (http://rubygems.org/gems/appium_lib)
# rspec               (http://rubygems.org/gems/rspec)
# CI::Reporter        (http://rubygems.org/gems/ci_reporter)
# JSON                (http://flori.github.io/json/)
# httparty            (http://rubygems.org/gems/httparty)

ruby_ver=2.0.0p247
ruby_ver_m=2.0.0
ruby_ver_p=247

rvm_ver=1.21.8

rspec_ver=2.14.2

echo -e "\nSetting up Ruby environment..."

echo -e "$chck Checking for Ruby and RVM...${txtrst}"
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
  r=$(successfully rvm -v | awk '{print $2}' | grep '\.')
  if ! check_version $r $rvm_ver; then
    echo -e "$warn RVM is outdated, should be $rvm_ver but is $r ${txtrst}"
    echo -e "$updt Updating Ruby and RVM...${txtrst}"
    if curl -L https://get.rvm.io/ | bash -s stable --ruby | \
       grep 'rvm-installer [options]'; then
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

echo -e "\n$chck Checking for RSpec...${txtrst}"
  if ! try rspec --version; then
    echo -e "$inst Installing RSpec...${txtrst}"
    successfully gem install rspec
  fi

echo -e "\n$chck Checking for CI::Reporter...${txtrst}"
  if ! gem list --local | grep -q ci_reporter; then
    echo -e "$inst Installing CI::Reporter...${txtrst}"
    successfully gem install ci_reporter
  fi

echo -e "\n$chck Checking for JSON...${txtrst}"
  if ! gem list --local | grep -q json_pure; then
    echo -e "$inst Installing JSON gem...${txtrst}"
    successfully gem install json
  fi

echo -e "\n$chck Checking for httparty...${txtrst}"
  if ! gem list --local | grep -q httparty; then
    echo -e "$inst Installing httparty...${txtrst}"
    successfully gem install httparty
  fi

echo -e "\n$updt Updating gems...${txtrst}"
  successfully gem update
