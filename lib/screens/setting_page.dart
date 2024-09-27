import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'IdleMineDrawer.dart';
import 'login_screen.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool isOfferNotificationActive = false;
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  void initState() {
    // isRealDevices(context);
    getConnectivity(context);
    getBalance();
   // secureScreen();
    super.initState();
    sharedPreferences!.remove('Isloginstatus');
    Repository().isLogin(token: SharedPreferencesFunctions().getLoginToken()!,context: context).then((value) async {
      if(SharedPreferencesFunctions().getIsloginstatus()=="0"){
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
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      }
    });
  }

  getBalance(){
    Repository().getBalance(id: SharedPreferencesFunctions().getLoginUserId()!)
        .then(
            (value) {
          value!.forEach(
                  (element) {
                setState(() {
                  balanceData.add(element);
                  if (balanceData.isEmpty) {
                    Balance = 00;
                    Balance1v1=00;
                  } else {
                    Balance =   balanceData.first.moneyInWallet.toDouble();
                    Balance1v1= balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
              });
        });
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TabScreen(index: 0,),
            ));
        return true;

      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: IdleMineDrawer(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(children: [
              customAppBar(context, scaffoldKey,Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
              SizedBox(height: 30,),
              Text("Setting",style: TextStyle(fontSize: 25,color: AppColors.white,fontWeight: FontWeight.w500)),
              Container(
                margin: EdgeInsets.only(top: 50,),
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.transparent.withOpacity(.4),
                  border: Border.all(
                    //color: Colors.red,
                      width: 1),
                ),
                child: AppSettingWidget(
                  switchValue: notificationStatus,
                  appSettingTitle: "Notification",
                  icon: Icons.notifications,
                  onToggle: (value) {
                    setState(
                          () {
                            notificationStatus = value!;
                       SharedPreferencesFunctions().saveNotification(notificationStatus);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(top: 10,),
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.transparent.withOpacity(.4),
                  border: Border.all(
                    //color: Colors.red,
                      width: 1),
                ),
                child: AppSettingWidget(
                  switchValue: Sound,
                  appSettingTitle: "Sound",
                  icon: Icons.volume_up,
                  onToggle: (value) {
                    setState(
                          () {
                            Sound = value!;
                         SharedPreferencesFunctions().saveSound(Sound);
                      },
                    );
                  },
                ),
              ),
            ]),
          ),
        ),

      ),
    );
  }
}
