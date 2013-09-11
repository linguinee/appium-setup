appium-setup
============

appium_env.sh is a Mac environment setup script that installs software needed to develop [Appium](http://appium.io/) acceptance tests in Ruby.

Prerequisites
-------------

* [Xcode](https://developer.apple.com/xcode/), along with Command Line Tools

If you want to develop Android tests, you also need:
* [Android SDK](http://developer.android.com/sdk/index.html)
* Make sure `JAVA_HOME` is set (add `export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"` to your `.bash_profile`).
* Make sure `ANDROID_HOME` is set (add `export ANDROID_HOME="/path/to/android/sdk"` to your `.bash_profile`).
* Add `/path/to/android/sdk`, `/path/to/android/sdk/tools`, and `/path/to/android/sdk/platform-tools` to your `/etc/paths` file (might have to do this with sudo).
* Create an [AVD](http://developer.android.com/tools/devices/index.html) (look into speeding up the Emulator using Intel HAXM for [x86 AVDs](http://developer.android.com/tools/devices/emulator.html#accel-vm), and [x86 AVDs with Google APIs](http://codebutler.com/2012/10/10/configuring-a-usable-android-emulator/)).

Execute the script
------------------

To execute the script, you must `chmod a+x appium_env.sh` first. Then, run it as normal using `./appium_env.sh`.

What it installs
----------------

* [Homebrew](http://brew.sh/)
* [Ruby](http://www.ruby-lang.org/en/) 2.0+
* [RVM](https://rvm.io/)
* [Node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [grunt](http://gruntjs.com/)
* [mocha](http://visionmedia.github.io/mocha/)
* [selenium-webdriver](http://rubygems.org/gems/selenium-webdriver) gem
* [appium_lib](http://rubygems.org/gems/appium_lib) gem
* [Appium](http://appium.io/) command line (from npm)
* [rspec](http://rubygems.org/gems/rspec) gem*
* [CI::Reporter](http://rubygems.org/gems/ci_reporter) gem*
* [JSON](http://flori.github.io/json/) gem**
* [httparty](http://rubygems.org/gems/httparty) gem**
* [ios-sim](https://github.com/phonegap/ios-sim)***

It also clones the [appium Github repo](https://github.com/appium/appium) to ~/Documents/appium, if you want to run Appium from source.

**\* Substitute this with the test framework of your choice.**  
**\*\* These are gems used to access APIs for certain tests, so they are optional.**  
**\*\*\* This is a useful tool that launches the Simulator from the command line.**  

After the script runs
---------------------

* Install Appium.app if you would like and have not done so already. It has a nice Inspector functionality that allows you to record actions and view elements.
* Run `git pull` and then `./reset.sh --dev` on ~/Documents/appium.
* Go through the Appium [User Quickstart](http://appium.io/getting-started.html) below (downloads a sample iOS calculator app and runs tests).

```bash
mkdir appium-test && cd appium-test
npm install -g appium  # might have to do this with sudo
sudo authorize_ios     # enable developer use of iOS sim
npm install wd
curl -O https://raw.github.com/appium/appium/master/sample-code/examples/node/simplest.js
appium &
node simplest.js
```
