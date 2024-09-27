import 'dart:async';
import 'dart:convert';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/BaseController.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class DepositScreen extends BaseController {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var isloading = false;
  bool soundStatus = false;
  bool notificationStatus = false;
  bool status = false;
  var walletAddress = "";
  var isWalletFetched = false;
  double Balance=00;
  String currentText = "";
  var tap1=0;
  var tap2=0;
  Duration? myDuration;
  Timer? CountdownTimer;
  int? Second;
  List<BalanceData> balanceData=[];

  late Timer mytimer = Timer(Duration(days: 100), () {});

  bool otpRequested = false;
  var otp = "";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getConnectivity(context);
    //secureScreen();
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
    //fetchWalletAddress();

  }
  getBalance(){
    Repository().getBalance(id: SharedPreferencesFunctions().getLoginUserId()!)
        .then(
            (value) {
              setState(() {
                isWalletFetched=true;
              });
          value!.forEach(
                  (element) {
                setState(() {
                  balanceData.add(element);
                  if (balanceData.isEmpty) {
                    Balance = 00;
                  } else {
                    walletAddress=balanceData.first.walletId;
                    Balance =   balanceData.first.moneyInWallet.toDouble();
                  }
                });
              });
        });
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
                children: [
                  (!isWalletFetched)
                      ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 70,
                    ),
                  )
                      : (walletAddress == "")
                      ?
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            // margin: EdgeInsets.only(
                            //     top: MediaQuery.of(context).size.height / 6),
                            height: 30,
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              "Your email address needs to be verified",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tap1==0?Color(0xffda286f):Colors.pink,
                                // side: BorderSide(color: Colors.yellow, width: 5),
                                textStyle: const TextStyle(
                                    color: Colors.white,fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                shadowColor: Colors.pinkAccent,
                                elevation: 3,
                              ),
                              onPressed: tap1==0?() {
                                  setState(() {
                                    tap1++;
                                  });
                              }:null,
                              child: Text("Request OTP")),
                          SizedBox(height: 10,),
                          if (otpRequested) ...[
                            PinCodeTextField(
                              appContext: context,
                              length: 5,
                              textStyle: TextStyle(color: Colors.white),
                              onChanged: (value) {
                                debugPrint(value);
                                setState(() {
                                  currentText = value;
                                  print("currentText$currentText");
                                });
                              },
                              onCompleted: (String verificationCode) {
                                setState(() {
                                  otp = verificationCode;
                                });
                              },  // end onSubmit
                            ),
                            SizedBox(height: 20,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffda286f),
                                // side: BorderSide(color: Colors.yellow, width: 5),
                                textStyle: const TextStyle(
                                    color: Colors.white,fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                shadowColor: Colors.pinkAccent,
                                elevation: 3,
                              ),
                              onPressed: () {
                                if(tap2==0){

                                  tap2++;
                                }

                              },
                              child: Container(
                                height: 50,
                                width: 200,
                                child: Center(
                                  child: Text(
                                    'Verify',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]

                ],
              ),
                  )
              : Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        // margin: EdgeInsets.only(
                        //     top: MediaQuery.of(context).size.height / 6),
                        height: 30,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Deposit Address',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Center(
                            child: Container(
                                margin:
                                    EdgeInsets.only(top: 20, left: 5, right: 5),
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent.withOpacity(.4),
                                  border: Border.all(
                                      //color: Colors.red,
                                      width: 1),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                            text: walletAddress))
                                        .then((_) {
                                      showToast("Wallet Address Copied Successfully");
                                    });
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${walletAddress}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 20, left: 15, right: 5),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent.withOpacity(.2),
                              //border: Border.all(color: Colors.white, width: .5),
                            ),


                            child: Center(
                              child: QrImageView(
                                data: "${walletAddress}",
                                version: QrVersions.auto,
                                eyeStyle: QrEyeStyle(
                                  color: Colors.white,
                                ),
                                dataModuleStyle:
                                    QrDataModuleStyle(color: Colors.white),
                                size: 270.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              'Scan QR Code',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 27,
                                color: Color(0xffda286f),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          AppButton(!isloading?(){
                            setState(() {
                              isloading=true;
                            });
                          Repository().getDepositeInWallet(context).then((value) {
                            setState(() {
                              isloading=false;
                            });
                          });
                          }:null, "Update Balance"),
                          SizedBox(height: 10,),
                          Text("Note : Click here if you have deposit listed BEP20 token.",style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ],
                  ),
              ),
                ],
      ),
    );
  }
  void startTimer() {
    myDuration = Duration(seconds: 5);

    CountdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) {
          final reduceSecondsBy = 1;
          setState(() {
            Second = myDuration!.inSeconds - reduceSecondsBy;
            print("Second$Second");
            if (Second! <= 0) {
              CountdownTimer!.cancel();
            } else {
              myDuration = Duration(seconds: Second!);
            }
          });
        });
  }

  void stopTimer() {

    setState(() => CountdownTimer!.cancel());
  }
}
