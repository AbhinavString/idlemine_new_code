import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:idlemine_latest/screens/sign_up.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:idlemine_latest/screens/verifyotp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../reposiratory/repo.dart';
import '../services/auth_methods.dart';
import '../utils/sharedPreferences.dart';
import 'activate_account.dart';
import 'forceupdate.dart';
import 'forget_password.dart';
import 'new_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = true;
  List<LoginData> loginDataList = [];
  // bool isRealDevice = true;
  bool isSafeDevice = true;
  bool isDevelopmentModeEnable = false;
  bool value = false;
  var isloading = false;
  final form_key = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var TemsCondition = "NotAccepted";
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  void initState() {
    //showinfo();
    // isRealDevices(context);
    NetworkCheck(context);
    super.initState();
    //secureScreen();
    sharedPreferences!.remove('status');
    sharedPreferences!.remove('Isloginstatus');
    sharedPreferences!.remove('Statuscode');
  }

  // showinfo() async {
  //   AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
  //   return showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return WillPopScope(
  //         onWillPop: () => Future.value(false),
  //         child: AlertDialog(
  //           title: Text("Warning"),
  //           content: Column(
  //             children: [
  //                Text("manufacturer====${androidInfo.manufacturer}"),
  //               Text("model====${androidInfo.model}"),
  //               Text("hardware====${androidInfo.hardware}"),
  //               Text("host====${androidInfo.host}"),
  //               Text("brand====${androidInfo.brand}"),
  //               Text("fingerprint====${androidInfo.fingerprint}"),
  //               Text("board====${androidInfo.board}"),
  //               Text("device====${androidInfo.device}"),
  //               Text("product====${androidInfo.product}"),
  //               Text("isPhysicalDevice====${androidInfo.isPhysicalDevice}"),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(onPressed: (){
  //               exit(0);
  //             }, child: Text("Ok"))
  //           ],
  //         ),
  //       );
  //     },);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
          ),
          child: Form(
            key: form_key,
            child: SingleChildScrollView(
              child: Container(
                color: isloading
                    ? Colors.transparent.withOpacity(0.3)
                    : Colors.transparent,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(top: 50),
                              child: Image.asset(
                                'assets/images/kling_newicon.png',
                                height: 100,
                                width: 130,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: email,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    new RegExp(r"\s\b|\b\s"))
                              ],
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintText: 'Enter your email',
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  fillColor: Colors.transparent),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // TextField(
                            //   textInputAction: TextInputAction.next,
                            //   controller: password,
                            //   obscureText: passwordVisible,
                            //   //textAlign: TextAlign.center,
                            //   style: TextStyle(color: Colors.white),
                            //   decoration: InputDecoration(
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //       borderSide:
                            //           BorderSide(width: 1, color: Colors.white),
                            //     ),
                            //     // fillColor: Colors.orange,
                            //     filled: true,
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //     ),
                            //     hintText: 'Password',
                            //     hintStyle: TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.white,
                            //     ),
                            //     contentPadding: EdgeInsets.all(10),
                            //     suffixIcon: IconButton(
                            //       icon: Icon(
                            //           passwordVisible
                            //               ? Icons.visibility_off
                            //               : Icons.visibility,
                            //           color: Colors.white),
                            //       onPressed: () {
                            //         setState(
                            //           () {
                            //             passwordVisible = !passwordVisible;
                            //           },
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),
                            TextField(
                              textInputAction: TextInputAction.next,
                              controller: password,
                              obscureText: passwordVisible,
                              //textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.white),
                                ),
                                // Remove fillColor and set filled to false to make the background transparent
                                filled: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                contentPadding: EdgeInsets.all(10),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ForgotPassword(
                                                ontap: "",
                                                email: null,
                                              )));
                                },
                                child: Container(
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            AppButton(() async {
                              if (email == null ||
                                  !regex.hasMatch(email.text) ||
                                  email.text.isEmpty) {
                                showToast('Please enter valid email');
                              } else if (password == null ||
                                  password.text.isEmpty) {
                                showToast('Your password is required');
                              } else {
                                setState(() {
                                  isloading = true;
                                });
                                getConnectivity(context);
                                await Repository()
                                    .loginData(
                                        email: email.text.trim(),
                                        password: password.text.trim(),
                                        context: context)
                                    .then((value) {
                                  setState(() {
                                    isloading = false;
                                  });
                                  print(
                                      "Repository().statusCode${Repository().statusCode}");
                                  if (SharedPreferencesFunctions()
                                          .getLoginStatuscode() ==
                                      "501") {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                ForceUpadatePage()));
                                  } else {
                                    value!.forEach((element) {
                                      SharedPreferencesFunctions()
                                          .saveLoginUserId(
                                              element.id.toString());
                                      loginDataList.add(element);
                                      print("registerDataList$loginDataList");
                                      if (SharedPreferencesFunctions()
                                              .getLoginStatus() ==
                                          "2") {
                                        showDialog(
                                              context: context,
                                              builder: (context) => Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: AlertDialog(
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  content: Text(
                                                    'Your Account is not activated. Please wait...',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  //contentTextStyle: TextStyle(fontSize: 18,),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ButtonStyle(
                                                          shape:
                                                              MaterialStatePropertyAll(
                                                            StadiumBorder(),
                                                          ),
                                                          minimumSize:
                                                              MaterialStatePropertyAll(
                                                                  Size(
                                                                      100, 40)),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.pink)),
                                                      child: Text('OK',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ) ??
                                            false;
                                      } else if (SharedPreferencesFunctions()
                                              .getLoginStatus() ==
                                          "3") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewPasswordPage()));
                                      } else {
                                        SharedPreferencesFunctions()
                                            .saveLoginUserId(
                                                element.id.toString());
                                        SharedPreferencesFunctions()
                                            .saveRegisterBy(
                                                element.registerBy.toString());
                                        SharedPreferencesFunctions()
                                            .saveLoginEmail(
                                                element.email.toString());
                                        SharedPreferencesFunctions()
                                            .saveLoginToken(
                                                element.token.toString());
                                        if (loginDataList.first.isConfirmed) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TabScreen(
                                                        index: 0,
                                                      )));
                                        } else {
                                          Repository()
                                              .ResendOtp(
                                                  email: email.text,
                                                  context: context)
                                              .then((value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VerifyOtpScreen(
                                                          email: email.text,
                                                        )));
                                          });
                                        }
                                      }
                                    });
                                  }
                                });
                              }
                            }, "LOG IN"),
                            SizedBox(
                              height: 20,
                            ),
                            Text("OR",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white70)),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () {
                                sharedPreferences!.remove('Statuscode');
                                getConnectivity(context);
                                AuthMethods().signInWithGoogle(
                                  context,
                                );
                              },
                              child: SizedBox(
                                height: 43,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Image(
                                        image: AssetImage(
                                            "assets/images/google_logo.png"),
                                        height: 27,
                                        width: 27,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, right: 8),
                                        child: Text(
                                          'Log-in with Google',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .04),
                                    child: Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .04,
                                          left: 10),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Color(0xffda286f),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .04),
                                    child: Text(
                                      'Activate Account ?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivateAccount()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .04,
                                          left: 10),
                                      child: Text(
                                        ' Activate',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Color(0xffda286f),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    isloading
                        ? Positioned.fill(
                            child: Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
