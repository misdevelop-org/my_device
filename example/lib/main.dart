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
      title: 'My Device',
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
  @override
  Widget build(BuildContext context) {
    // Set the responsive breakpoints
    DeviceManager.configure(
      context: context,
      responsiveBreakpoints: const ResponsiveBreakpoints(
        mobile: 500,
        desktop: 1000,
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
      ),
    );

    // Or set a custom function after the configure
    DeviceManager.onConnectionLost = () {
      print('Connection lost');
    };

    DeviceManager.onConnectionReestablished = () {
      print('Connection reestablished');
    };

    DeviceManager.onConnectivityChanged = (connectivity) {
      print('Connectivity changed: $connectivity');
    };

    //Get the MediaQuery from the given context
    final mediaQuery = DeviceManager.mediaQuery;

    // Get the device screen height
    final screenHeight = DeviceManager.screenHeight;

    // Get the device screen width
    final screenWidth = DeviceManager.screenWidth;

    // You can also use the context directly to get width and height
    final width = context.width;
    final height = context.height;

    // Padding from physical hinges or islands
    var padding = DeviceManager.viewPadding;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('My device - ${DeviceManager.platformName}  '),
            Icon(DeviceManager.platformIcon, color: Colors.black),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFc1c1c1),
      body: Stack(
        children: <Widget>[
          Padding(padding: padding),
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: Text(
                      'Device Pixel Ratio: ' + mediaQuery.devicePixelRatio.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ), //Pixel ratio
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: screenWidth / 2.3,
                    child: Card(
                        color: Colors.teal.withOpacity(.96),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Screen Width: ' + screenWidth.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '\nScreen Height: ' + screenHeight.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '\nDevice Orientation: ' + mediaQuery.orientation.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )),
                  ), //teal container
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: width / 2.3,
                        child: Card(
                          color: Colors.amber[700]!.withOpacity(.96),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Connectivity: ' + DeviceManager.connectivity.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 2.3,
                        child: Card(
                          color: Colors.green[700]!.withOpacity(.96),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Text(
                                'View type: ' +
                                    (DeviceManager.isDesktopView
                                        ? 'Desktop'
                                        : DeviceManager.isTabletView
                                            ? 'Tablet'
                                            : 'Mobile'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Text(
                                "\nBreakpoints>>>\nDesktop: 1000\nMobile: 500",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ), //Yellow container
                ],
              ), //Teal & yellow containers
              SizedBox(
                height: height / 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: ListView(
                    children: [
                      displayEntry(context.deviceInfo!),
                    ],
                  )),
                ),
              ), //Device Info
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
    if (e == null) {
      return ListTile(
        title: Text(key ?? ''),
      );
    }
    return ListTile(
      subtitle: Text(key ?? ''),
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
