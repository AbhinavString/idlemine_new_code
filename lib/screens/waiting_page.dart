import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/multiplayergamelist_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';
import 'multiplayer_gameplay.dart';

class WaitingPage extends StatefulWidget {
  List<Thumbconfig> thumbconfig=[];
  var gameAmount;
  var gameId;
   WaitingPage({Key? key, required this.thumbconfig,required this.gameAmount,required this.gameId}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage>  with WidgetsBindingObserver{
  Timer? CountdownTimer;
  Duration myDuration = Duration(seconds: 0);
  int? Second;
  Timer? timer;
var pingStatus;
var isback=false;

  @override
  void initState() {
    super.initState();
    getConnectivityWp();
    startTimer();
    pingCheck(0);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.paused||state == AppLifecycleState.inactive) {
      if (mounted) {
        CountdownTimer!.cancel();
        isback = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TabScreen(index: 0,)),
        );
      }
    }
    super.didChangeAppLifecycleState(state);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CountdownTimer!.cancel();
  }
  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final countGameSeconds = strDigits(myDuration.inSeconds.remainder(60));
    final countGameMinute = strDigits(myDuration.inMinutes.remainder(60));
    return WillPopScope(
      onWillPop: () async{
        setState(() {
          CountdownTimer!.cancel();
          isback=true;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TabScreen(index: 0,)),
        );
        return true;
      },
      child: Scaffold(
        body:  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 80,),
                    Text("Please wait...",style: TextStyle(fontSize: 20,color: Colors.white),),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      width:  MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff240E3F),
                      ),
                      child: Center(
                        child: Text(
                          'Waiting Time($countGameMinute : $countGameSeconds)',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),

                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
  void startTimer() {
    myDuration = Duration(seconds: 0);
    CountdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) {
          final reduceSecondsBy = 1;
          setState(() {
            Second = myDuration!.inSeconds + reduceSecondsBy;
            myDuration = Duration(seconds: Second!);
            });
          // if(Second==180){
          //   showAlertBox();
          // }
          });
  }

  pingCheck(status) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/1v1game/pingcheck");
      var response = await http.post(
          uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid':SharedPreferencesFunctions().getLoginUserId()!,},
          body:  jsonEncode({
            "gameHistoryId":widget.gameId,
            "usreId":SharedPreferencesFunctions().getLoginUserId(),
            "status":status
          })
      );
      if (response.statusCode == 200) {
       print(jsonDecode(response.body));
       print("jsonDecode(response.body)['data'].first['secondUserEmail']==${jsonDecode(response.body)['data'].first['secondUserEmail'].toString()}");
        if (jsonDecode(response.body)['status'] == 2&&jsonDecode(response.body)['data'].first['firstUserEmail']!=""&&jsonDecode(response.body)['data'].first['secondUserEmail']!="") {
          final responseBody = jsonDecode(response.body)['data'] as List;
          setState(() {
            CountdownTimer!.cancel();
            isback=true;
          });
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      MultiplayerGameplay(thumbconfig: widget.thumbconfig,
                        firstUserEmail:responseBody.first['firstUserEmail'],
                        secondUserEmail:responseBody.first['secondUserEmail'] ,
                        gameAmount: widget.gameAmount,
                        gameId: widget.gameId,)));
        }else if(isback){

        } else {
          pingCheck(0);
        }
      }else if(response.statusCode == 403){
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    LoginScreen()));
      }else{
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  showAlertBox(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10)),
            child: WillPopScope(
              onWillPop: () async{
                Navigator.pop(context);
                return true;
              },
              child: AlertDialog(
                actionsAlignment: MainAxisAlignment
                    .spaceAround,
                content: Text(
                  'Are you still want to wait or quit?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,),),
                //contentTextStyle: TextStyle(fontSize: 18,),
                actions: [
                  ElevatedButton(
                    onPressed:() {
                      setState(() {
                        CountdownTimer!.cancel();
                        isback=true;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => TabScreen(index: 0,)),
                      );
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          StadiumBorder(
                              side: BorderSide(
                                  color: Colors
                                      .pink)),
                        ),
                        minimumSize: MaterialStatePropertyAll(
                            Size(100, 40)),
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.white,
                        )),
                    child: Text(
                        'Quit', style: TextStyle(
                      color: Colors.pink,)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        StadiumBorder(),
                      ),
                      minimumSize: MaterialStatePropertyAll(
                          Size(100, 40)),
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.pink,
                      )),
                    child: Text('Wait'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
  getConnectivityWp(){
    print("getConnectivityWp");
    subscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      isDeviceConnected=await InternetConnectionChecker().hasConnection;
      print("isDeviceConnected=============>$isDeviceConnected");
      if(isDeviceConnected==false && isAlertSet==false){
        showDialogBox(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TabScreen(index: 0,)));
        print("device disconnect");
        isAlertSet =true;

      }
    });
  }
}
