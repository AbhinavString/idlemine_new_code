import 'dart:async';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/BaseController.dart';
import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';
class WithdrawScreen extends BaseController {
  var route;
  WithdrawScreen({Key? key,required this.route}) : super(key: key);
  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  String _scanBarcode = 'Unknown';
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtWalletAddress = TextEditingController();
  String currentText = "";
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  var receivable="0";
  var withdrawminimumamount = 0;
  var displayReceivable;
  var charge;
  var otp = "";
  List walletAddress = [];
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  bool status = false;
  bool istileclicked = false;
  var loader=false;
  var istap=true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      istileclicked = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mytimer.cancel();
    super.dispose();
  }

  late Timer mytimer = Timer(Duration(days: 100), () {});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //secureScreen();
    getConnectivity(context);
    getAdressesApi();
    getDetail();
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
                    Balance1v1=balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new TabScreen(index: 2,)));
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: false,
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(onPressed: (){ Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabScreen(index: 2,),));
                          }, icon: Icon(Icons.arrow_back_ios,color: AppColors.appcolordmiddark,size: 40,)),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Single Player Balance",style: TextStyle(fontSize: 12,color: Colors.white),),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("\$ ${Balance.toStringAsFixed(4)}",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,  color: AppColors.appcolordmiddark),),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          SizedBox(height: 10,),
                          Image.asset('assets/images/idleminesmall_icon.png',width: 40,height: 40),
                          Text("V $version",style: TextStyle(color: Colors.white,fontSize: 6,fontWeight: FontWeight.w600),),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("1v1 Balance",style: TextStyle(fontSize: 12,color: Colors.white),),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("\$ ${Balance1v1.toStringAsFixed(4)}",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,  color: AppColors.appcolordmiddark),),
                          ),
                        ],
                      ),
                    ],),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 30,
                        width: double.infinity,
                        child: Center(
                          child: Text(widget.route=="" ?'Single Player Withdraw':"1v1 Withdraw",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50,),
                      Column(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: txtWalletAddress,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                                decoration: new InputDecoration(
                                  hintText: 'Enter Wallet Id',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70, width: 2),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white70,),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white70,),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  suffixIcon: IconButton(onPressed: () async {
                                    String barcodeScanRes;
                                    try {
                                      barcodeScanRes =
                                      await FlutterBarcodeScanner.scanBarcode(
                                          '#ff6666', 'Cancel', true,
                                          ScanMode.QR);
                                      print(
                                          "barcodeScanRes======================$barcodeScanRes");
                                    } on PlatformException {
                                      barcodeScanRes =
                                      'Failed to get platform version.';
                                    }
                                    if (!mounted) return;

                                    setState(() {
                                      _scanBarcode = barcodeScanRes;
                                      txtWalletAddress.text =
                                          barcodeScanRes.substring(
                                              9, barcodeScanRes.length);
                                      print(
                                          "_scanBarcode=======>>>>>>>>>>>>$_scanBarcode");
                                    });
                                  }, icon: Icon(Icons.qr_code_scanner)),
                                  suffixIconColor: Colors.white,
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          if(walletAddress.isNotEmpty)...[
                            Text("Previously Used Withdrawal Wallet IDs",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               ListView.builder(
                                padding: EdgeInsets.only(top: 10),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: walletAddress.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      txtWalletAddress.text =
                                      walletAddress[index]["requestAddress"];
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xff240E3F),
                                        borderRadius: BorderRadius.circular(
                                            15),),
                                      child: Text(
                                          walletAddress[index]["requestAddress"],
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10)),
                                    ),
                                  );
                                },),
                            ]),
                          ],
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Min : $withdrawminimumamount USDT",
                                  style: TextStyle(color: Colors.white),)),
                          ),
                          Form(
                            key: _formKey,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: txtAmount,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                                ],
                                validator: (value) {
                                  print(value);
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Amount';
                                  } else if (double.parse(value!) < withdrawminimumamount) {
                                    return 'You cannot withdraw less than $withdrawminimumamount USDT';
                                  }
                                },
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70, width: 2),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white70,),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white70,),
                                      borderRadius: BorderRadius.circular(
                                          15)),
                                  errorStyle: TextStyle(fontSize: 15),
                                  hintText: 'Enter Amount',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    txtAmount.text = "100";
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    child: Center(child: Text("100")),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    txtAmount.text = "500";
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    child: Center(child: Text("500")),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    txtAmount.text = "1000";
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    child: Center(child: Text("1000")),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Text("NOTE: Transaction may take upto 48 hours",
                            style: TextStyle(color: Colors.white),),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffda286f),
                              // side: BorderSide(color: Colors.yellow, width: 5),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontStyle: FontStyle.normal),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10))),
                              shadowColor: Colors.pinkAccent,
                              elevation: 3,
                            ),

                            onPressed: () {
                              if (txtWalletAddress.text.isNotEmpty) {
                                if (txtWalletAddress.text.length == 42) {
                                  if (_formKey.currentState!
                                      .validate()) {
                                      if(widget.route=="") {
                                        if (double.parse(txtAmount.text) <= Balance) {
                                          ShowDetails();
                                        } else {
                                          showToast("Insufficient Balance");
                                        }
                                      }else{
                                        if (double.parse(txtAmount.text) <= Balance1v1) {
                                          ShowDetails();
                                        } else {
                                          showToast("Insufficient Balance");
                                        }
                                      }
                                  }
                                } else {
                                  showToast(
                                      "Please Enter Correct Wallet Address");
                                }
                              } else {
                                showToast("Please Enter Wallet Address");
                              }
                            },
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 100,
                              child: Center(
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ShowOtpPopUp() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new WithdrawScreen(route: widget.route,)));
            return true;
          },
          child: AlertDialog(
            scrollable: true,
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3.6,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Please Enter Your OTP", style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                        //Spacer(),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          obscureText: true,
                          obscuringCharacter: '*',
                          obscuringWidget:Text('*',style: TextStyle(fontSize: 24)),
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {

                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            debugPrint("Completed");
                            setState(() {
                              otp=v;
                            });
                          },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                              print("currentText$currentText");
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            return true;
                          },
                        ),
                        //Spacer(),
                        InkWell(
                          onTap: () {
                            print("otp====$otp");
                            if (txtWalletAddress.text != "") {
                              if (otp != "") {
                                if (txtAmount.text != "") {
                                  setState(() {
                                    loader=true;
                                  });
                                  print(istap);
                                  if(istap) {
                                    setState(() {
                                      istap=false;
                                    });
                                    if(widget.route=="") {
                                      Repository().ConfirmOtpForget(
                                          context: context,
                                          otp: currentText,
                                          email: SharedPreferencesFunctions()
                                              .getLoginEmail()).then((value) {
                                        if (SharedPreferencesFunctions()
                                            .getForgotConfirmOtpStatus() == "1") {
                                          Repository().withdrawSave(
                                              Address: txtWalletAddress.text,
                                              Amount: txtAmount.text,
                                              receivable: (double.parse(txtAmount.text) -
                                                  (double.parse(receivable) / 100 *
                                                      double.parse(txtAmount.text))).toStringAsFixed(3),
                                              charge: (double.parse(receivable) / 100 *
                                                  double.parse(txtAmount.text)).toStringAsFixed(3),
                                              userId: SharedPreferencesFunctions().getLoginUserId(),
                                              context: context).then((value) {
                                            setState(() {
                                              txtAmount.text = "";
                                              Navigator.push(context, new MaterialPageRoute(
                                                  builder: (context) => new TabScreen(index: 0,)));
                                            });
                                          });
                                        }
                                      });
                                    }else{
                                      Repository().ConfirmOtpForget(
                                          context: context,
                                          otp: currentText,
                                          email: SharedPreferencesFunctions()
                                              .getLoginEmail()).then((value) {
                                        if (SharedPreferencesFunctions()
                                            .getForgotConfirmOtpStatus() == "1") {
                                          Repository().withdrawSave1v1(
                                              Address: txtWalletAddress.text,
                                              Amount: txtAmount.text,
                                              receivable: (double.parse(txtAmount.text) -
                                                  (double.parse(receivable) / 100 *
                                                      double.parse(txtAmount.text))).toStringAsFixed(3),
                                              charge: (double.parse(receivable) / 100 *
                                                  double.parse(txtAmount.text)).toStringAsFixed(3),
                                              userId: SharedPreferencesFunctions().getLoginUserId(),
                                              context: context).then((value) {
                                            setState(() {
                                              txtAmount.text = "";
                                              Navigator.push(context, new MaterialPageRoute(
                                                  builder: (context) => new TabScreen(index: 0,)));
                                            });
                                          });
                                        }
                                      });
                                    }
                                    setState(() {
                                      loader = false;
                                    });
                                  }
                                } else {
                                  showToast("Please provide amount");
                                }
                              } else {
                                showToast("Please provide otp");
                              }
                            } else {
                              showToast("Please provide wallet address");
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            margin: EdgeInsets.only(top: 35),
                            decoration: BoxDecoration(
                              color: Color(0xffda286f),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Withdraw',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                  loader?Positioned.fill(
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.pink,
                        size: 60,
                      ),
                    ),
                  ):Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ShowDetails() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new WithdrawScreen(route: widget.route,)));
            return true;
          },
          child: AlertDialog(
            scrollable: true,
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3.6,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount", style: TextStyle(fontSize: 18)),
                      Text("${txtAmount.text}", style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Spacer(),
                  Divider(color: Colors.black38, thickness: 1),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Charge(${receivable.toString()}%)",
                          style: TextStyle(fontSize: 18)),
                      Text("${(double.parse(receivable) / 100 * double.parse(txtAmount.text)).toStringAsFixed(3)}",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Spacer(),
                  Divider(color: Colors.black38, thickness: 1),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Receivable", style: TextStyle(fontSize: 18)),
                      Text("${(double.parse(txtAmount.text) - (double.parse(
                          receivable) / 100 * double.parse(txtAmount.text)))
                          .toStringAsFixed(3)}", style: TextStyle(fontSize: 18))
                    ],
                  ),

                  Spacer(),
                  TextButton(onPressed: () {
                    showToast("Please wait...");
                    Repository().ResendOtp(email:SharedPreferencesFunctions().getLoginEmail(),context: context).then((value){
                        ShowOtpPopUp();
                    });

                  },
                    child: Container(
                      height: 50,
                      //width: 200,
                      margin: EdgeInsets.only(top: 35),
                      decoration: BoxDecoration(
                        color: Color(0xffda286f),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Send OTP to Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  getDetail() async {
    var url = '${baseurl}api/settings/get';

    final response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid':SharedPreferencesFunctions().getLoginUserId()!,
      },
    );
    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print("success");
      print(jsonDecode(response.body));
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],"FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      final responseBody = jsonDecode(resp);
      setState(() {
        receivable = responseBody["withdrawalCharge"].toString();
        withdrawminimumamount = responseBody["withdrawalMinAmount"];
      });
    }else if(response.statusCode == 403){
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  LoginScreen()));
    }
    else {
      print("failed");
      print(jsonDecode(response.body));
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xffda286f),
        textColor: Colors.white);
  }


  getAdressesApi() async {
    var url = '${baseurl}api/withdraw/requestAddressList/${SharedPreferencesFunctions().getLoginUserId()}';

    final response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid':SharedPreferencesFunctions().getLoginUserId()!,
      },
    );
    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print("success");
      print(jsonDecode(response.body));
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],"FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      setState(() {
        walletAddress = jsonDecode(resp) as List ;
        print("walletAddress=====$walletAddress");
      });
    }else if(response.statusCode == 403){
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  LoginScreen()));
    }
    else {
      print("failed");
      print(jsonDecode(response.body));
    }
  }
}
