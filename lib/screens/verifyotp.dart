import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';

class VerifyOtpScreen extends StatefulWidget {
  var email;
   VerifyOtpScreen({Key? key, required this.email,}) : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  var otp=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //secureScreen();
    sharedPreferences!.remove('ConfirmOtpstatus');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
    ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.only(top: 50),
                  child: Image.asset(
                    'assets/images/kling_newicon.png',
                    height: 100,
                    width: 130,
                  ),
                ),
          Spacer(),
         Padding(
         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
         child: Text(
           "We have sent an OTP to your email address,\nplease enter below to verify",
           textAlign: TextAlign.center,
           style: TextStyle(
             fontWeight: FontWeight.w500,
             fontSize: 16,
             color: Colors.white.withOpacity(0.87),
           ),
         ),
       ),
       SizedBox(
         height: 30,
       ),
       Padding(
         padding: const EdgeInsets.symmetric(
             vertical: 8.0, horizontal: 40),
         child: PinCodeTextField(
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
       ),
       ElevatedButton(
         style: ElevatedButton.styleFrom(
           backgroundColor:  Color(0xffda286f),
           // side: BorderSide(color: Colors.yellow, width: 5),
           textStyle: const TextStyle(
               color: Colors.white,fontStyle: FontStyle.normal),
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(10))),
           shadowColor: Colors.pinkAccent,
           elevation: 3,
         ),
         child: SizedBox(
           width: MediaQuery.of(context).size.width,
           height: 43,
           child: Center(
             child: Text(
               "CONFIRM OTP",
               style: TextStyle(
                 fontSize: 16,
               ),
             ),
           ),
         ),
         onPressed:currentText==""||currentText.length<4?null:(){
           setState(() {
             Repository().ConfirmOtp(email: widget.email,otp: currentText,context: context).then((value){
              if(SharedPreferencesFunctions().getConfirmOtpStatus()=="1"){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(index: 0),));
              }else{
                showToast("Something went wrong");
              }
             });

           });
         },),
                Spacer(),
     ]),
    ),
     ),
    );
  }
}
