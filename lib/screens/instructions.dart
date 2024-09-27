import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key}) : super(key: key);

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  bool value = false;
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  final _controller=PageController();
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //secureScreen();
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
                    Balance1v1= balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
              });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
        ),child: Padding(
          padding: const EdgeInsets.only(right: 20,left: 20),
          child: Column(
          children: [
            SecondAppBar(context, "", Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
            SizedBox(height: 80,),
            Container(
              height: MediaQuery.of(context).size.height/2.5,
              child: PageView(
                controller: _controller,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Don't : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),),
                          Text("Don’t lift your finger.",style: TextStyle(color: Colors.white,fontSize: 16)),
                         Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                       Image.asset("assets/images/Animation-3.gif",height: 50,),
                      SizedBox(height: 30,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Do : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),),
                          Container(
                              width: MediaQuery.of(context).size.width/2.5,
                              child: Text("Press and hold the button",style: TextStyle(color: Colors.white,fontSize: 16))),
                          Spacer(),
                          Icon(Icons.check_circle,color: Color(0xff12D202),),

                        ],
                      ),
                      Image.asset("assets/images/Animation-4.gif",height: 50,),
                    ],
                  ),

                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Don't : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),),
                            Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                child: Text("Don’t swipe in the button area.",style: TextStyle(color: Colors.white,fontSize: 16))),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Image.asset("assets/images/Animation-3.gif",height: 50,),
                        SizedBox(height: 30,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Do : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),),
                            Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                child: Text("Press and hold the button.",style: TextStyle(color: Colors.white,fontSize: 16))),
                            Spacer(),
                            Icon(Icons.check_circle,color: Color(0xff12D202),),

                          ],
                        ),
                        Image.asset("assets/images/Animation-4.gif",height: 50,),
                      ],
                    ),

                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Don't : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),),
                            Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                child: Text("Don’t swipe finger while skill check.",style: TextStyle(color: Colors.white,fontSize: 16))),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Image.asset("assets/images/Animation-5.gif",height: 50,),
                        SizedBox(height: 30,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Do : ",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 16),),
                            Container(
                                width: MediaQuery.of(context).size.width/2.5,
                                child: Text("Lift the finger and then press button.",style: TextStyle(color: Colors.white,fontSize: 16))),
                            Spacer(),
                            Icon(Icons.check_circle,color: Color(0xff12D202),),
                          ],
                        ),
                        Image.asset("assets/images/Animation-4.gif",height: 50,),
                      ],
                    ),

                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildDots(),
              ),
            ),
             SizedBox(height: 20,),
            // Row(children: [
            //   Checkbox(
            //     fillColor: MaterialStatePropertyAll(AppColors.appcolordmiddark),
            //     checkColor: AppColors.white,
            //     value: this.value,
            //     onChanged: (value) {
            //       setState(() {
            //         this.value = value!;
            //       });
            //     },
            //   ),
            //   Text("Don’t show me again",style: TextStyle(fontSize: 14,color: AppColors.white),),
            // ],),
            AppButton((){
              if (_currentPage < 2) {
                _navigateToPage(_currentPage + 1);
              }else{
                setState(() {
                  _navigateToPage(_currentPage - 2);
                });
              }
            }, "Next"),
          ],
      ),
        ),
      ),
    );
  }
  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < 3; i++) {
      // Replace 3 with the number of pages you have
      dots.add(
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _currentPage == i ? 10.0 : 10.0,
          height: 10.0,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: _currentPage == i ?  Colors.pink: Colors.grey,
          ),
        ),
      );
    }
    return dots;
  }

  void _navigateToPage(int page) {
    print(page);
    _controller.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
