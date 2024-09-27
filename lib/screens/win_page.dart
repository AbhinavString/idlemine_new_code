import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/add_helper.dart';
import '../main.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';


class WinPage extends StatefulWidget {
  var count;
  var isfreegame;
   WinPage({Key? key, required this.count, required this.isfreegame}) : super(key: key);

  @override
  State<WinPage> createState() => _WinPageState();
}

class _WinPageState extends State<WinPage> {
  final int maxFailedLoadAttempts = 3;
  bool? isfree;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  static final AdRequest request = AdRequest();
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  Duration? myDuration;
  Timer? CountdownTimer;
  int? Second;
  int _numRewardedInterstitialLoadAttempts = 0;
  var count;
  Timer? timer;

  @override
  void initState() {
    super.initState();
   // secureScreen();
    count=widget.count;
    isfree=widget.isfreegame;
    _createRewardedInterstitialAd();
    print("isfree $isfree");
    startTimer();
    timer=Timer(
        const Duration(
          seconds: 5,
        ), () {
      if(isfree==true) {
        _showRewardedInterstitialAd();
      }
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new TabScreen(index: 0,)));

    });
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: count==1?
        Container(
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
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80,),
                Text("YOU WIN",style: TextStyle(fontSize: 20,color: Colors.white),),
                    Spacer(),
                Image.asset("assets/images/Winning_popup.png",height: 300),
                    Spacer(),
                Text("You will be redirected to Home Screen in ${Second.toString()}:00s.",style: TextStyle(color: Colors.white)),
                SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffda286f),
                    // side: BorderSide(color: Colors.yellow, width: 5),
                    textStyle: const TextStyle(
                        color: Colors.white,fontStyle: FontStyle.normal),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    shadowColor: Colors.pinkAccent,
                    elevation: 3,
                  ),

                  onPressed: () async {
                    if(isfree==true) {
                      _showRewardedInterstitialAd();
                    }
                    stopTimer();
                    timer!.cancel();

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new TabScreen(index: 0,)));

                  }, child:   SizedBox(
                  //width: 180,
                  height: 43,
                  child: Center(
                    child: Text(
                      'Ok',style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),),
                    SizedBox(height: 50,)
              ]),
            ),
          ),
        ):
        Container(
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
                //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80,),
                    Text("YOU LOSS",style: TextStyle(fontSize: 20,color: Colors.white),),
                    Spacer(),
                    Image.asset("assets/images/Loosing_popup.png",height: 300),
                    Spacer(),
                    Text("You will be redirected to Home Screen in ${Second.toString()}:00s.",style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffda286f),
                        // side: BorderSide(color: Colors.yellow, width: 5),
                        textStyle: const TextStyle(
                            color: Colors.white,fontStyle: FontStyle.normal),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        shadowColor: Colors.pinkAccent,
                        elevation: 3,
                      ),

                      onPressed: () async {
                        stopTimer();
                        timer!.cancel();
                        if(isfree==true) {
                          _showRewardedInterstitialAd();
                        }
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new TabScreen(index: 0,)));

                      }, child:   SizedBox(
                      //width: 180,
                      height: 43,
                      child: Center(
                        child: Text(
                          'Ok',style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),),
                    SizedBox(height: 50,)
                  ]),
            ),
          ),
        ),
      ),
    );
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

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdHelper.interstiatalRewardAdId,
        request: request,
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



  void startTimer() {
    myDuration = Duration(seconds: 5);

    CountdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) {
          final reduceSecondsBy = 1;
          setState(() {
            Second = myDuration!.inSeconds - reduceSecondsBy;
            print("Second$Second");
            if (Second! <= 0) {
              CountdownTimer!.cancel();

              print("SHow pop up");
            } else {
              myDuration = Duration(seconds: Second!);
            }
          });
        });
  }

  void stopTimer() {

    setState(() => CountdownTimer!.cancel());
  }
}
