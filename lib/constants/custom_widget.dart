import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:safe_device/safe_device.dart';
import '../main.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../screens/tabs_Screen.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';

// bool isRealDevice = true;
bool isSafeDevice = true;
bool isDevelopmentModeEnable = true;

var baseurl='https://api.idlemine.io/';
// var baseurl='http://10.0.2.2:8082/';
// var baseurl='http://localhost:8082/';
// var baseurl = 'http://192.168.7.217/';
//'https://apinew.idlemine.io/';
//"https://api.idlemine.io/";
//"https://apitest.idlemine.io/";

Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

Widget customAppBar(BuildContext context, _scaffoldKey, balance, balance1v1) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    print("open");
                    _scaffoldKey.currentState.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.appcolordmiddark,
                    size: 40,
                  )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Single Player Balance",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "\$ ${balance}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.appcolordmiddark),
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset('assets/images/idleminesmall_icon.png',
                  width: 40, height: 40),
              Text(
                "V $version",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "1v1 Balance",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "\$ ${balance1v1}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.appcolordmiddark),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget SecondAppBar(BuildContext context, title, balance, balance1v1) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: SafeArea(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabScreen(
                            index: 0,
                          ),
                        ));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.appcolordmiddark,
                    size: 40,
                  )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Single Player Balance",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "\$ ${balance}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.appcolordmiddark),
                ),
              ),
            ],
          ),
          Spacer(),
          Text(title,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          Spacer(),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Image.asset('assets/images/idleminesmall_icon.png',
                  width: 40, height: 40),
              Text(
                "V $version",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "1v1 Balance",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "\$ ${balance1v1}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.appcolordmiddark),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

PlaySound(var soundFileName) async {
  AudioPlayer().play(AssetSource('sounds/${soundFileName}'));
}

StopSound() {
  AudioPlayer().pause();
}

Widget AppButton(onPressed, text) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.grey,
        backgroundColor: Color(0xffda286f),
        // side: BorderSide(color: Colors.yellow, width: 5),
        textStyle:
            const TextStyle(color: Colors.white, fontStyle: FontStyle.normal),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        shadowColor: Colors.pinkAccent,
        elevation: 3,
      ),
      onPressed: onPressed,
      child: SizedBox(height: 43, child: Center(child: Text(text))));
}

Widget CustomTextField(controller, hintext) {
  return TextFormField(
    controller: controller,
    textInputAction: TextInputAction.next,
    style: TextStyle(color: AppColors.white),
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white, width: 2)),
      disabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white, width: 2)),
      hintText: hintext,
      hintStyle: TextStyle(color: Colors.white70),
      contentPadding: EdgeInsets.all(8),
    ),
  );
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.appcolordmiddark,
      textColor: AppColors.white);
}

class AppSettingWidget extends StatelessWidget {
  final String appSettingTitle;
  final IconData icon;
  final Function(bool) onToggle;
  final bool? switchValue;

  const AppSettingWidget({
    super.key,
    this.appSettingTitle = "",
    required this.icon,
    required this.onToggle,
    this.switchValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.appcolordmiddark, size: 30),
          Spacer(),
          Text(
            appSettingTitle,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          FlutterSwitch(
            showOnOff: true,
            activeColor: AppColors.appcolordmiddark,
            inactiveColor: AppColors.midgrey,
            width: 75.0,
            height: 36.0,
            valueFontSize: 16.0,
            toggleSize: 35.0,
            borderRadius: 30.0,
            padding: 6,
            value: switchValue!,
            onToggle: onToggle,
          )
        ],
      ),
    );
  }
}

Future<bool> showExitPopup(context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit an App?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                SharedPreferencesFunctions().logout();
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                exit(0);
              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    StadiumBorder(),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    AppColors.appcolordmiddark,
                  )),
              child: Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    StadiumBorder(),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    AppColors.appcolordmiddark,
                  )),
              child: Text('No'),
            ),
          ],
        ),
      ) ??
      false;
}

showDialogBox(context) {
  showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () => Future.value(true),
      child: CupertinoAlertDialog(
        title: Text("No Internet Connection"),
        content: Text("Please Check your internet connectivity"),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context, "Cancel");
                isAlertSet = false;
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox(context);
                  isAlertSet = true;
                }
              },
              child: Text("Ok"))
        ],
      ),
    ),
  );
}

getConnectivity(Context) {
  print("getConnectivity");
  subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    print("isDeviceConnected=============>$isDeviceConnected");
    if (isDeviceConnected == false && isAlertSet == false) {
      Navigator.push(
          Context,
          MaterialPageRoute(
              builder: (context) => TabScreen(
                    index: 0,
                  )));
      showDialogBox(Context);
      print("device disconnect");
      isAlertSet = true;
    }
  });
}

NetworkCheck(Context) {
  print("getConnectivity");
  subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    print("isDeviceConnected=============>$isDeviceConnected");
    if (isDeviceConnected == false && isAlertSet == false) {
      showDialogBox(Context);
      print("device disconnect");
      isAlertSet = true;
    }
  });
}

//   isRealDevices(context) async {
//   try {
//     // isRealDevice = await SafeDevice.isRealDevice;
//     isSafeDevice = await SafeDevice.isSafeDevice;
//     isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
//   } catch (error) {
//     print(error);
//   }
//   // isRealDevice = isRealDevice;
//   isSafeDevice = isSafeDevice;
//   isDevelopmentModeEnable = isDevelopmentModeEnable;
//   print("isDevelopmentModeEnable====$isDevelopmentModeEnable");
//   print("checkBuildConfig${checkBuildConfig()}");
//   List<String> harmfulFoldersPaths = [
//     '/storage/emulated/0/storage/secure',
//     '/storage/emulated/0/Android/data/com.android.ld.appstore',
//   ];
//   if (await checkBuildConfig()||anyFolderExists(harmfulFoldersPaths)) {
//     showToast("This app is not workable on emulator");
//     exit(0);
//   }else if(isDevelopmentModeEnable==true){
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () => Future.value(false),
//           child: AlertDialog(
//             title: Text("Warning"),
//             content: Text("Please Disable Developer Options"),
//             actions: [
//               TextButton(onPressed: (){
//                 exit(0);
//               }, child: Text("Ok"))
//             ],
//           ),
//         );
//       },);
//   }else {
//     // showToast("this is real device");
//   }
// }

Future<bool> checkBuildConfig() async {
  AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
  bool isEmulator = (androidInfo.manufacturer.contains('Genymotion') ||
      androidInfo.manufacturer.contains('LDPlayer') ||
      androidInfo.manufacturer.contains('Memu') ||
      androidInfo.model.contains('google_sdk') ||
      androidInfo.model.toLowerCase().contains('droid4x') ||
      androidInfo.hardware.toLowerCase().contains('intel') ||
      androidInfo.host == 'ubuntu' && androidInfo.device == 'aosp' ||
      androidInfo.brand.startsWith("generic") &&
          androidInfo.device.startsWith("generic") ||
      androidInfo.fingerprint.startsWith("generic") ||
      androidInfo.fingerprint.startsWith("unknown") ||
      androidInfo.hardware.contains("goldfish") ||
      androidInfo.hardware.contains("ranchu") ||
      androidInfo.model.contains("google_sdk") ||
      androidInfo.model.contains("Emulator") ||
      androidInfo.model.contains("Android SDK built for x86") ||
      androidInfo.manufacturer.contains("Genymotion") ||
      androidInfo.product.contains("sdk_google") ||
      androidInfo.product.contains("google_sdk") ||
      androidInfo.product.contains("sdk") ||
      androidInfo.product.contains("sdk_x86") ||
      androidInfo.product.contains("vbox86p") ||
      androidInfo.product.contains("emulator") ||
      androidInfo.product.contains("simulator") ||
      Platform.isAndroid &&
          (androidInfo.model.contains('Emulator') ||
              androidInfo.model.contains('Android SDK built for x86') ||
              androidInfo.hardware == 'goldfish' ||
              androidInfo.hardware == 'vbox86' ||
              androidInfo.hardware.toLowerCase().contains('nox') ||
              androidInfo.product == 'sdk' ||
              androidInfo.product == 'google_sdk' ||
              androidInfo.product == 'sdk_x86' ||
              androidInfo.product == 'vbox86p' ||
              androidInfo.product.toLowerCase().contains('nox') ||
              androidInfo.board.toLowerCase().contains('nox') ||
              (androidInfo.board == 'QC_Reference_Phone') ||
              androidInfo.host.startsWith('Build') ||
              (androidInfo.brand.startsWith('generic') &&
                  androidInfo.device.startsWith('generic'))));
  return isEmulator;
}

bool anyFolderExists(List<String> foldersPaths) {
  for (String folderPath in foldersPaths) {
    if (Directory(folderPath).existsSync()) {
      return true;
    }
  }
  return false;
}
