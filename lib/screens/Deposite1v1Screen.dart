import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class Deposite1v1Screen extends StatefulWidget {
  const Deposite1v1Screen({Key? key}) : super(key: key);

  @override
  State<Deposite1v1Screen> createState() => _Deposite1v1ScreenState();
}

class _Deposite1v1ScreenState extends State<Deposite1v1Screen> {
  var walletAddress1v1 = "";
  var isWalletFetched = false;
  List<BalanceData> balanceData = [];
  double Balance1v1 = 00;
  var tap1 = 0;
  var tap2 = 0;
  var isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getConnectivity(context);
    //secureScreen();
    getBalance();
    sharedPreferences!.remove('Isloginstatus');
    Repository()
        .isLogin(
            token: SharedPreferencesFunctions().getLoginToken()!,
            context: context)
        .then((value) async {
      if (SharedPreferencesFunctions().getIsloginstatus() == "0") {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      }
    });
    //fetchWalletAddress();
  }

  getBalance() {
    balanceData.clear();
    Repository()
        .getBalance(id: SharedPreferencesFunctions().getLoginUserId()!)
        .then((value) {
      value!.forEach((element) {
        setState(() {
          balanceData.add(element);
          if (balanceData.isEmpty) {
            Balance1v1 = 00;
          } else {
            setState(() {
              walletAddress1v1 = balanceData.first.walletId1V1;
              Balance1v1 = balanceData.first.moneyInWallet1V1.toDouble();
            });
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
          (balanceData.isEmpty)
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 70,
                  ),
                )
              : (walletAddress1v1 == "")
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 50, right: 10, left: 10),
                      child: AppButton(
                          !isloading
                              ? () {
                                  setState(() {
                                    isloading = true;
                                  });
                                  Repository()
                                      .Create1v1Wallet(context)
                                      .then((value) {
                                    setState(() {
                                      getBalance();
                                      isloading = false;
                                    });
                                  });
                                }
                              : null,
                          "Create Wallet"),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
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
                                    margin: EdgeInsets.only(
                                        top: 20, left: 5, right: 5),
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
                                                text: walletAddress1v1))
                                            .then((_) {
                                          showToast(
                                              "Wallet Address Copied Successfully");
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
                                              "${walletAddress1v1}",
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
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 15, right: 5),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 2.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent.withOpacity(.2),
                                  //border: Border.all(color: Colors.white, width: .5),
                                ),
                                child: Center(
                                  child: QrImageView(
                                    data: "${walletAddress1v1}",
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
                              AppButton(
                                  !isloading
                                      ? () {
                                          setState(() {
                                            isloading = true;
                                          });
                                          Repository()
                                              .getDepositeInWallet1v1(context)
                                              .then((value) {
                                            setState(() {
                                              isloading = false;
                                            });
                                          });
                                        }
                                      : null,
                                  "Update Balance"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Note : Click here if you have deposit listed BEP20 token.",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
