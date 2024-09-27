import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:idlemine_latest/screens/screen_webcontent.dart';
import 'package:idlemine_latest/screens/terms&condition.dart';
import 'package:idlemine_latest/screens/verifyotp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../reposiratory/repo.dart';
import '../services/auth_methods.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'forceupdate.dart';
import 'home.dart';
import 'login_screen.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<LoginData> registerDataList = [];
  bool passwordVisible=true;
  bool value = false;
  var isloading=false;
  final form_key = GlobalKey<FormState>();
  var email=TextEditingController();
  var password=TextEditingController();
  var referalcode=TextEditingController();
  var TemsCondition="NotAccepted";
  RegExp regex = RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');


 @override
  void initState() {
  //  isRealDevices(context);
   NetworkCheck(context);
    super.initState();
    //secureScreen();
   sharedPreferences!.remove('Statuscode');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bg.png"),fit: BoxFit.fill),
        ),
        child: Form(
          key: form_key,
          child: SingleChildScrollView(
            child: Container(
              color: isloading?Colors.transparent.withOpacity(0.3):Colors.transparent,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
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
                              SizedBox(height: 30,),
                              TextField(
                                controller: email,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
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
                                    contentPadding:EdgeInsets.all(10),
                                    hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                                    fillColor: Colors.transparent),
                              ),
                              SizedBox(height: 20,),
                              TextField(
                                controller: password,
                                obscureText: passwordVisible,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(width: 1, color: Colors.white),),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.white),
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
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 20,),
                              TextField(
                                controller: referalcode,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(width: 1, color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),),
                                    filled: true,
                                    hintText: 'Referral Code (Optional)',
                                    contentPadding: EdgeInsets.all(10),
                                    hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                                    fillColor: Colors.transparent),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    fillColor: MaterialStatePropertyAll(AppColors.appcolordmiddark),
                                    checkColor: AppColors.white,
                                    value: this.value,
                                    onChanged: (value) {
                                      setState(() {
                                        this.value = value!;
                                        if(TemsCondition=="accept") {
                                          TemsCondition = "NotAccepted";
                                        }else {
                                          TemsCondition="accept";
                                        }
                                      });
                                    },
                                  ),
                                  Text("I Agree to the",style: TextStyle(fontSize: 14,color: AppColors.white),),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                              TermAndCondition()));
                                    },
                                    child: Text('Terms and Conditions Policy',
                                        style: TextStyle(
                                            color: AppColors.white,fontSize: 14,
                                            decoration: TextDecoration.underline,decorationColor: AppColors.appcolordmiddark)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              AppButton(
                                      () async {
                                    if (email == null || !regex.hasMatch(email.text) ||
                                        email.text.isEmpty) {
                                      showToast('Please enter valid email');
                                    } else if (password == null || password.text.isEmpty) {
                                      showToast('Your password is required');
                                    }else if(password.text.length < 6){
                                      showToast("password Must be at least 6 Character");
                                    }
                                    else if (TemsCondition == "NotAccepted") {
                                      showToast('Accept Terms and Conditions');
                                    } else {
                                      setState(() {
                                        isloading=true;
                                        print("isloading$isloading");
                                      });
                                      await Repository()
                                          .Register(email: email.text.trim(),password: password.text.trim(),refferedBy: referalcode.text.trim(),registerBy: "0",context: context)
                                          .then(
                                              (value) {
                                            print('Register');
                                            setState(() {
                                              isloading=false;
                                            });

                                            if(SharedPreferencesFunctions().getLoginStatuscode()=="501"){
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>  ForceUpadatePage()));
                                            }
                                            else {
                                              value!.forEach(
                                                      (element) {
                                                    registerDataList.add(element);
                                                    SharedPreferencesFunctions().saveLoginUserId(element.id.toString());
                                                    SharedPreferencesFunctions().saveLoginEmail(element.email.toString());
                                                    SharedPreferencesFunctions().saveRegisterBy(element.registerBy.toString());
                                                    SharedPreferencesFunctions().saveLoginToken(element.token.toString());
                                                    print("registerDataList$registerDataList");
                                                    Repository().ResendOtp(
                                                        email: email.text,
                                                        context: context).then((
                                                        value) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  VerifyOtpScreen(
                                                                    email: email
                                                                        .text,)));
                                                    });
                                                  });
                                            }
                                          });

                                    }
                                  },
                                  "SIGN UP"),
                              SizedBox(height: 20,),
                              Text("OR",style: TextStyle(fontSize: 18,color: Colors.white70)),
                              SizedBox(height: 20,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                ),
                                onPressed: () {
                                  if (TemsCondition == "NotAccepted") {
                                    showToast('Accept Terms and Conditions');
                                  }else {
                                    sharedPreferences!.remove('Statuscode');
                                    AuthMethods().signUpWithGoogle(
                                      context,
                                    );
                                  }
                                },
                                child: SizedBox(
                                  height: 43,
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Image(
                                          image: AssetImage("assets/images/google_logo.png"),
                                          height: 27,
                                          width: 27,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20, right: 8),
                                          child: Text(
                                            'Sign up with Google',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height * .02),
                                      child: Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => LoginScreen()),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.of(context).size.height * .02,
                                            left: 10),
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Color(0xffda286f),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                  ),
                  isloading?Positioned.fill(
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
