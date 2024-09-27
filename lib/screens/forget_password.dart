import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  var ontap;
  var email;
  ForgotPassword({Key? key, required this.ontap, required this.email}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool passwordVisible=true;
  bool passwordVisible2=true;
  var loader= false;
  final _formKey = GlobalKey<FormState>();
  var email=TextEditingController();
  var Password=TextEditingController();
  var ConfirmPassword=TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  var ontap="";
  var otp=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ontap=widget.ontap;
    sharedPreferences!.remove('ConfirmOtpstatus');
    sharedPreferences!.remove('forgotConfirmOtp');
    sharedPreferences!.remove('OtpStatus');
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => LoginScreen()));
        return true;
      },
      child: Scaffold(
        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
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
                      if(ontap=="")...[
                        TextField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                BorderSide(width: 1, color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintText: 'Enter your email',
                              contentPadding: EdgeInsets.all(10),
                              hintStyle:
                              TextStyle(fontSize: 16, color: Colors.white),
                              fillColor: Colors.transparent),
                        ),
                        SizedBox(height: 50,),
                        AppButton((){
                          setState(() {
                            if(email.text.isEmpty){
                              showToast("Please enter your email");
                            }else{
                              setState(() {
                                loader=true;
                              });
                            Repository().ResendOtp(email: email.text,context: context).then((value){
                              setState(() {
                                loader=false;
                              });
                              if(SharedPreferencesFunctions().getOtpStatus()=='1'){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPassword(ontap:"email",email:email.text.trim())));
                              }
                            });
                            }
                          });

                        }, "Next"),
                      ]else if(ontap=="email")...[
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
                                    loader=true;
                                  });
                                  Repository().ConfirmOtpForget(email:widget.email,otp: currentText,context: context).then((value){
                                    setState(() {
                                      loader=false;
                                    });
                                  if(SharedPreferencesFunctions().getForgotConfirmOtpStatus()=="1"){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ForgotPassword(ontap:"otp", email: "",)));
                                  }else{
                                  showToast("Something went wrong");
                                  }
                                  });

                                  setState(() {

                                  });
                                },),
                  ]else if(ontap=="otp")...[
                        TextFormField(
                          controller: Password,
                          obscureText: passwordVisible,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                              BorderSide(width: 1, color: Colors.white),
                            ),
                            // fillColor: Colors.orange,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Password',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.white,),
                            contentPadding: EdgeInsets.all(10),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,color: Colors.white),
                              onPressed: () {
                                setState(
                                      () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                            }
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: ConfirmPassword,
                          textInputAction: TextInputAction.next,
                          obscureText: passwordVisible2,
                          //textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                              BorderSide(width: 1, color: Colors.white),
                            ),
                            // fillColor: Colors.orange,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Confirm Password',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.white,),
                            contentPadding: EdgeInsets.all(10),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible2
                                  ? Icons.visibility_off
                                  : Icons.visibility,color: Colors.white),
                              onPressed: () {
                                setState(
                                      () {
                                    passwordVisible2 = !passwordVisible2;
                                  },
                                );
                              },
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Re-enter Your Password';
                            } else if (value != Password.text)
                              return "Password does not match";
                          },
                        ),
                        SizedBox(height: 50,),
                        AppButton((){
                          if (_formKey.currentState!.validate()){
                            setState(() {
                              loader=true;
                            });
                            Repository().updatePassword(id: SharedPreferencesFunctions().getLoginUserId(),password: ConfirmPassword.text, context: context).then((value){
                              setState(() {
                                loader=false;
                              });
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            });
                          }
                        }, "Next"),
                      ],
                      Spacer(),
        ]),
                  loader?Positioned.fill(
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ):Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
