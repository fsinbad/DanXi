[中文版](README.md) English Version
[Official Website(Chinese Only)](https://danxi.fduhole.com)

# DanXi

[![CI](https://github.com/DanXi-Dev/DanXi/actions/workflows/ci_ios.yml/badge.svg)](https://github.com/DanXi-Dev/DanXi/actions/workflows/ci_ios.yml)
[![Deploy to GitHub Pages](https://github.com/DanXi-Dev/DanXi/actions/workflows/deploy_to_gh-pages.yml/badge.svg)](https://github.com/DanXi-Dev/DanXi/actions/workflows/deploy_to_gh-pages.yml)

> **CAUTION**
> The English version of README may not be synchronized with [the Chinese one](README.md).

日月光华，旦复旦兮.(The sun and the moon are shining, full of glory. And the morning sun rises, again and
again.)

Maybe the best all-rounded service app for Fudan University students!

**DanXi only support Chinese (Simplified) and English language at the moment. Come to help us!**

- Campus card balance and transactions
- Dining hall traffic
- Shortcut for Fudan QR Code (with support for Apple Watch)
- View empty classrooms
- Tree Hole
- View compulsory-exercise records
- View timetable and export as .ics file
- Show Notices from Academic Affairs Office
- View exam schedule and export as .ics file
- View final exam GPA and ranking
- View school bus schedule

This application is still at active development stage, we will be happy if you can join the development or make a donation!

# Install

If you meet abnormal behavior in
DanXi，Please [create an issue](https://github.com/DanXi-Dev/DanXi/issues/new/choose)
or [create a new pull request](https://github.com/DanXi-Dev/DanXi/compare).

## Windows

Go to [release page](https://github.com/DanXi-Dev/DanXi/releases), just download the zip file and
unzip it.

## Android

Go to [release page](https://github.com/DanXi-Dev/DanXi/releases), just download the apk file and
install it.
(Depending on the device, you may need to allow "Install apps from unknown sources" in the
settings.)

## iOS/iPadOS

Download from [App Store](https://apps.apple.com/us/app/旦夕/id1568629997)

## macOS

Go to [release page](https://github.com/DanXi-Dev/DanXi/releases), just download the dmg file and
mount it.

# Compile

## Flutter version that we're using

```shell
$ flutter --version
Flutter 3.13.8 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 6c4930c4ac (9 days ago) • 2023-10-18 10:57:55 -0500
Engine • revision 767d8c75e8
Tools • Dart 3.1.4 • DevTools 2.25.0
```

## Notes on compilation

The app is compiled with [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/).

To build this app, you need to [download Flutter SDK](https://flutter.dev/docs/get-started/install) and install it.

If you are building for `Windows`, you should also [install and configure](https://visualstudio.microsoft.com/downloads/) `Visual Studio`.

If you are building for `Android`, you should also [install and configure](https://developer.android.com/studio) `Android Command Line Tools`.

If you are building for `iOS/iPadOS`, you should also [install and configure](https://apps.apple.com/cn/app/xcode/id497799835) `Xcode`.

Run the command 

```
dart run build_runner build --delete-conflicting-outputs
dart run intl_utils:generate
```

and then  `flutter run [ios/android]` to start the app.
