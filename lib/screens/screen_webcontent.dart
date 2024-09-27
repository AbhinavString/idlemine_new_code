
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../constants/BaseController.dart';
import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';
class ScreenWithWebContent extends BaseController {
  var title = "";

  ScreenWithWebContent(this.title);

  @override
  State<ScreenWithWebContent> createState() => _ScreenWithWebContentState();
}

class _ScreenWithWebContentState extends State<ScreenWithWebContent> {
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
var content="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
    webContent();
    //secureScreen();
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
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 0,
        child: Column(
          children: [
            SecondAppBar(context, "", Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
            if(content!="")...[
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height-160,
                  margin: EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 5, left: 20, right: 20),
    child: HtmlWidget( '''$content''',
                      textStyle: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              )
                  ]
//             ]else if(widget.title=="about")...[
//               SingleChildScrollView(
//                 child: Container(
//                   height: MediaQuery.of(context).size.height-160,
//                   margin: EdgeInsets.only(top: 10),
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(top: 5, left: 20, right: 20),
//                     child: HtmlWidget( '''<p style="text-align:center"><span style="color:#ffffff"><strong>Convert your Idle time into income.</strong></span></p>
//
// <p style="margin-left:0; margin-right:0; text-align:center"><span style="color:#ffffff">Low effort, more income with the power of your thumb.</span></p>
//
// <p style="margin-left:0; margin-right:0; text-align:justify"><span style="color:#ffffff">The Kling&#39;s Idlemine App is a one-of-a-kind mobile-based Play2Earn Web 3.0 app. By holding their thumb on the screen of their mobile phone, users earn KLing tokens. The longer you hold your thumb, the more KLing tokens you earn.</span></p>
//
// <h2><span style="color:#ffffff">Our vision</span></h2>
//
// <p style="margin-left:0; margin-right:0; text-align:justify"><span style="color:#ffffff">To create a Play2Earn environment where users can earn with minimal skill is our vision. The goal of our ecosystem is to create a metaverse for the masses and not just a target community. Our app helps low-income and no-income communities earn a living. Play2earn games are usually complicated, but we&#39;ve made it so anyone can understand it and play to earn easily. By simply putting their fingers on their screens, users can earn more than minimum wage.</span></p>
// ''',
//                       textStyle: TextStyle(fontSize: 14, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ]
          ],
        ),
      ),
    );
  }
  webContent() async {
    try {
      print("ResendOtp");
      Uri uri = Uri.parse("${baseurl}api/cms/getCMS");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid':SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "type":widget.title
        }),
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],"FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp);
        setState(() {
          content=jsonDecode(resp)["cmsContent"];
        });
        print("responseBody$responseBody");
      }else if(response.statusCode == 403){
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    LoginScreen()));
      }else{
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("resentapi ee==$e");
      return Future.error(e);
    }
  }

}
