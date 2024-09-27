import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:idlemine_latest/screens/win_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/gameplay_model.dart';
import '../models/getbalance_model.dart';
import '../models/multiplayergamelist_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class MultiplayerGameplay extends StatefulWidget {
  List<Thumbconfig> thumbconfig=[];
  var gameAmount;
  var gameId;
  var firstUserEmail;
  var secondUserEmail;
  MultiplayerGameplay({Key? key,required this.thumbconfig,required this.gameAmount,required this.gameId, required this.firstUserEmail, required this.secondUserEmail}) : super(key: key);

  @override
  State<MultiplayerGameplay> createState() => _MultiplayerGameplayState();
}

class _MultiplayerGameplayState extends State<MultiplayerGameplay> with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  bool isMPRealDevice = true;
  bool isMPSafeDevice = false;
  bool isMPDevelopmentModeEnable = false;
  List<GamePlayModel> GamePlayData=[];
  int seconds=0;
  int? lossSecond;
  Timer? countdownTimer;
  Timer? gameCountdownTimer;
  Timer? LossCountdownTimer;
  var isping=true;
  var timeStart="";
  List<Thumbconfig> multiplayThumbconfig=[];
  Duration myDuration = Duration(seconds: 1);
  Duration myGameDuration = Duration(seconds: 0);
  Duration? myLossDuration;
  int? remainingTime1;
  int? remainingTime2;
  int? remainingTime3;
  int? remainingTime4;
  int? remainingTime5;
  Offset oldPosition = Offset(0, 0);
  var count=0;
  var onMoveCount=0;
  var tap=0;
  var _timer;
  var _timer2;
  var _timer3;
  int? pressTime;
  int? totalTime;
  var isTap= "false";
  var top;
  var bottom;
  var right;
  var left;
  var num4=Random().nextInt(200);
  int i=0;
  var x=0;
  int y=0;
  var index;
  var previousindex;
  var thumbindex=0;
  var isLoading=false;
  var pingStatus;
  List<BalanceData> balanceData=[];
  List<BalanceData> checkBalance=[];
  double Balance=00;
  double Balance1v1=00;
  var isStart=false;


  @override
  void initState() {
    // multiisRealDevices(context);
    checkmultiplayerNet(context);
    //secureScreen();
    super.initState();
    multiplayThumbconfig=widget.thumbconfig;
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
    WidgetsBinding.instance.addObserver(this);
    getBalance();

    right=num4;
    i=0+int.parse(multiplayThumbconfig[thumbindex].timechange);
    startLossTimer();
    startGameTimer();
    if(isping){
      pingCheck(0);
    }
  }
  getBalance() async {
    Uri uri = Uri.parse("${baseurl}api/admin/user/get-user-wallet-balance?userId=${SharedPreferencesFunctions().getLoginUserId()}");
    var response = await http.get(
      uri,
      headers: {
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid':SharedPreferencesFunctions().getLoginUserId()!,
      },
    );

    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print("success");
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],"FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp) as List;
      print(responseBody);
      setState(() {
        Balance=responseBody.first["moneyInWallet"].toDouble();
        Balance1v1=responseBody.first["moneyInWallet1v1"].toDouble();
      });

    }
    else {
      print("failed");
      print(jsonDecode(response.body));
    }
  }
  @override
  void dispose() {
    super.dispose();
    AudioPlayer().pause();
    WidgetsBinding.instance.removeObserver(this);
    stopGameTimer();
    _timer?.cancel();
    _timer2?.cancel();
    if(count==1){
      _timer3?.cancel();
    }
    stopTimer();
      stopLossTimer();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if(isStart==true) {
        print("didChangeAppLifecycleState");
        if(isping){
          pingCheck(3);
        }
      }
    }
    // Your code to close the app
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final countSeconds = strDigits(myDuration.inSeconds.remainder(60));
    final countGameSeconds = strDigits(myGameDuration.inSeconds.remainder(60));
    final countGameMinute = strDigits(myGameDuration.inMinutes.remainder(60));
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TabScreen(index: 0,),
            ));
        stopGameTimer();
        _timer?.cancel();
        _timer2?.cancel();
        if(count==1){
          _timer3?.cancel();
        }
        stopTimer();
          stopLossTimer();



        return true;

      },
      child: Scaffold(
          key: scaffoldKey,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
            ),
            child:isLoading? Center(child:
            Column(
              children: [
                SizedBox(height: 100,),
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 70,
                  ),
                ),
                SizedBox(height: 20,),
                Text("Please Wait...",style: TextStyle(color: Colors.white),)
              ],
            ),):
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SecondAppBar(context, "",Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
                 Row(children: [
                   Text(
                   '${widget.firstUserEmail!.substring(0,6)}',
                   style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                       color:  AppColors.appcolordmiddark),
                 ),
                   Text("***", style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                       color: Colors.white),),
                   Text(
                     '${widget.firstUserEmail.substring(widget.firstUserEmail.length-10,widget.firstUserEmail.length)}',
                     style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                         color: AppColors.appcolordmiddark),
                   ),
                   Spacer(),
                   Text("VS",style: TextStyle(color: Colors.white),),
                   Spacer(),
                   Text(
                     '${widget.secondUserEmail!.substring(0,6)}',
                     style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                         color:  AppColors.appcolordmiddark),
                   ),
                   Text("***", style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                       color: Colors.white),),
                   Text(
                     '${widget.secondUserEmail.substring(widget.secondUserEmail.length-10,widget.secondUserEmail.length)}',
                     style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                         color: AppColors.appcolordmiddark),
                   ),
                 ],),
                  SizedBox(height: 40,),
                  Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/2,
                          width: MediaQuery.of(context).size.width-20,
                        ),
                        if(right==null&&left==null&&bottom==null&&top==null)...[]else
                          AnimatedPositioned(
                            right: right==null?null:right.toDouble(),
                            left:  left==null?null:left.toDouble(),
                            bottom: bottom==null?null:bottom.toDouble(),
                            top:  top==null?null:top.toDouble(),
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.fastOutSlowIn,
                            child: Column(
                              children: [
                                GestureDetector(
                                    onLongPressStart: (obj) =>
                                    {
                                     setState(() {
                                    isTap = "true";
                                     }),
                                      print("istap===$isTap"),
                                      // multiisRealDevices(context),
                                      print("tap==$tap"),
                                        stopLossTimer(),
                                      oldPosition = obj.localPosition,

                                      timeStart="stop",
                                      print("second===$seconds"),
                                      print("i===$i"),
                                      print("timee===${i-seconds}"),
                                      _timer = Timer(
                                          Duration(
                                              milliseconds: (i-seconds)*1000), () { // time duration
                                        setState(() {
                                          isTap = "false";
                                          pressTime = int.parse(countSeconds);
                                        });
                                      }),
                                      setState(() {
                                        startCountTimer();
                                        if(tap==0){
                                          _timer2=Timer(
                                              Duration(seconds: int.parse(multiplayThumbconfig[thumbindex].timechange)-seconds),
                                                  () {
                                                index=Random().nextInt(8);
                                                previousindex=index;
                                                print("index---$index");
                                                x++;
                                                y= y+int.parse(multiplayThumbconfig[thumbindex].timechange);
                                                count = 0;
                                                i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                                                onMoveCount=1;
                                                _timer3=Timer(
                                                    Duration(seconds: 1),
                                                        () {
                                                      startLossTimer();
                                                    });
                                              });
                                          tap++;
                                        }

                                        print("isTap$isTap");
                                        // Vibration.vibrate();
                                        onMoveCount=0;
                                      }),
                                      print("step2"),
                                      sharedPreferences!.remove('Isloginstatus'),
                                      Repository().isLogin(token: SharedPreferencesFunctions().getLoginToken()!,context: context).then((value) async {
                                        print("step3");
                                        if(SharedPreferencesFunctions().getIsloginstatus()=="0"){
                                          Navigator.push(context, new MaterialPageRoute(builder: (context) => LoginScreen()));
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.clear();
                                          SharedPreferencesFunctions().logout();
                                          GoogleSignIn googleSignIn = GoogleSignIn();
                                          await googleSignIn.signOut();
                                        }
                                      }),
                                    print("step4"),
                                    },
                                    onLongPressMoveUpdate: (obj){
                                      double diffY = obj.localPosition.dy - oldPosition.dy;
                                      double diffX = obj.localPosition.dx - oldPosition.dx;
                                      if (diffX > 30 || diffX < -30 || diffY > 30 || diffY < -30) {
                                        setState(() {
                                          _timer?.cancel();
                                          _timer2?.cancel();
                                          isTap="false";
                                          pressTime=int.parse(countSeconds);
                                          print("onLongPressMoveUpdate");
                                          if(isping) {
                                            pingCheck(3);
                                          }
                                        });
                                        //onMoveCount++;

                                      }
                                    },
                                    onLongPressEnd : (_) =>
                                    {
                                      if(onMoveCount==0){
                                        setState(() {
                                          _timer?.cancel();
                                          _timer2?.cancel();
                                          isTap="false";
                                          pressTime=int.parse(countSeconds);
                                          print("onLongPressEnd");
                                          if(isping) {
                                            pingCheck(3);
                                          }

                                        })
                                      }else
                                        setState(() {
                                          _timer?.cancel();
                                          _timer2?.cancel();
                                          isTap="false";
                                          pressTime=int.parse(countSeconds);
                                          stopTimer();
                                        })

                                    },
                                    child: Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:isTap=="true"?AssetImage("assets/images/btn2.gif")
                                                        : AssetImage("assets/images/thumb_still.png"),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.all(Radius.circular(10))),
                                          ),
                                          // Positioned.fill(
                                          //   child:Align(
                                          //     alignment: Alignment.center,
                                          //     child: timeStart=="start"? Text(lossSecond.toString(),style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.w600),):Text(""),),
                                          // )
                                        ]
                                    )
                                ),
                              ],
                            ),
                          ),
                      ]),


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
                        'Time Elapsed ($countGameMinute : $countGameSeconds) ${timeStart=="start"?"(${lossSecond.toString()})":""}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  void startCountTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final second = myDuration.inSeconds + reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: second);
        pressTime=second;
      }
    });
  }

  void startGameTimer() {
    isStart=true;
    gameCountdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setGameCountDown());

  }

  void stopGameTimer() {
    isStart=false;
    setState(() => gameCountdownTimer!.cancel());
  }

  void setGameCountDown() {
    final reduceSecondsBy = 1;

    setState(() {
      seconds = myGameDuration.inSeconds + reduceSecondsBy;

        if (index == 1) {
          right = null;
          left = 0;
          top = 0;
          bottom = null;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                  startLossTimer();
                });
          }
        }
        else if (index == 2) {
          right = null;
          left = 0;
          top = null;
          bottom = MediaQuery
              .of(context)
              .size
              .height / 2 / 4;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                  startLossTimer();
                });
          }
        }
        else if (index == 3) {
          right = null;
          left = 0;
          top = null;
          bottom = 0;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                  i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                  startLossTimer();
                });
          }
        }
        else if (index == 4) {
          right = MediaQuery
              .of(context)
              .size
              .width / 4;
          left = null;
          top = null;
          bottom = 0;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                  startLossTimer();
                });
          }
        }
        else if (index == 5) {
          right = 0;
          left = null;
          top = null;
          bottom = 0;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                  startLossTimer();
                });
          }
        }
        else if (index == 6) {
          right = 0;
          left = null;
          top = null;
          bottom = MediaQuery
              .of(context)
              .size
              .height / 2 / 4;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                  startLossTimer();
                });
          }
        }
        else if (index == 7) {
          right = 0;
          left = null;
          top = 0;
          bottom = null;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                      startLossTimer();
                });
          }
        }
        else if (index == 8) {
          right = MediaQuery
              .of(context)
              .size
              .width / 4;
          left = null;
          top = 0;
          bottom = null;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                      startLossTimer();
                });
          }
        }
        else if (index == 0) {
          right = MediaQuery
              .of(context)
              .size
              .width / 4;
          left = null;
          top = null;
          bottom = MediaQuery
              .of(context)
              .size
              .height / 2 / 4;
          if (seconds == y + int.parse(multiplayThumbconfig[thumbindex].timechange)) {
            index = Random().nextInt(8);
            if (previousindex == index) {
              index = Random().nextInt(8);
            }
            previousindex = index;
            y = y + int.parse(multiplayThumbconfig[thumbindex].timechange);
            count = 1;
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                      i = i + int.parse(multiplayThumbconfig[thumbindex].timechange);
                      startLossTimer();
                });
            x = 1;
          }
        }
      if(seconds == int.parse(multiplayThumbconfig[thumbindex].timeforstart)) {
        if(thumbindex<multiplayThumbconfig.length-1){
          thumbindex++;
          print("ifthumbindex$thumbindex");
        }else{
          thumbindex=multiplayThumbconfig.length-1;
          print("elsethumbindex$thumbindex");
        }
      }

      myGameDuration = Duration(seconds: seconds);
    });
  }







  void startLossTimer() {
    lossSecond=int.parse(multiplayThumbconfig[thumbindex].skillchecktime);
    myLossDuration = Duration(seconds: int.parse(multiplayThumbconfig[thumbindex].skillchecktime));
    setState(() {
      timeStart="start";
    });

    LossCountdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) {
          final reduceSecondsBy = 1;
          setState(() {
            lossSecond = myLossDuration!.inSeconds - reduceSecondsBy;
            if (lossSecond! <= 0) {
              LossCountdownTimer!.cancel();
              if(isping) {
                pingCheck(3);
              }
              print("LossCountdownTimer");
            } else {
              myLossDuration = Duration(seconds: lossSecond!);
            }
          });
        });
  }

  void stopLossTimer() {
    setState(() {
      timeStart="stop";
    });
    setState(() => LossCountdownTimer!.cancel());
  }

  showLossDialog(){
    checkmultiplayerNet(context);
    setState(() {
      isLoading=true;
      isStart=false;
      if(tap!=0) {
        stopGameTimer();
        _timer?.cancel();
        _timer2?.cancel();
        if (count == 1) {
          _timer3?.cancel();
        }
        stopTimer();
      }
        stopLossTimer();


      //Repository().playGame(userId: SharedPreferencesFunctions().getLoginUserId()!.toString(),gameId: widget.gameId.toString(),is_win: 0,spendTime: pressTime==null?0:pressTime!,historyid: GamePlayData.first.id,context: context);
      if(Sound==true) {
        PlaySound("sad.wav");
      }
      setState(() {
        isLoading=false;
      });
      StopSound();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WinPage(count: 0,isfreegame:widget.gameAmount==0?true:false),
          ));
    });
  }

  showWinDialog(){
    checkmultiplayerNet(context);
    setState(() {
      stopLossTimer();
      isLoading=true;
      isStart=false;
      if(tap!=0) {
        stopGameTimer();
        _timer?.cancel();
        _timer2?.cancel();
        if (count == 1) {
          _timer3?.cancel();
        }
        stopTimer();
      }
      if(Sound==true) {
        PlaySound("clap.wav");
      }
      setState(() {
        isLoading=false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WinPage(count: 1,isfreegame:widget.gameAmount==0?true:false),
          ));
    });
  }


  checkmultiplayerNet(Context){
    subscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      isDeviceConnected=await InternetConnectionChecker().hasConnection;
      if(isDeviceConnected==false && isAlertSet==false){
        setState(() {
          isStart=false;
          stopGameTimer();
          _timer?.cancel();
          _timer2?.cancel();
          if(count==1){
            _timer3?.cancel();
          }
          stopTimer();
          stopLossTimer();

        });
        Navigator.push(
            Context,
            MaterialPageRoute(
                builder: (context) => TabScreen(index: 0,)));
        showDialogBox(Context);
        isAlertSet =true;
      }
    });
  }


  // multiisRealDevices(context) async {
  //   try {
  //     isMPRealDevice = await SafeDevice.isRealDevice;
  //     isMPSafeDevice = await SafeDevice.isSafeDevice;
  //     isMPDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
  //   } catch (error) {
  //     print(error);
  //   }
  //   isMPRealDevice = isMPRealDevice;
  //   isMPSafeDevice = isMPSafeDevice;
  //   isMPDevelopmentModeEnable = isMPDevelopmentModeEnable;
  //   setState(() {
  //   });
  //   print("isDevelopmentModeEnable====$isDevelopmentModeEnable");
  //   print("checkBuildConfig${checkBuildConfig()}");
  //   List<String> harmfulFoldersPaths = [
  //     '/storage/emulated/0/storage/secure',
  //     '/storage/emulated/0/Android/data/com.android.ld.appstore',
  //   ];
  //   if (await multicheckBuildConfig()||multianyFolderExists(harmfulFoldersPaths)) {
  //     showToast("This app is not workable on emulator");
  //     exit(0);
  //   }else if(isDevelopmentModeEnable==true){
  //     print("isStart$isStart");
  //     setState(() {
  //       if (isStart) {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(index: 0),));
  //       }
  //     });
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: () => Future.value(false),
  //           child: AlertDialog(
  //             title: Text("Warning"),
  //             content: Text("Please Disable Developer Options"),
  //             actions: [
  //               TextButton(onPressed: (){
  //                 exit(0);
  //               }, child: Text("Ok"))
  //             ],
  //           ),
  //         );
  //       },);
  //   }else {
  //     //showToast("this is real device");
  //   }
  // }

  Future<bool> multicheckBuildConfig() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    bool isEmulator = (androidInfo.manufacturer.contains('Genymotion') ||
        androidInfo.manufacturer.contains('LDPlayer')||
        androidInfo.manufacturer.contains('Memu')||
        androidInfo.model.contains('google_sdk') ||
        androidInfo.model.toLowerCase().contains('droid4x') ||
        androidInfo.hardware.toLowerCase().contains('intel')||
        androidInfo.host == 'ubuntu' && androidInfo.device == 'aosp'||
        androidInfo.brand.startsWith("generic") && androidInfo.device.startsWith("generic")
        || androidInfo.fingerprint.startsWith("generic")
        || androidInfo.fingerprint.startsWith("unknown")
        || androidInfo.hardware.contains("goldfish")
        || androidInfo.hardware.contains("ranchu")
        || androidInfo.model.contains("google_sdk")
        || androidInfo.model.contains("Emulator")
        || androidInfo.model.contains("Android SDK built for x86")
        || androidInfo.manufacturer.contains("Genymotion")
        || androidInfo.product.contains("sdk_google")
        || androidInfo.product.contains("google_sdk")
        || androidInfo.product.contains("sdk")
        || androidInfo.product.contains("sdk_x86")
        || androidInfo.product.contains("vbox86p")
        || androidInfo.product.contains("emulator")
        || androidInfo.product.contains("simulator")||
        Platform.isAndroid &&
            (androidInfo.model.contains('Emulator') ||
                androidInfo.model.contains('Android SDK built for x86') ||
                androidInfo.hardware == 'goldfish' ||
                androidInfo.hardware == 'vbox86' ||
                androidInfo.hardware.toLowerCase().contains('nox') ||
                androidInfo.product == 'sdk' ||
                androidInfo.product == 'google_sdk' ||
                androidInfo.product == 'sdk_x86' ||
                androidInfo.product == 'vbox86p' ||
                androidInfo.product.toLowerCase().contains('nox') ||
                androidInfo.board.toLowerCase().contains('nox') ||
                (androidInfo.board == 'QC_Reference_Phone') ||
                androidInfo.host.startsWith('Build')||
                (androidInfo.brand.startsWith('generic') &&
                    androidInfo.device.startsWith('generic'))));
    return isEmulator;
  }

  bool multianyFolderExists(List<String> foldersPaths) {
    for (String folderPath in foldersPaths) {
      if (Directory(folderPath).existsSync()) {
        return true;
      }
    }
    return false;
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
        if (jsonDecode(response.body)['status'].toString() == "3") {
          setState(() {
            isping=false;
          });
          showLossDialog();
        }else if (jsonDecode(response.body)['status'].toString() == "4") {
          setState(() {
            isping=false;
          });
         showWinDialog();
        } else {
          if(isping){
            pingCheck(0);
          }
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
}