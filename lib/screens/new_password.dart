import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/custom_widget.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool passwordVisible=true;
  bool passwordVisible2=true;
  var loader= false;
  final _formKey = GlobalKey<FormState>();
  var email=TextEditingController();
  var Password=TextEditingController();
  var ConfirmPassword=TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  var ontap="";
  var otp=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                          }, "Submit"),
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
