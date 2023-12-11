import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_device/src/connectivity_configure.dart';
import 'package:my_device/src/platform.dart';
import 'package:my_device/src/responsive_breakpoints.dart';

///Access to device information and internet connection
class DeviceManager {
  static bool get isDesktopView => width >= responsiveBreakpoints.desktop;
  static bool get isTabletView =>
      width >= responsiveBreakpoints.mobile &&
      width < responsiveBreakpoints.desktop;
  static bool get isPhoneView => width < responsiveBreakpoints.mobile;
  static double get width => MediaQuery.of(context).size.width;
  static double get height => MediaQuery.of(context).size.height;

  ///Responsive breakpoints
  ResponsiveBreakpoints _responsiveBreakpoints = const ResponsiveBreakpoints();

  ///Is native Web
  bool _isWeb = false;

  ///Is native Android
  bool _isAndroid = false;

  ///Is native IOS
  bool _isIOS = false;

  ///Is native MacOS
  bool _isMacOS = false;

  ///Is native Windows
  bool _isWindows = false;

  ///Is native Linux
  bool _isLinux = false;

  ///Must be initialized every time you need to refresh the information
  late BuildContext _context;

  ///All information from Device Info Plugin
  Map<String, dynamic>? _deviceInfo;

  ///Internet connection state
  ///Has 3 types of connection:
  ///Wifi, mobile, none
  ConnectivityResult? _connectivity;

  ///Connectivity configuration
  ConnectivityConfigure? _connectivityConfigure;

  // Getters

  ///Device screen height
  static double get screenHeight => MediaQuery.of(context).size.height;

  ///Device screen width
  static double get screenWidth => MediaQuery.of(context).size.width;

  ///Is Web environment
  static bool get isWeb => DeviceManager.i._isWeb;

  ///Is native Android
  static bool get isAndroid => DeviceManager.i._isAndroid;

  ///Is native IOS
  static bool get isIOS => DeviceManager.i._isIOS;

  ///Is native MacOS
  static bool get isMacOS => DeviceManager.i._isMacOS;

  ///Is native Windows
  static bool get isWindows => DeviceManager.i._isWindows;

  ///Is native Linux
  static bool get isLinux => DeviceManager.i._isLinux;

  ///Default padding of handle bars, notches and others
  static EdgeInsets get viewPadding => MediaQuery.of(context).viewPadding;

  ///Device MediaQuery easy access
  static MediaQueryData get mediaQuery => MediaQuery.of(context);

  ///All information from Device Info Plugin
  static Map<String, dynamic>? get deviceInfo => DeviceManager.i._deviceInfo;

  ///Internet connection state
  ///Has 3 types of connection:
  ///Wifi, mobile, none
  static ConnectivityResult? get connectivity => DeviceManager.i._connectivity;

  ///context getter
  static BuildContext get context => DeviceManager.i._context;

  ///Responsive breakpoints
  static ResponsiveBreakpoints get responsiveBreakpoints =>
      DeviceManager.i._responsiveBreakpoints;

  ///Current platform name
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'IOS';
    if (isMacOS) return 'MacOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  ///Current platform icon
  static IconData get platformIcon {
    if (isWeb) return Icons.web_rounded;
    if (isAndroid) return Icons.android_rounded;
    if (isIOS) return Icons.apple_rounded;
    if (isMacOS) return Icons.desktop_mac_rounded;
    if (isWindows) return Icons.laptop_windows_rounded;
    if (isLinux) return Icons.laptop_chromebook_rounded;
    return Icons.help_rounded;
  }

  ///Shorter access to instance
  static DeviceManager get device => DeviceManager.i;

  ///Shorter access to instance
  static DeviceManager get i => instance;

  //Setters

  ///On connection lost callback
  static set onConnectionLost(Function callback) {
    instance._connectivityConfigure =
        instance._connectivityConfigure?.copyWith(onConnectionLost: callback) ??
            ConnectivityConfigure(onConnectionLost: callback);
  }

  ///On connection reestablished callback
  static set onConnectionReestablished(Function callback) {
    instance._connectivityConfigure = instance._connectivityConfigure
            ?.copyWith(onConnectionReestablished: callback) ??
        ConnectivityConfigure(onConnectionReestablished: callback);
  }

  ///On connectivity changed callback
  static set onConnectivityChanged(
      Function(ConnectivityResult result) callback) {
    instance._connectivityConfigure = instance._connectivityConfigure
            ?.copyWith(onConnectivityChanged: callback) ??
        ConnectivityConfigure(onConnectivityChanged: callback);
  }

  ///Use default behavior
  static set useDefaultBehavior(bool value) {
    instance._connectivityConfigure =
        instance._connectivityConfigure?.copyWith(useDefaultBehavior: value) ??
            ConnectivityConfigure(useDefaultBehavior: value);
  }

  ///Hold all device information
  static final DeviceManager instance = DeviceManager._internal();

  DeviceManager._internal();

  ///Internet connection alerts
  static setConnectivity(ConnectivityResult connect) {
    if (connect == ConnectivityResult.none &&
        instance._connectivity != ConnectivityResult.none) {
      if (instance._connectivityConfigure?.useDefaultBehavior ?? false) {
        showText(context, "No internet connection", '',
            seconds: 4, backgroundColor: Colors.amber[800]);
      } else {
        instance._connectivityConfigure?.onConnectionLost?.call();
      }
    }

    if (connect != ConnectivityResult.none &&
        instance._connectivity == ConnectivityResult.none) {
      if (instance._connectivityConfigure?.useDefaultBehavior ?? false) {
        showText(context, "Connection reestablish!", '',
            seconds: 2, backgroundColor: Colors.green[800]);
      } else {
        instance._connectivityConfigure?.onConnectionReestablished?.call();
      }
    }

    instance._connectivity = connect;
  }

  static void configure({
    BuildContext? context,
    ResponsiveBreakpoints? responsiveBreakpoints,
    ConnectivityConfigure? connectivityConfigure,
  }) async {
    await _init(context, responsiveBreakpoints, connectivityConfigure);
    listenConnectivityChanges();
  }

  static void listenConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setConnectivity(result);
      instance._connectivityConfigure?.onConnectivityChanged?.call(result);
    });
  }

  static Future<void> _init(
    BuildContext? context,
    ResponsiveBreakpoints? responsiveBreakpoints,
    ConnectivityConfigure? connectivityConfigure,
  ) async {
    if (context != null) instance._context = context;
    if (responsiveBreakpoints != null)
      instance._responsiveBreakpoints = responsiveBreakpoints;
    if (connectivityConfigure != null)
      instance._connectivityConfigure = connectivityConfigure;
    instance._isWeb = kIsWeb;
    instance._isAndroid = kIsWeb ? false : Platform.isAndroid;
    instance._isIOS = kIsWeb ? false : Platform.isIOS;
    instance._isMacOS = kIsWeb ? false : Platform.isMacOS;
    instance._isWindows =
        kIsWeb ? false : TargetPlatform.windows == defaultTargetPlatform;
    instance._isLinux =
        kIsWeb ? false : TargetPlatform.linux == defaultTargetPlatform;
    getInfo();
    instance._connectivity = await Connectivity().checkConnectivity();
  }

  factory DeviceManager(
    context, {
    ResponsiveBreakpoints? responsiveBreakpoints,
    ConnectivityConfigure? connectivityConfigure,
  }) {
    _init(context, responsiveBreakpoints, connectivityConfigure);
    return instance;
  }
  static Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  static getInfo() async {
    instance._deviceInfo = await getDeviceInfo();
  }

  ///Device info depending on the actual platform
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    Map<String, dynamic> deviceInfoData = {};
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    deviceInfoData['lastConnection'] = DateTime.now().toString();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      if (kDebugMode) {
        print('Running on ${webBrowserInfo.userAgent}');
      }
      deviceInfoData['infoDevice'] = _readWebBrowserInfo(webBrowserInfo);
      deviceInfoData['id'] = webBrowserInfo.userAgent;
    } else {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (kDebugMode) {
          print('Running on ${androidInfo.model}');
        }

        deviceInfoData['infoDevice'] = androidInfo.data;
        deviceInfoData['id'] = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        if (kDebugMode) {
          print('Running on ${iosInfo.data}');
        }

        deviceInfoData['infoDevice'] = iosInfo.data;
        deviceInfoData['id'] = iosInfo.identifierForVendor;
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;

        if (kDebugMode) {
          print('Running on ${macInfo.data}');
        }

        deviceInfoData['infoDevice'] = macInfo.data;
        deviceInfoData['id'] = macInfo.systemGUID;
      }
    }
    return deviceInfoData;
  }

  static void showText(BuildContext context, String title, String subtitle,
      {required int seconds, Color? backgroundColor}) {
    //Show dialog
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
      duration: Duration(seconds: seconds),
      backgroundColor: backgroundColor,
    ));
  }
}

extension DeviceExtension on BuildContext {
  ///Device screen height
  double get screenHeight => DeviceManager.screenHeight;

  ///Device screen width
  double get screenWidth => DeviceManager.screenWidth;

  ///Device screen height
  double get height => DeviceManager.height;

  ///Device screen width
  double get width => DeviceManager.width;

  ///Is Web environment
  bool get isWeb => DeviceManager.isWeb;

  ///Is native Android
  bool get isAndroid => DeviceManager.isAndroid;

  ///Is native IOS
  bool get isIOS => DeviceManager.isIOS;

  ///Is native MacOS
  bool get isMacOS => DeviceManager.isMacOS;

  ///Is native Windows
  bool get isWindows => DeviceManager.isWindows;

  ///Is native Linux
  bool get isLinux => DeviceManager.isLinux;

  ///Default padding of handle bars, notches and others
  EdgeInsets get viewPadding => DeviceManager.viewPadding;

  ///Device MediaQuery easy access
  MediaQueryData get mediaQuery => DeviceManager.mediaQuery;

  ///All information from Device Info Plugin
  Map<String, dynamic>? get deviceInfo => DeviceManager.deviceInfo;

  ///Internet connection state
  ///Has 3 types of connection:
  ///Wifi, mobile, none
  ConnectivityResult? get connectivity => DeviceManager.connectivity;

  ///Shorter access to instance
  DeviceManager get device => DeviceManager.i;
}
