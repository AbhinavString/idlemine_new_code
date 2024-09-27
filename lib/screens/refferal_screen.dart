import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../models/referdata_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'package:share_plus/share_plus.dart';

import 'IdleMineDrawer.dart';
import 'Referral_history.dart';
import 'login_screen.dart';

class Referralscreen extends StatefulWidget {
  const Referralscreen({Key? key}) : super(key: key);

  @override
  State<Referralscreen> createState() => _ReferralscreenState();
}

class _ReferralscreenState extends State<Referralscreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  var isloading=true;
  List<Referdatamodel> referdata=[];

  @override
  void initState() {
    getConnectivity(context);
    super.initState();
    //secureScreen();
    Repository().getReferData(id: SharedPreferencesFunctions().getLoginUserId()!)
        .then(
            (value) {
              setState(() {
                isloading=false;
              });
          print('referdata');
          value!.forEach(
                  (element) {
                print("elementtttt$element");
                setState(() {
                  referdata.add(element);
                });
                print("referdata=============$referdata");
              });
        });
    getBalance();
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
                    Balance1v1 = balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
              });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: IdleMineDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child:isloading?Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 70,
                    ),
                  )
                ],
              ) : Column(children: [
                SecondAppBar(context, "", Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
                SizedBox(height: 30,),
                Text("Referral Code",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 24)),
                SizedBox(height: 20,),
                Image.asset("assets/images/referalnew.png",width: 100,height: 130),
                Container(
                  width: MediaQuery.of(context).size.width-50,
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("NOTE:",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500)),
                     SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1.",style: TextStyle(color: Colors.white,)),
                          Text("2.",style: TextStyle(color: Colors.white,)),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(" Referred User have to be verified.",style: TextStyle(color: Colors.white,)),
                          Text(" Referred User Must have to WIN atleast one game, which can be either free or paid.",style: TextStyle(color: Colors.white,)),
                        ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Color(0xff240E3F),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Clipboard.setData(ClipboardData(text: "${referdata.isEmpty?"":referdata.first.referralCode}"))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "     Referral Code Copied Successfully")));
                          });
                        },
                        child: Container(
                          child: Text(
                            '${referdata.isEmpty?"":referdata.first.referralCode}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Share.share("Join IdlePlay with this Referralcode\n${referdata.isEmpty?"":referdata.first.referralCode}");
                        },
                        child: Container(
                          child: Icon(Icons.share, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height :60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Earned Referral Points',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          referdata.isEmpty?"0":referdata.first.earnByReferral.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color(0xffda286f),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Image.asset("assets/images/refpoints.png"),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppButton((){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ReferralsHistory()));
                  },"Referral History"),
                ),

              ]),
            ),
          ),
        ),
      ),
    );
  }
}
