<img src='https://firebasestorage.googleapis.com/v0/b/misdevelop.appspot.com/o/my_device%2FPackages%20pub.dev%204.png?alt=media&token=7567b5b0-4c7c-48d7-8d7d-adcf794fe8c3' alt='My Device from MIS Develop'>
  
## Features
    
Agile & easy handler for device information 📱

Includes Device Info Plus ℹ️ and Connectivity Plus 🛜 implementations

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  my_device: ^0.1.0
```

In your library add the following import:

```dart
import 'package:my_device/my_device.dart';
```

Once context is initialized, do the following to initialize the DeviceManager instance:

```dart
  DeviceManager(context);
```

You can also use the configure method to initialize the DeviceManager instance, responsive breakpoints and Connectivity configuration:

```dart
  DeviceManager.configure(
    context: context,
    responsiveBreakpoints: const ResponsiveBreakpoints(
      mobile: 400, //Default is 500
      desktop: 1000, //Default is 900
    ),
    connectivityConfigure: ConnectivityConfigure(
      onConnectivityChanged: (connectivity) {
        print('Connectivity changed: $connectivity');
      },
      onConnectionLost: () {
        print('Connection lost');
      },
      onConnectionReestablished: () {
        print('Connection reestablished');
      },
      useDefaultBehaviour: true // Shows a default toast when set to true
    ),
  );
  // Mobile view < mobile
  // Tablet view > mobile && < desktop
  // Desktop view > desktop
```

## Usage
### Any method can be accessed through the DeviceManager instance or through the `context` extension
#### Getters for screen height and width
```dart
  final screenHeight = DeviceManager.screenHeight;
  final screenWidth = DeviceManager.screenWidth;
  final height = DeviceManager.height;
  final width = DeviceManager.width;
  final heightFromContext = context.height;
  final widthFromContext = context.width;
```

#### Getters for responsive sizes (dependent of the configured responsive breakpoints)
```dart
  final isPhoneView = DeviceManager.isPhoneView; // width < mobile
  final isTabletView = DeviceManager.isTabletView; // mobile <= width < desktop
  final isDesktopView = DeviceManager.isDesktopView; // width >= desktop
```

#### Simple methods for platform information
```dart
  final isWeb = DeviceManager.isWeb;
  final isAndroid = DeviceManager.isAndroid;
  final isIOS = DeviceManager.isIOS;
  final isMacOS = DeviceManager.isMacOS;
  final isLinux = DeviceManager.isLinux;
  final isWindows = DeviceManager.isWindows;

  final platformName = DeviceManager.platformName;
  final platformIcon = DeviceManager.platformIcon;
```

#### Direct method for device default padding
```dart
 final padding = DeviceManager.viewPadding;
 final paddingFromContext = context.viewPadding;
```

#### Connectivity Plus methods
##### Get the current status
```dart
  final connectivity = DeviceManager.connectivity;
  final connectivityFromContext = context.connectivity;
```
##### Listen on connectivity changes
```dart
  DeviceManager.listenConnectivityChanges();
```
##### Set any custom connectivity method after configure callback
```dart
  DeviceManager.onConnectionLost = () {
      print('Connection lost');
  };

  DeviceManager.onConnectionReestablished = () {
    print('Connection reestablished');
  };

  DeviceManager.onConnectivityChanged = (connectivity) {
    print('Connectivity changed: $connectivity');
  };
```

#### Device Info Plus shortened method
 
```dart
  final deviceInfo = DeviceManager.deviceInfo;
```


   
## Additional information
 This package assumes corresponding permissions depending on platform