import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../services/auth_methods.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'IdleMineDrawer.dart';
import 'login_screen.dart';

class AccountDelete extends StatefulWidget {
  const AccountDelete({Key? key}) : super(key: key);

  @override
  State<AccountDelete> createState() => _AccountDeleteState();
}

class _AccountDeleteState extends State<AccountDelete> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  List<BalanceData> balanceData=[];
  var password=TextEditingController();
  double Balance=00;
  double Balance1v1=00;
  final emailController=TextEditingController();
  final confirmPassword=TextEditingController();
  @override
  void initState() {
    // isRealDevices(context);
    getConnectivity(context);
    //secureScreen();
    super.initState();
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
    Repository().getBalance(id: SharedPreferencesFunctions().getLoginUserId()!)
        .then(
            (value) {
          print('getBalance');
          value!.forEach(
                  (element) {
                print("elementtttt$element");
                setState(() {
                  balanceData.add(element);
                  if (balanceData.isEmpty) {
                    Balance = 00;
                    Balance1v1=00;
                  } else {
                    Balance = balanceData[0].moneyInWallet!.toDouble();
                    Balance1v1=balanceData[0].moneyInWallet1V1!.toDouble();
                  }
                });
                print("gameList=============$BalanceData");
              });
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: IdleMineDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(children: [
            SecondAppBar(context, "", Balance.toStringAsFixed(4), Balance1v1.toStringAsFixed(4)),
            SizedBox(height: 30,),
            Text("Account Deactivate",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 25)),
            SizedBox(height: 30,),
            TextFormField(
              controller: emailController,
                style: TextStyle(color: AppColors.white),
                inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
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

            SizedBox(height: 20,),
            SizedBox(height: 30,),
           AppButton(
                   () async {
                 if(emailController.text.isEmpty){
                   showToast("Enter Your Email");
                 }else if(emailController.text!=SharedPreferencesFunctions().getLoginEmail()){
                   showToast("Your Email Address is Incorrect");
                 }else{
                   print(SharedPreferencesFunctions().getLoginEmail());
                   print(emailController.text);
                   showDialog(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: Text('Deactivate App'),
                       content: Text('Are you Sure you want to deactivate this account?'),
                       actions: [
                         ElevatedButton(
                           onPressed: () async {
                             await Repository().deactivateAccount(email:emailController.text,status: 0,context: context).then((value){
                               SharedPreferencesFunctions().logout();
                               AuthMethods().logOutFromGoogle();
                               Navigator.push(
                                   context, MaterialPageRoute(builder: (context) => LoginScreen()));

                             });

                           },style: ButtonStyle(
                             shape: MaterialStatePropertyAll(
                               StadiumBorder(),
                             ),
                             backgroundColor: MaterialStatePropertyAll(
                               AppColors.appcolordmiddark,
                             )),
                           child: Text('Yes'),
                         ),
                         ElevatedButton(
                           onPressed: () => Navigator.of(context).pop(false),
                           style: ButtonStyle(
                               shape: MaterialStatePropertyAll(
                                 StadiumBorder(),
                               ),
                               backgroundColor: MaterialStatePropertyAll(
                                 AppColors.appcolordmiddark,
                               )),
                           child: Text('No'),
                         ),

                       ],
                     ),
                   );
                 }
               },
               "Deactivate My Account"),

          ]),
        ),
      ),
    );
  }
}

