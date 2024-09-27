import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/deposite_history_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class DepositeHistory extends StatefulWidget {
  var route;
  DepositeHistory({Key? key,required this.route}) : super(key: key);

  @override
  State<DepositeHistory> createState() => _DepositeHistoryState();
}

class _DepositeHistoryState extends State<DepositeHistory> {
  List<DepositeHistoryData> deposithistoryList = [];
  var isloading=true;
  late ScrollController _controller;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _page = 1;



  @override
  void initState() {
    //secureScreen();
    _firstLoad();
    _controller = ScrollController();
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
  }



  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
      isloading=true;
    });
if(widget.route=="") {
  Repository().DepositeHistoryy(
      userId: SharedPreferencesFunctions().getLoginUserId()!,
      page: _page,
      context: context).then(
          (value) {
        setState(() {
          isloading = false;
        });
        print('DepositeHistory');
        value!.forEach(
                (element) {
              print("elementtttt$element");
              setState(() {
                deposithistoryList.add(element);
              });
              print("gameList=============$deposithistoryList");
            });
      });
}
else{
  Repository().Deposit1v1History(
      userId: SharedPreferencesFunctions().getLoginUserId()!,
      page: _page,
      context: context).then(
          (value) {
        setState(() {
          isloading = false;
        });
        print('1v1DepositeHistory');
        value!.forEach(
                (element) {
              setState(() {
                deposithistoryList.add(element);
              });
              print("1v1DepositeHistory=============$deposithistoryList");
            });
      });
}
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false) {
      setState(() {
        _isLoadMoreRunning = true;
        print("_isLoadMoreRunning$_isLoadMoreRunning");
      });
      _page++;
      print("_page==$_page");
      if(widget.route=="") {
        Repository().DepositeHistoryy(
            userId: SharedPreferencesFunctions().getLoginUserId()!,
            page: _page,
            context: context).then(
                (value) {
              setState(() {
                isloading = false;
              });
              print('DepositeHistory');
              value!.forEach(
                      (element) {
                    print("elementtttt$element");
                    setState(() {
                      deposithistoryList.add(element);
                    });
                    print("gameList=============$deposithistoryList");
                  });
            });
      }
      else{
        Repository().Deposit1v1History(
            userId: SharedPreferencesFunctions().getLoginUserId()!,
            page: _page,
            context: context).then(
                (value) {
              setState(() {
                isloading = false;
              });
              print('1v1DepositeHistory');
              value!.forEach(
                      (element) {
                    setState(() {
                      deposithistoryList.add(element);
                    });
                    print("1v1DepositeHistory=============$deposithistoryList");
                  });
            });
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(_isFirstLoadRunning||isloading)...[
          SizedBox(height: 30,),
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 70,
            ),
          )
    ]else...[
          SizedBox(height: 30,),
        deposithistoryList.isEmpty ? Center(child: Text("No Record Found",
          style: TextStyle(color: Colors.white, fontSize: 25),)) :
        Container(
            height: MediaQuery
                .of(context)
                .size
                .height - 250,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              controller: _controller
                ..addListener(() async {
                  if(_controller.position.extentAfter <= 0) {
                    print("loadmore");
                    _loadMore();
                  }
                }),
              itemCount: deposithistoryList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(20),
                  margin:EdgeInsets.all(10),
                  decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                  child: Column(
                    children: [
                      Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  RichText(
                  text: TextSpan(
                    text: 'Deposited as ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children:  <TextSpan>[
                      TextSpan(
                          text: deposithistoryList[index].symbol,
                          style: TextStyle(
                              color: Color(0xffCBA045))),
                    ],
                  ),
                  ),
                        Text("${deposithistoryList[index].createdAt!.toString().substring(0,10)+" "+ deposithistoryList[index].createdAt!.toString().substring(11,19)} UTC", style: TextStyle(
                            color: Colors.white),),
                      ]),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        Text("In V-USDT:",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize:20)),
                        Text(" ${double.parse(deposithistoryList[index].valuinusdt!).toStringAsFixed(4)} ", style: TextStyle(
                            color: Color(0xff13E900), fontSize: 20),),
                      ],),
                      if (_isLoadMoreRunning == true)
                        Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amberAccent,
                              strokeWidth: 3,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        ),

                      if (_hasNextPage == false)
                        SafeArea(
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            color: Colors.orangeAccent,
                            child: const Text('you get all'),
                          ),
                        )
                    ],
                  ),
                );
              },)
        )],
      ],
    );
  }
}