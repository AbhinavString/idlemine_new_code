import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:idlemine_latest/utils/sharedPreferences.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'constants/custom_widget.dart';

import 'screens/login_screen.dart';

SharedPreferences? sharedPreferences;
StreamSubscription? subscription;
var version="1.3.11";
var isDeviceConnected=false;
var isAlertSet=false;
bool notificationStatus= SharedPreferencesFunctions().getNotification()==null?true:SharedPreferencesFunctions().getNotification()!;
bool Sound= SharedPreferencesFunctions().getSound()==null?true:SharedPreferencesFunctions().getSound()!;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(vsync: this, duration: Duration(seconds: 3))
    ..repeat();

  // bool isRealDevice = true;
  bool isSafeDevice = true;
  bool isDevelopmentModeEnable = false;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];



  @override
  void initState() {
    // isRealDevices(context);
    //secureScreen();
    NetworkCheck(context);
    super.initState();
    Timer(
        Duration(seconds: 4),
            () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } );
  }



  
  @override
  void dispose() {
    subscription!.cancel();
    _controller.stop(canceled: true);
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, cont) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: cont.maxHeight / 2 - 70),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: _controller.value * 2 * math.pi,
                                      child: child,
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/kling_newicon.png',
                                    height: 140,
                                    width: 130,
                                  ),
                                ),

                                padding: EdgeInsets.only(left: 20),
                              ),
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      'Welcome To',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'assets/fonts/Poppins-Bold',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: cont.maxWidth - 170,
                                    padding: EdgeInsets.only(left: 22),
                                    child: Text(
                                      'IdleMine',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'assets/fonts/Poppins-Bold',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Powered by Kling Blockchain',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'assets/fonts/Poppins-Bold',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }



}
