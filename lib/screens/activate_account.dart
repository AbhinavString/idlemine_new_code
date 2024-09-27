import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/custom_widget.dart';
import '../reposiratory/repo.dart';
import 'login_screen.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({Key? key}) : super(key: key);

  @override
  State<ActivateAccount> createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  var email=TextEditingController();
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
                          Repository().activateAccount(email: email.text,status: 4,context: context).then((value){
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: Text("Reactive Account"),
                            //       content: Text(" Your activation request is submitted. Please wait for sometime to reactivate your account!"),
                            //       actions: [
                            //         TextButton(
                            //           child: Text("OK"),
                            //           onPressed: () {
                            //             Navigator.push(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) => LoginScreen()));
                            //           },
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          });
                        }
                      });

                    }, "Next"),
                  Spacer(),
                ]),
          ),
        ),
      ),
    );
  }
}
