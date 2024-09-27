import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:idlemine_latest/screens/win_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/EncryptDecryptUtil.dart';
import '../constants/add_helper.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/gameplay_model.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class HoldToEarn extends StatefulWidget {
  var gameDuration;
  var thumbDuration;
  var gameId;
  var gameAmount;
  HoldToEarn({Key? key, required this.gameDuration, required this.thumbDuration,required this.gameId,required this.gameAmount,}) : super(key: key);

  @override
  State<HoldToEarn> createState() => _HoldToEarnState();
}

class _HoldToEarnState extends State<HoldToEarn> with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  bool isGPRealDevice = true;
  bool isGPSafeDevice = false;
  bool isGPDevelopmentModeEnable = false;
  List<GamePlayModel> GamePlayData=[];
  int seconds=0;
  int? lossSecond;
  Timer? countdownTimer;
  Timer? gameCountdownTimer;
  Timer? LossCountdownTimer;
  var timeStart="";
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
  var _timer4;
  int? pressTime;
  int? totalTime;
  var isTap= "false";
  var top;
  var bottom;
  var right;
  var left;
  var num1=Random().nextInt(200);
  var num2=Random().nextInt(200);
  var num3=Random().nextInt(200);
  var num4=Random().nextInt(200);
  int i=0;
  var x=0;
  int y=0;
  var index;
  var previousindex;
  BannerAd? _bannerAd1;
  var isLoading=false;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;
  final int maxFailedLoadAttempts = 3;
  List<BalanceData> balanceData=[];
  List<BalanceData> checkBalance=[];
  double Balance=00;
  double Balance1v1=00;
  var isStart=false;


  @override
  void initState() {
    // GamePageisRealDevices(context);
    checkNet(context);
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
    WidgetsBinding.instance.addObserver(this);
    getBalance();
    seconds = int.parse(widget.gameDuration);
    myGameDuration = Duration(seconds: seconds);

    right=num4;
    i=int.parse(widget.gameDuration)-int.parse(widget.thumbDuration);

    y=int.parse(widget.gameDuration);
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd1 = ad as BannerAd;
            print("_bannerAd1==>$ad");
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }


  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdHelper.interstiatalRewardAdId,
        request: AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
              print('$ad onAdShowedFullScreenContent.'),
          onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent:
              (RewardedInterstitialAd ad, AdError error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
        );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedInterstitialAd = null;
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
    if(tap!=0){
      stopLossTimer();
    }

    _rewardedInterstitialAd?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
     if(isStart==true) {
       showLossDialog();
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
        if(tap!=0){
          stopLossTimer();
        }


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
                  SizedBox(height: 30,),
                   (_bannerAd1 != null)?
                    Container(
                      width: MediaQuery.of(context).size.width-20,
                      height: 100,
                      child: AdWidget(ad: _bannerAd1!),
                    ):
                      Container(
                        width: MediaQuery.of(context).size.width-100,
                        height: 100,
                      ),
                  SizedBox(height: 20,),
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
                                      print("step1"),
                                      // GamePageisRealDevices(context),
                                    if(tap!=0) {
                                    stopLossTimer(),
                                    },
                                      oldPosition = obj.localPosition,
                                      print("step2"),
                                    timeStart="stop",
                                      _timer = Timer(
                                          Duration(
                                              milliseconds: ((seconds - i))*1000), () { // time duration
                                        setState(() {
                                          isTap = "false";
                                          pressTime = int.parse(countSeconds);
                                        });
                                      }),
                                      setState(() {
                                        startCountTimer();
                                        if(tap==0){
                                          print("step3");
                                          startGameTimer();
                                          if(Balance>=int.parse(widget.gameAmount!)){
                                            print("step4");
                                            Repository().playGame(userId: SharedPreferencesFunctions().getLoginUserId()!.toString(),gameId: widget.gameId.toString(),is_win: 1,spendTime: pressTime==null?0:pressTime!,historyid: "",context: context).then((value){
                                              value!.forEach(
                                                      (element) {
                                                    setState(() {
                                                      getBalance();
                                                      GamePlayData.add(element);
                                                    });
                                                  });
                                             });
                                          }else{
                                            showToast("Insufficient Balance");
                                          }
                                          _timer2=Timer(
                                              Duration(seconds: int.parse(widget.thumbDuration)),
                                                  () {
                                                    index=Random().nextInt(8);
                                                    previousindex=index;
                                                    print("index---$index");
                                                x++;
                                                y= y-int.parse(widget.thumbDuration);
                                                count = 0;
                                                i = i - int.parse(widget.thumbDuration);
                                                onMoveCount=1;
                                                    _timer3=Timer(
                                                        Duration(seconds: 1),
                                                            () {
                                                          startLossTimer();
                                                        });
                                              });
                                          tap++;
                                             }
                                        isTap = "true";
                                       // Vibration.vibrate();
                                        onMoveCount=0;
                                      }),
                                    sharedPreferences!.remove('Isloginstatus'),
                                    Repository().isLogin(token: SharedPreferencesFunctions().getLoginToken()!,context: context).then((value) async {
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
                                             showLossDialog();

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
                                          showLossDialog();


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
                                        ] )),
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
                        'Remaining ($countGameMinute : $countGameSeconds) ${timeStart=="start"?"(${lossSecond.toString()})":""}',
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
      seconds = myGameDuration.inSeconds - reduceSecondsBy;
      if (y > 0) {
        if (index == 1) {
          right = null;
          left = 0;
          top = 0;
          bottom = null;
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
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
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                  startLossTimer();
                });
          }
        }
        else if (index == 3) {
          right = null;
          left = 0;
          top = null;
          bottom = 0;
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
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
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                  startLossTimer();
                });
          }
        }
        else if (index == 5) {
          right = 0;
          left = null;
          top = null;
          bottom = 0;
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
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
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                  startLossTimer();
                });
          }
        }
        else if (index == 7) {
          right = 0;
          left = null;
          top = 0;
          bottom = null;
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
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
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
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
          if (seconds == y - int.parse(widget.thumbDuration)) {
            index = Random().nextInt(8);
            print("index---$index");
            print("previousindex---$previousindex");
            if (previousindex == index) {
              index = Random().nextInt(8);
              print("index---$index");
            }
            previousindex = index;
            y = y - int.parse(widget.thumbDuration);
            count = 1;
            i = i - int.parse(widget.thumbDuration);
            onMoveCount = 1;
            _timer3 = Timer(
                Duration(seconds: 1),
                    () {
                  startLossTimer();
                });
            x = 1;
          }
        }
      }


      if (seconds < 0) {
        gameCountdownTimer!.cancel();
        setState(() {
          stopLossTimer();
          isLoading=true;
          //totalTime=int.parse(widget.gameDuration)-pressTime// ;
          isStart=false;
          checkNet(context);
          print("pressTime $pressTime");
          _timer?.cancel();
          _timer2?.cancel();
          _timer3?.cancel();
         Repository().playGame(userId: SharedPreferencesFunctions().getLoginUserId()!.toString(),gameId: widget.gameId.toString(),is_win: 1,spendTime: pressTime==null?0:pressTime!,historyid: GamePlayData.first.id,context: context);
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

          // _timer4=Timer(
          //     Duration(seconds: 2),
          //         () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => TabScreen()));
          //     });
        });
      } else {
        myGameDuration = Duration(seconds: seconds);
        //seconds= seconds;
      }
    });
  }







  void startLossTimer() {
    lossSecond=2;
    myLossDuration = Duration(seconds: 2);
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
              showLossDialog();
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
    checkNet(context);
    setState(() {
      isLoading=true;
    isStart=false;
      stopGameTimer();
    _timer?.cancel();
    _timer2?.cancel();
    if(count==1){
      _timer3?.cancel();
    }
    stopTimer();
    if(tap!=1){
      stopLossTimer();
    }

    Timer(
          Duration(
              seconds:2), () { // time duration
        setState(() {
          Repository().playGame(userId: SharedPreferencesFunctions().getLoginUserId()!.toString(),gameId: widget.gameId.toString(),is_win: 0,spendTime: pressTime==null?0:pressTime!,historyid: GamePlayData.first.id,context: context);
        });
      });
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



  checkNet(Context){
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
          if(tap!=0){
            stopLossTimer();
          }

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


  // GamePageisRealDevices(context) async {
  //   try {
  //     isGPRealDevice = await SafeDevice.isRealDevice;
  //     isGPSafeDevice = await SafeDevice.isSafeDevice;
  //     isGPDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
  //   } catch (error) {
  //     print(error);
  //   }
  //   isGPRealDevice = isGPRealDevice;
  //   isGPSafeDevice = isGPSafeDevice;
  //   isGPDevelopmentModeEnable = isGPDevelopmentModeEnable;
  //   setState(() {
  //   });
  //   print("isDevelopmentModeEnable====$isDevelopmentModeEnable");
  //   print("checkBuildConfig${checkBuildConfig()}");
  //   List<String> harmfulFoldersPaths = [
  //     '/storage/emulated/0/storage/secure',
  //     '/storage/emulated/0/Android/data/com.android.ld.appstore',
  //   ];
  //   if (await GamePagecheckBuildConfig()||GamePageanyFolderExists(harmfulFoldersPaths)) {
  //     showToast("This app is not workable on emulator");
  //     exit(0);
  //   }else if(isDevelopmentModeEnable==true){
  //     print("isStart$isStart");
  //       if (isStart) {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen(index: 0),));
  //       }
  //       setState(() {
  //         isStart=false;
  //         stopGameTimer();
  //         _timer?.cancel();
  //         _timer2?.cancel();
  //         if(count==1){
  //           _timer3?.cancel();
  //         }
  //         stopTimer();
  //         if(tap!=0){
  //           stopLossTimer();
  //         }

  //       });
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
  //     showToast("this is real device");
  //   }
  // }

  Future<bool> GamePagecheckBuildConfig() async {
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

  bool GamePageanyFolderExists(List<String> foldersPaths) {
    for (String folderPath in foldersPaths) {
      if (Directory(folderPath).existsSync()) {
        return true;
      }
    }
    return false;
  }
}