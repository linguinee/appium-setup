appium-setup
============

appium_env.sh is a Mac environment setup script that installs software needed to develop [Appium](http://appium.io/) acceptance tests in the language of your choice.

Prerequisites
-------------

* [Xcode](https://developer.apple.com/xcode/), along with Command Line Tools

If you want to develop Android tests, you also need:
* [Android SDK](http://developer.android.com/sdk/index.html)
* Make sure `JAVA_HOME` is set (add `export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"` to your `.bash_profile`)
* Make sure `ANDROID_HOME` is set (add `export ANDROID_HOME="/path/to/android/sdk"` to your `.bash_profile`)
* Add `/path/to/android/sdk`, `/path/to/android/sdk/tools`, and `/path/to/android/sdk/platform-tools` to your `/etc/paths` file (might have to do this with sudo)
* Create an [AVD](http://developer.android.com/tools/devices/index.html) (look into speeding up the Emulator using Intel HAXM for [x86 AVDs](http://developer.android.com/tools/devices/emulator.html#accel-vm), and [x86 AVDs with Google APIs](http://codebutler.com/2012/10/10/configuring-a-usable-android-emulator/)) or use a real Android device to run tests on

Execute the script
------------------

To execute the script, you must `chmod a+x *.sh` first.

Example usage:

    ./appium_env.sh [options]

Running the script with no options installs Appium software only (no language-specific software).

Options:

    -h, --help   Prints usage.
    -a, --all    Installs all software for all languages.
    -f, --force  Ignores certains warnings to force continuation.
    --no-source  Does not clone the appium source code.
    --haskell    Installs Haskell software.
    --ruby       Installs Ruby software.
    --java       Installs Java software.
    --obj-c      Installs Objective-C software.
    --perl       Installs Perl software.
    --php        Installs PHP software.
    --python     Installs Python software.

What it installs
----------------

Appium
* [Homebrew](http://brew.sh/)
* [Node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [grunt](http://gruntjs.com/)
* [mocha](http://visionmedia.github.io/mocha/)
* [Maven](http://maven.apache.org/)
* [Appium](http://appium.io/) command line (from npm)
* [ios-sim](https://github.com/phonegap/ios-sim)***
* Clones the [appium Github repo](https://github.com/appium/appium) to ~/Documents/appium, if you want to run Appium from source (unless you specify `--no-source`)

Haskell `--haskell`
* [Haskell Platform](http://www.haskell.org/platform/)
* [Cabal](http://www.haskell.org/cabal/users-guide/index.html)
* [hs-webdriver](https://github.com/kallisti-dev/hs-webdriver)

Ruby `--ruby`
* [Ruby](http://www.ruby-lang.org/en/) 2.0+
* [RVM](https://rvm.io/)
* [selenium-webdriver](http://rubygems.org/gems/selenium-webdriver) gem
* [appium_lib](http://rubygems.org/gems/appium_lib) gem
* [rspec](http://rubygems.org/gems/rspec) gem*
* [CI::Reporter](http://rubygems.org/gems/ci_reporter) gem*
* [JSON](http://flori.github.io/json/) gem**
* [httparty](http://rubygems.org/gems/httparty) gem**

Java `--java`
* Nothing. Download the jar from [Selenium HQ](http://www.seleniumhq.org/download/)

Objective-C `--obj-c`
* Nothing. Download the framework from [GitHub](https://github.com/appium/selenium-objective-c)

Perl `--perl`
* Nothing. Install the module by following the instructions from [Selenium-Remote-Driver](https://github.com/aivaturi/Selenium-Remote-Driver)

PHP `--php`
* [PHP](http://www.php.net/) 5.3
* [Pear](http://pear.php.net/)
* [Composer](http://getcomposer.org/)
* [Xdebug](http://xdebug.org/index.php)*
* [PHPUnit](http://phpunit.de/manual/)*
* [php-webdriver](https://github.com/Element-34/php-webdriver)

Python `--python`
* [Python](http://www.python.org/) 2.7
* [pip](http://www.pip-installer.org/en/latest/)
* [selenium](https://pypi.python.org/pypi/selenium)

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
sudo authorize_ios  # enable developer use of iOS sim
npm install wd
curl -O https://raw.github.com/appium/appium/master/sample-code/examples/node/simplest.js
appium &
node simplest.js
```
