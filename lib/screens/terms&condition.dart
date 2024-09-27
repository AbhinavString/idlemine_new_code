import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:idlemine_latest/screens/sign_up.dart';
import 'package:http/http.dart' as http;
import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../utils/app_colors.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key? key}) : super(key: key);

  @override
  State<TermAndCondition> createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition> {
  var content="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webContent();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Row(
            children: [
              IconButton(onPressed: (){ Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),));
              }, icon: Icon(Icons.arrow_back_ios,color: AppColors.appcolordmiddark,size: 40,)),
              Spacer(),
              Text("Terms And Condition",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.white)),
              Spacer(),
              Column(
                children: [
                  Image.asset('assets/images/idleminesmall_icon.png',width: 40,height: 40),
                ],
              ),
            ],),
        ),
      ),
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
          //'userid':SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "type":"term"
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
      }else{
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("resentapi ee==$e");
      return Future.error(e);
    }
  }
}
