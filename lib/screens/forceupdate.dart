import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpadatePage extends StatefulWidget {
  const ForceUpadatePage({Key? key}) : super(key: key);

  @override
  State<ForceUpadatePage> createState() => _ForceUpadatePageState();
}

class _ForceUpadatePageState extends State<ForceUpadatePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
            ),
            ),child: Column(
            children: [
              SizedBox(height: 40,),
              Container(
                height: 150,
                margin: EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/update_logo.png',
                ),
              ),
          Container(
            height: 100,
            margin: EdgeInsets.only(top: 50),
            child: Image.asset(
              'assets/images/kling_newicon.png',
              height: 100,
              width: 130,
            ),
          ),
          SizedBox(height: 50,),
          Text("We're Gettting Better!",style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,color: Colors.white)),
              SizedBox(height: 30,),
          Text("Update the app to unlock new features",style: TextStyle(color: Colors.white70,fontSize: 18)),
              SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            final appId = Platform.isAndroid ? 'com.idel.idleminekling' : 'YOUR_IOS_APP_ID';
            final url = Uri.parse(
              Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=$appId"
                  : "https://apps.apple.com/app/id$appId",
            );
            launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
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
              child: SizedBox(
                width: 180,
                height: 50,
                child: Center(
                  child: Text(
                    'Update',
                    textScaleFactor: 1.6,
                  ),
                ),
              ),),
              Spacer(),
              Text("Powered by Kling Blockchain",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),),
              SizedBox(height: 20,)
        ]),
        ),
      ),
    );
  }
}
