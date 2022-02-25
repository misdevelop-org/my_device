import 'package:flutter/material.dart';
import 'package:my_device/my_device.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'my_Device',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> deviceInfo = {};
  @override
  void initState() {
    super.initState();

    l();
  }

  l() async {
    deviceInfo = await Device.getDeviceInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Device(context, assetBackground: 'assets/background.png');
    var device = Device.instance.mediaQuery;
    var screenHeigth = Device.i.screenHeigth;
    var screenWidth = Device.i.screenWidth;
    var backgroundAssetPath = Device.i.backgroundAssetPath;
    var padding = Device.i.viewPadding;
    var webDevice = Device.i.isWeb;
    var androidDevice = Device.i.isAndroid;
    var iosDevice = Device.i.isIOS;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My device'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              if (androidDevice)
                const Icon(
                  Icons.android_rounded,
                  color: Colors.white,
                ),
              if (iosDevice) const Text('IOS'),
              if (webDevice) const Text('Web'),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF040029),
      body: Stack(
        children: <Widget>[
          Padding(padding: padding),
          Center(child: Image.asset(backgroundAssetPath)),
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: ListView(
                    children: [
                      displayEntry(deviceInfo),
                    ],
                  )),
                ),
              ), //Device Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                      child: Padding(
                    padding:
                        const EdgeInsets.only(left: 55, right: 55, top: 14),
                    child: Text(
                      'Device Pixel Ratio: ' +
                          device.devicePixelRatio.toString(),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ),
              ), //Pixel ratio
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: screenWidth / 2.3,
                      height: screenHeigth / 2.6,
                      child: Card(
                        color: Colors.teal.withOpacity(.96),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ), //teal container
                    SizedBox(
                      width: screenWidth / 2.3,
                      height: screenHeigth / 2.6,
                      child: Card(
                        color: Colors.amber[700]!.withOpacity(.96),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ), //Yellow container
                  ],
                ),
              ), //Teal & yellow containers
            ],
          ),
        ],
      ),
    );
  }

  Widget displayEntry(Map e) {
    List<Widget> aux = [];
    for (var key in e.keys) {
      aux.add(buildEntry(key, e[key]));
    }
    return Column(children: aux);
  }
}

Widget buildEntry(key, e) {
  if (e is! Map) {
    return ListTile(
      subtitle: Text(key),
      title: Text(e.toString()),
    );
  } else {
    List<Widget> children = [];
    for (var key in e.keys) {
      children.add(buildEntry(key, e[key]));
    }
    return Column(children: children);
  }
}
