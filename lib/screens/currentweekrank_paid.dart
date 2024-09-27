import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/globalranking_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class CurrentRankPaid extends StatefulWidget {
  const CurrentRankPaid({Key? key}) : super(key: key);

  @override
  State<CurrentRankPaid> createState() => _CurrentRankPaidState();
}

class _CurrentRankPaidState extends State<CurrentRankPaid> {
  var isloader=true;
  List<GlobalrankingData> globalrank=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //secureScreen();
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
    Repository().CurrentRankingPaid().then(
            (value) {
          setState(() {
            isloader=false;
            print("isloader===$isloader");
          });
          print('DepositeHistory');
          value!.forEach(
                  (element) {
                print("elementtttt$element");
                setState(() {
                  globalrank.add(element);
                });
                print("gameList=============$globalrank");
              });
        });
    //getConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            if(isloader)...[
              Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 70,
                ),
              )
            ]else...[
              globalrank.isEmpty?Center(child: Text("No Record Found",style: TextStyle(color: AppColors.white,fontSize: 25),)):
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rank',
                          style: TextStyle(
                              color: Colors.white),
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.white,),
                        ),
                        Text(
                          "Played Time",
                          style: TextStyle(
                            color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height-280,
                    margin: EdgeInsets.only(top: 0),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: globalrank.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var email=globalrank[index].user.first.email;
                          //int hours = int.parse(globalrank[index].!) ~/ 60;
                          // int minutes = int.parse(globalrank[index].time!) % 60;
                          return Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                            child:  Row(
                              children: [
                                Text(globalrank[index].rank.toString(),style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),),
                                Spacer(),
                                Text(
                                  '${email!.substring(0,6)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text("***", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),),
                                Text(
                                  '${email.substring(email.length-10,email.length)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Spacer(),
                                Text(
                                  "${globalrank[index].sum/60} Min",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),

            ],
          ],
        ),
      ),
    );
  }
}
