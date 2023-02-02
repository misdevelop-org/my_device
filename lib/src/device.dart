import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_device/src/platform.dart';

///Access to device information and internet connection
class Device {
  ///Image Background Path
  String backgroundAssetPath = '';

  ///Device screen height
  double screenHeigth = 0;

  ///Device screen width
  double screenWidth = 0;

  ///Is Web environment
  bool isWeb = false;

  ///Is native Android
  bool isAndroid = false;

  ///Is native IOS
  bool isIOS = false;

  ///Is Tablet size
  bool isTablet = false;

  ///Default padding of handle bars, notches and others
  EdgeInsets viewPadding = EdgeInsets.zero;

  ///Device MediaQuery easy access
  late MediaQueryData mediaQuery;

  ///Must be initialized every time you need to refresh the information
  late BuildContext context;

  ///All information from Device Info Plugin
  Map<String, dynamic>? deviceInfo;

  ///Internet connection state
  ///Has 3 types of connection:
  ///Wifi, mobile, none
  ConnectivityResult? connectivity;

  ///Shorter access to instance
  static Device get i => instance;

  ///Hold all device information
  static final Device instance = Device._internal();

  Device._internal();

  ///Internet connection alerts
  static setConnectivity(ConnectivityResult connect) {
    if (connect == ConnectivityResult.none && instance.connectivity != ConnectivityResult.none) {
      showText(instance.context, "No internet connection", '', seconds: 4, backgroundColor: Colors.amber[800]);
    }

    if (connect != ConnectivityResult.none && instance.connectivity == ConnectivityResult.none) {
      showText(instance.context, "Connection reestablish!", '', seconds: 2, backgroundColor: Colors.green[800]);
    }

    instance.connectivity = connect;
  }

  ///Set connectivity
  static setBack(ConnectivityResult connect) {
    instance.connectivity = connect;
  }

  factory Device(context, {String? assetBackground}) {
    instance.context = context;

    instance.mediaQuery = MediaQuery.of(context);
    instance.screenWidth = MediaQuery.of(context).size.width;
    instance.screenHeigth = MediaQuery.of(context).size.height;
    instance.viewPadding = MediaQuery.of(context).viewPadding;
    instance.isWeb = kIsWeb;
    instance.isAndroid = kIsWeb ? false : Platform.isAndroid;
    instance.isIOS = kIsWeb ? false : Platform.isIOS;
    instance.isTablet =
        (sqrt((instance.screenWidth * instance.screenWidth) + (instance.screenHeigth * instance.screenHeigth))) > 1100;
    instance.backgroundAssetPath = 'assets/triangleDarkPattern.jpg';
    getInfo();
    if (assetBackground != null) instance.backgroundAssetPath = assetBackground;
    return instance;
  }
  static Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
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
    instance.deviceInfo = await getDeviceInfo();
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
