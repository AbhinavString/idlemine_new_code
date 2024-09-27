import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:idlemine_latest/screens/tabs_Screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';


class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController txtWalletAddress = TextEditingController();
  String _scanBarcode = 'Unknown';
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  var status;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getwalletId();
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
                    Balance1v1 =   balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
              });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
              height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
          ),
          ),
          child:Column(
          children: [
            customAppBar(context, scaffoldKey,Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
            Spacer(),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: txtWalletAddress,
                //textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                onTap: () {
                  // FocusScope.of(context).unfocus();
                  //txtWalletAddress.clear();
                },
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                  hintText: 'Enter Wallet Id',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70,width: 2),borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70),borderRadius: BorderRadius.circular(15)),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70),borderRadius: BorderRadius.circular(15)),
                  focusedErrorBorder:  OutlineInputBorder(borderSide: BorderSide(color: Colors.white70,),borderRadius: BorderRadius.circular(15)),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70,),borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(onPressed: () async {
                    String barcodeScanRes;
                    // Platform messages may fail, so we use a try/catch PlatformException.
                    try {
                      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                          '#ff6666', 'Cancel', true, ScanMode.QR);
                      print("barcodeScanRes======================$barcodeScanRes");
                    } on PlatformException {
                      barcodeScanRes = 'Failed to get platform version.';
                    }

                    // If the widget was removed from the tree while the asynchronous platform
                    // message was in flight, we want to discard the reply rather than calling
                    // setState to update our non-existent appearance.
                    if (!mounted) return;

                    setState(() {
                      _scanBarcode = barcodeScanRes;
                      txtWalletAddress.text=barcodeScanRes.substring(9,barcodeScanRes.length);
                      print("_scanBarcode=======>>>>>>>>>>>>$_scanBarcode");
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
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffda286f),
                  // side: BorderSide(color: Colors.yellow, width: 5),
                  textStyle: const TextStyle(
                      color: Colors.white,fontStyle: FontStyle.normal),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  shadowColor: Colors.pinkAccent,
                  elevation: 3,
                ),
                onPressed: () async {
                  if(txtWalletAddress.text.length==42){
                    sendWalletId();
                  }else{
                    Fluttertoast.showToast(
                      msg:"Invalid Wallet Address",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.pink,
                      textColor: Colors.white,
                      fontSize: 12.0,
                    );
                  }
                }, child:   SizedBox(
                //width: 180,
                height: 43,
                child: Center(
                  child: Text(
                    'Done',style: TextStyle(fontSize: 15),
                  ),
                ),
              ),),
            ),
          ]),
    ),
    );
  }

  sendWalletId() async {
    var url = '${baseurl}api/leaderboardsetting/rewardWalletStoreUpdate';
    var data = json.encode({
      "userId":  SharedPreferencesFunctions().getLoginUserId(),
      "rewardWalletId":txtWalletAddress.text
    });

    final response = await http.post(Uri.parse(url),
      headers:<String, String>{
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid':SharedPreferencesFunctions().getLoginUserId()!,
      },
      body: data,
    );
    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print("success");
      print(jsonDecode(response.body));
      Fluttertoast.showToast(
        msg:"Successfully Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(index: 2),));
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

  getwalletId() async {
    var url = '${baseurl}api/leaderboardsetting/getRewardWallet/${SharedPreferencesFunctions().getLoginUserId()}';

    final response = await http.get(Uri.parse(url),
      headers:<String, String>{
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
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
          "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp) as List;
      print("responseBody==$responseBody");
      if (responseBody.isNotEmpty){
        setState(() {
          txtWalletAddress.text = responseBody.first["rewardWalletId"];
        });
    }

    }
    else {
      print("failed");
      print(jsonDecode(response.body));
    }
  }

}
