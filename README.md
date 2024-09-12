# dyte_uikit_flutter_starter_app

This is a starter app for the Dyte UI Kit Flutter package. The package provides a set of pre-built repetitive work to reuse across multiple projects. It is a collection of widgets, themes, and utilities that can be used to build applications faster.


## Installation

We will use [rename](https://pub.dev/packages/rename) to __rename__ the app. To install rename, run the following command:

```bash
flutter pub global activate rename
```
Once you have installed `rename` package in your system, you can rename the app using the following command:

```bash
rename setAppName --targets ios,android --value "YourAppName"
```

To set the bundle identifier, run the following command:

```bash
rename setBundleId --targets android --value "com.example.bundleId"
```

And Voila! You have successfully renamed the app. You are ready to start using this project to build next big video calling app.

## How to use this starter app?

General structure of the project is as follows:

```
└── 📁lib
    └── main.dart
    └── 📁pages
        └── meeting_page.dart
        └── 📁widgets
            └── 📁size
                └── app_size.dart
                └── size_config.dart
                └── size_util.dart
            └── 📁space
                └── space_token.dart
                └── vh_space.dart
    └── provider_logger.dart
    └── 📁riverpod
        └── dyte_room_notifier.dart
        └── riverpod.dart
        └── 📁states
            └── room_states.dart
    └── secrets.dart
    └── 📁theme
        └── app_theme.dart
```
- To start off, you can store your API keys in `secrets.dart` file. This file is added to `.gitignore` so that your API keys are not exposed to the public.

- You can use the `SizeConfig` class to get the screen size of the device. This class is used to make the app responsive across different devices.
    - You need to call `SizeConfig().init(context)` in the `build` method of your `MaterialApp` widget before using the `SizeConfig` class.

- You can use the `SpaceToken` class to get the space between widgets. This class is used to maintain the spacing between widgets across the app.

- You can use the `AppTheme` class to get the theme of the app. This class is used to maintain the theme of the app across the app. We have used `flex_color_scheme` package to maintain the theme of the app. Visit [flex_color_scheme](https://pub.dev/packages/flex_color_scheme) for more information.

Upcoming features:
- [ ] Write a basic dart wrapper over the Dyte's API.
- [ ] Add more reusable widgets to the `widgets` folder.