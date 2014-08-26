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
* Create an [AVD](http://developer.android.com/tools/devices/index.html) (look into speeding up the emulator using VM acceleration for [x86 AVDs](http://developer.android.com/tools/devices/emulator.html#accel-vm)) or use a real Android device to run tests on

Execute the script
------------------

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

Java `--java`
* Nothing. Download your chosen webdriver bindings ([Selenium HQ Java](http://www.seleniumhq.org/download/), [java-client](https://github.com/appium/java-client))

Objective-C `--obj-c`
* [xctool](https://github.com/facebook/xctool)
* Download the framework from [GitHub](https://github.com/appium/selenium-objective-c)

Perl `--perl`
* Nothing. Install the module by following the instructions from [Selenium-Remote-Driver](https://github.com/aivaturi/Selenium-Remote-Driver)

PHP `--php`
* [PHP](http://www.php.net/) 5.3
* [Pear](http://pear.php.net/)
* [Composer](http://getcomposer.org/)
* [Xdebug](http://xdebug.org/index.php)*
* [PHPUnit](http://phpunit.de/manual/)*
* Download your chosen webdriver bindings ([php-webdriver](https://github.com/facebook/php-webdriver), [phpunit-selenium](https://github.com/giorgiosironi/phpunit-selenium), [php-client](https://github.com/appium/php-client), etc.)

Python `--python`
* [Python](http://www.python.org/) 2.7
* [pip](http://www.pip-installer.org/en/latest/)
* Download your chosen webdriver bindings ([selenium](https://pypi.python.org/pypi/selenium), [Appium-Python-Client](https://github.com/appium/python-client))

**\* Substitute this with the test framework of your choice.**

After the script runs
---------------------

* Install Appium.app if you would like and have not done so already. It has a nice Inspector functionality that allows you to record actions and view elements.
* Run `git pull` and then `./reset.sh --dev` on ~/Documents/appium.
