# Setting up Android

## Getting the SDK

Install the latest JDK:

```
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```

Pick in the Android SDK using Homebrew:

```
brew install android-sdk
```

Export `ANDROID_HOME` in your shell config like:

```shell
export ANDROID_HOME =/usr/local/opt/android-sdk
```

Next run `android` from the command line to open the SDK Manager. You
should see a menu open. After it finishes updating, some packages will
be automatically checked. Also be sure to check the following:

- Android SDK Build Tools Version 23.0.1
- Android 6.0 (API 23)
- Android Support Repository

Then click "Install `x` Packages", and accept the associated
licenses. Then wait for a bit for them to install.

## Getting an Emulator

For a long time, Android was plagued by slow emulators. This is
because of differences in hardware architecture between Android
devices and your laptop.

Not so anymore! Run `android` again to open the SDK Manager and
install the following packages:

- Intel x86 Atom System Image (for Android 5.1.1–API 22)
- Intel x86 Emulator Accelerator (HAXM installer)

Then click "Install Packages" and wait. When it finishes, it'll be
time to create an emulator!

Run the following command to open the Android emulator manager (AVD):

```shell
android avd
```
