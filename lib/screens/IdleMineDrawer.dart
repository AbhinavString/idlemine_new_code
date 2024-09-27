import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/play2earn.dart';
import 'package:idlemine_latest/screens/refferal_screen.dart';
import 'package:idlemine_latest/screens/screen_webcontent.dart';
import 'package:idlemine_latest/screens/user_history.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getprofile_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'DepositScreen.dart';
import 'DepositeTabs.dart';
import 'account_delete.dart';
import 'free2play.dart';
import 'globalranking_tabs.dart';
import 'globalranking_tabs_paid.dart';
import 'instructions.dart';
import 'login_screen.dart';
import 'onevone_history.dart';



class IdleMineDrawer extends StatefulWidget {
  const IdleMineDrawer({Key? key}) : super(key: key);

  @override
  State<IdleMineDrawer> createState() => _IdleMineDrawerState();
}

class _IdleMineDrawerState extends State<IdleMineDrawer> {
  var selectedImage="";
  List<GetProfileModel> profileData=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //secureScreen();
    sharedPreferences!.remove('ResetStatus');
    Repository().getProfile(userId: SharedPreferencesFunctions().getLoginUserId()!,context: context).then(
            (value) {
          print('getGameList');
          value!.forEach(
                  (element) {
                print("elementtttt$element");
                setState(() {
                  profileData.add(element);
                  selectedImage=profileData.first.profile;
                });
                print("profileData=============$profileData");
              });
        });
  }
  @override
  Widget build(BuildContext context) {
    var ResetStatus;
    bool passwordVisible1=true;
    bool passwordVisible2=true;
    bool passwordVisible3=true;
    final _formKey = GlobalKey<FormState>();
    var _oldpassword= TextEditingController();
    var _newPassword= TextEditingController();
    var _Confirm= TextEditingController();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85, //20.0,
      child: Drawer(
          child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: new AssetImage('assets/images/bg.png'),
              ),
            ),
            child: ListView(
              shrinkWrap: false,
              children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                          width: 70,
                          child:
                          (selectedImage!= "")
                              ? Image.network(selectedImage) :
                          Image.asset("assets/images/sampleprofilenew.png"),
                        ),
                        Container(
                          height: 65,
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'IdleMine', // 'IdleMine (Kling)',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent.withOpacity(.0),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/wallet.png",
                      height: 40,
                      width: 40,
                    ),
                    //tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Deposit",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new DepositeTabsScreen()));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/history_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Wallet History",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new HistoryTabs(route: "",)));
                    },
                  ),
                ),

                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/history_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "1v1 Wallet History",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new HistoryTabs(route: "1v1",)));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/history_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Play 2 Earn History",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new PlayTwoEarn()));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/history_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Free 2 Play History",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>  FreeTwoPlay()));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/history_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "1V1 History",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>  OneVOneHistory()));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/referalnav.png",
                      height: 25,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Referral",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new Referralscreen()));
                    },
                  ),
                ),

                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/referalnav.png",
                      height: 25,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Instruction",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new InstructionPage()));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/eula_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Eula",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                              new ScreenWithWebContent("eula")));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/about_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "About",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                              new ScreenWithWebContent("about")));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(Icons.question_answer,color: Colors.pink),
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "FAQ",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      launchUrlString("https://idlemine.io/FAQ.html");
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/start_game.png",
                      height: 20,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Global Ranking(Free Game)",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new GlobalRankTabs()));
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/start_game.png",
                      height: 20,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Global Ranking(Paid Game)",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new GlobalRankPaidtabs()));
                    },
                  ),
                ),
                SharedPreferencesFunctions().getRegisterBy()=="0"?
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/acc_deletion_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Reset Password",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.black),
                            )),
                        content: SingleChildScrollView(
                          child: Container(
                            //height: MediaQuery.of(context).size.height/3,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  new TextFormField(
                                      controller: _oldpassword,
                                      autofocus: true,
                                      obscureText: passwordVisible1,
                                      decoration: new InputDecoration(
                                        labelStyle: TextStyle(color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black )),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black )),
                                        labelText: 'Old Password',
                                      ),
                                      onChanged: (value) {
                                        //passwordReceivedOnEmail = value;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter Your Old Password';
                                        }
                                      }
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _newPassword,
                                    obscureText: passwordVisible2,
                                    autofocus: true,
                                    decoration:
                                    new InputDecoration(
                                      labelStyle: TextStyle(color: Colors.black),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black )),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black )),
                                      labelText: 'New Password',
                                      ),
                                    onChanged: (value) {
                                      // newPassword = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your New Password';
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _Confirm,
                                    obscureText: passwordVisible3,
                                    autofocus: true,
                                    decoration:
                                    new InputDecoration(
                                      labelStyle: TextStyle(color: Colors.black),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black )),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black )),
                                      labelText: 'Confirm Password',
                                    ),
                                    onChanged: (value) {
                                      // newPassword = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Your New Password';
                                      } else if (value != _newPassword.text)
                                        return "Password does not match";
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            height: 40,
                            //width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                        StadiumBorder(side: BorderSide(color: Colors.pink)),
                                      ),
                                      minimumSize: MaterialStatePropertyAll(Size(100, 40)),
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.white,
                                      )),
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.pink),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                        StadiumBorder(),
                                      ),
                                      minimumSize: MaterialStatePropertyAll(Size(100, 40)),
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.pink,
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()){
                                      Repository().resetPasswordApi(newpassword: _Confirm.text,oldpassword: _oldpassword.text,userId: SharedPreferencesFunctions().getLoginUserId().toString(),context: context).
                                      then((value) async {
                                        ResetStatus =SharedPreferencesFunctions().getResetStatus();

                                        if (ResetStatus == "1") {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            // dialog is dismissible with a tap on the barrier
                                            builder: (
                                                BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                    "Your Password has been reset successfully. Please Login again",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator
                                                          .pushReplacement(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  LoginScreen()));
                                                      final prefs = await SharedPreferences
                                                          .getInstance();
                                                      prefs.clear();
                                                      SharedPreferencesFunctions().logout();
                                                      await FirebaseAuth.instance.signOut();
                                                      GoogleSignIn googleSignIn = GoogleSignIn();
                                                      await googleSignIn.signOut();
                                                    },
                                                    style: ButtonStyle(
                                                        shape: MaterialStatePropertyAll(
                                                          StadiumBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .pink)),
                                                        ),
                                                        minimumSize: MaterialStatePropertyAll(
                                                            Size(100, 40)),
                                                        backgroundColor: MaterialStatePropertyAll(
                                                          Colors.white,
                                                        )),
                                                    child: Text('OK',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .pink)),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      });
                                    }
                                  },
                                  child: const Text('Reset Password',
                                      style: TextStyle(
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ):SizedBox.shrink(),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/acc_deletion_drawer.png",
                      height: 40,
                      width: 40,
                    ),
                    tileColor: Colors.transparent,
                    textColor: Colors.white,
                    title: Text(
                      "Account Deactivate",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountDelete()));
                    }
                    ),
                  ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                      leading: Image.asset(
                        "assets/images/logout_drawer.png",
                        height: 40,
                        width: 40,
                      ),
                      tileColor: Colors.transparent,
                      textColor: Colors.white,
                      title: Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Do You want to Logout?'),
                          //content: const Text('AlertDialog description'),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                        StadiumBorder(side: BorderSide(color: Colors.pink)),
                                      ),
                                      minimumSize: MaterialStatePropertyAll(Size(100, 40)),
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.white,
                                      )),
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel',style: TextStyle(color: Colors.pink)),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                        StadiumBorder(),
                                      ),
                                      minimumSize: MaterialStatePropertyAll(Size(100, 40)),
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.pink,
                                      )),
                                  onPressed: () async {
                                    Navigator.pop(context, 'OK');
                                    //AppUser.sharedInstance.logoutAction();
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                    final prefs = await SharedPreferences.getInstance();
                                    prefs.clear();
                                    SharedPreferencesFunctions().logout();
                                    await FirebaseAuth.instance.signOut();
                                    GoogleSignIn googleSignIn = GoogleSignIn();
                                    await googleSignIn.signOut();

                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )),
    );
  }
  }



//
// showDialog<String>(
// context: context,
// builder: (BuildContext ctx) => AlertDialog(
// backgroundColor: Colors.white.withOpacity(.7),
// title: Container(
// decoration: BoxDecoration(
// border: Border(
// bottom: BorderSide(
// color: Colors.black,
// width: 2.0,
// ),
// ),
// ),
// child: const Text(
// 'Delete Your Account?',
// style: TextStyle(
// fontWeight: FontWeight.w700,
// fontSize: 20,
// color: Colors.black),
// )),
// content: Container(
// child: const Text(
// 'You\'ll lose all Your profile data and Transactions details',
// style: TextStyle(
// fontWeight: FontWeight.w700,
// fontSize: 18,
// color: Colors.white),
// )),
// actions: <Widget>[
// Container(
// height: 40,
// //width: 90,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// TextButton(
// onPressed: () => Navigator.pop(context, 'Cancel'),
// child: const Text(
// 'Cancel',
// style: TextStyle(
// fontWeight: FontWeight.w700,
// fontSize: 20,
// color: Colors.black),
// ),
// ),
// TextButton(
// onPressed: () async {
// Navigator.pop(ctx, 'OK');
// // AppUser.sharedInstance
// //     .deleteAccount()
// //     .then((value) async {
// //   if (value.status) {
// //     AppUser.sharedInstance.logoutAction();
// //     Navigator.pushReplacement(
// //         context,
// //         new MaterialPageRoute(
// //             builder: (context) =>
// //                 LoginScreen()));
// //     AppUser.sharedInstance.logoutAction();
// //     final prefs = await SharedPreferences.getInstance();
// //     prefs.clear();
// //     GoogleSignIn googleSignIn = GoogleSignIn();
// //     await googleSignIn.signOut();
// //   }
// // });
// },
// child: const Text('Delete Account',
// style: TextStyle(
// fontWeight: FontWeight.w700,
// fontSize: 20,
// color: Colors.red)),
// ),
// ],
// ),
// ),
// ],
// ),