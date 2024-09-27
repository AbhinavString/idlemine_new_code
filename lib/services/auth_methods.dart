
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/custom_widget.dart';
import '../models/login_model.dart';
import '../reposiratory/repo.dart';
import '../screens/activate_account.dart';
import '../screens/forceupdate.dart';
import '../screens/home.dart';
import '../screens/login_screen.dart';
import '../screens/new_password.dart';
import '../screens/tabs_Screen.dart';
import '../screens/verifyotp.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<LoginData> loginDataList = [];
  List<LoginData> registerDataList = [];

  Future signUpWithGoogle(
      BuildContext context,
      ) async {
    NetworkCheck(context);
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    ///new code

    try {
      var result = await googleSignIn.signIn();
      ///new code
      if (result != null) {
        print(result.email);

        await Repository().Register(email: result.email,password: result.id.toString(),registerBy: "1",context: context)
            .then(
              (value) {
                 print("valueeeeee signUpWithGoogle ==========${value}");
                if(SharedPreferencesFunctions().getLoginStatuscode()=="501"){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>  ForceUpadatePage()));
                }else {
                if (value == null || value.isEmpty) {
                  showToast("This Email already exists");
                  logOutFromGoogle();
                }
                else {
                  print("value==========${value}");
                  value!.forEach(
                          (element) {
                        registerDataList.add(element);
                        print("element==========$element");
                        SharedPreferencesFunctions().saveLoginUserId(
                            element.id.toString());
                        SharedPreferencesFunctions().saveLoginEmail(
                            element.email.toString());
                        SharedPreferencesFunctions().saveRegisterBy(
                            element.registerBy.toString());
                        SharedPreferencesFunctions().saveLoginToken(element.token.toString());
                        Repository().ResendOtp(
                            email: result.email, context: context).then((
                            value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VerifyOtpScreen(email: result.email,)));
                        });

                        // ignore: use_build_context_synchronously

                      });
                }
              }
              });
      } else {
        // ignore: use_build_context_synchronously
        showToast("Something Went Wrong!");
      }
    } catch (e) {
      print( e.toString());
      showToast(
        e.toString(),
      );
    }
  }



  Future signInWithGoogle(
      BuildContext context,
      ) async {
    NetworkCheck(context);
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    try {
      var result = await googleSignIn.signIn();
      ///new code


      if (result != null) {
        print(result);

        await Repository()
            .loginData(email: result.email,password: result.id.toString(),context: context)
            .then(
                (value) {
                   print("signInWithGoogle==========${value}");
                  if(SharedPreferencesFunctions().getLoginStatuscode()=="501"){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>  ForceUpadatePage()));
                  }else {
                   if (value == null || value.isEmpty) {
                     print(
                         "SharedPreferencesFunctions().getLoginStatus()${SharedPreferencesFunctions()
                             .getLoginStatus()}");
                     if (SharedPreferencesFunctions().getLoginStatus() == "2") {
                       showDialog(
                         context: context,
                         builder: (context) =>
                             Container(
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10)),
                               child: AlertDialog(
                                 actionsAlignment: MainAxisAlignment
                                     .spaceAround,
                                 content: Text(
                                   'Your Account is not activated. Please wait...',
                                   textAlign: TextAlign.center,
                                   style: TextStyle(fontSize: 18,),),
                                 //contentTextStyle: TextStyle(fontSize: 18,),
                                 actions: [
                                   ElevatedButton(
                                     onPressed: () {
                                       Navigator.pop(context);
                                     },
                                     style: ButtonStyle(
                                         shape: MaterialStatePropertyAll(
                                           StadiumBorder(),
                                         ),
                                         minimumSize: MaterialStatePropertyAll(
                                             Size(100, 40)),
                                         backgroundColor: MaterialStatePropertyAll(
                                             Colors.pink
                                         )),
                                     child: Text('OK',
                                         style: TextStyle(color: Colors.white)),
                                   ),
                                 ],
                               ),
                             ),
                       ) ?? false;
                     }
                     else {
                       //showToast("Email/Password is Incorrect");
                       logOutFromGoogle();
                     }
                   }
                   else {
                     print('login');
                     value!.forEach(
                             (element) {
                           loginDataList.add(element);

                           SharedPreferencesFunctions().saveLoginUserId(
                               element.id.toString());

                           if (SharedPreferencesFunctions().getLoginStatus() ==
                               "2") {
                             showDialog(
                               context: context,
                               builder: (context) =>
                                   Container(
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(
                                             10)),
                                     child: AlertDialog(
                                       actionsAlignment: MainAxisAlignment
                                           .spaceAround,
                                       content: Text(
                                         'Your Account is not activated. Please wait...',
                                         textAlign: TextAlign.center,
                                         style: TextStyle(fontSize: 18,),),
                                       //contentTextStyle: TextStyle(fontSize: 18,),
                                       actions: [
                                         ElevatedButton(
                                           onPressed: () {
                                             Navigator.pop(context);
                                           },
                                           style: ButtonStyle(
                                               shape: MaterialStatePropertyAll(
                                                 StadiumBorder(),
                                               ),
                                               minimumSize: MaterialStatePropertyAll(
                                                   Size(100, 40)),
                                               backgroundColor: MaterialStatePropertyAll(
                                                   Colors.pink
                                               )),
                                           child: Text('OK', style: TextStyle(
                                               color: Colors.white)),
                                         ),
                                       ],
                                     ),
                                   ),
                             ) ?? false;
                           }
                           else
                           if (SharedPreferencesFunctions().getLoginStatus() ==
                               "3") {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => NewPasswordPage()));
                           }
                           else {
                             SharedPreferencesFunctions().saveLoginEmail(
                                 element.email.toString());
                             SharedPreferencesFunctions().saveRegisterBy(
                                 element.registerBy.toString());
                             SharedPreferencesFunctions().saveLoginToken(
                                 element.token.toString());
                             if (loginDataList.first.isConfirmed) {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) =>
                                           TabScreen(index: 0,)));
                             } else {
                               Repository().ResendOtp(
                                   email: result.email, context: context).then((
                                   value) {
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             VerifyOtpScreen(
                                               email: result.email,)));
                               });
                             }
                             showToast("Gmail Login Sucessfull.");
                           }
                         });
                   }
                 }
            });



      } else {
        // ignore: use_build_context_synchronously
        showToast("Something Went Wrong!");
      }
    } catch (e) {
      print( e.toString());
      showToast(
        e.toString(),
      );
    }
  }

  ///Phone Logout
  Future logoutFromPhone() async {
    await FirebaseAuth.instance.signOut();
  }

  ///Gmail Logout
  Future logOutFromGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }



  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }


}
