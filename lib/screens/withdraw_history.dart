import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/withdraw_history_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'login_screen.dart';

class WithdrawHistory extends StatefulWidget {
  var route;
   WithdrawHistory({Key? key,required this.route}) : super(key: key);

  @override
  State<WithdrawHistory> createState() => _WithdrawHistoryState();
}

class _WithdrawHistoryState extends State<WithdrawHistory> with TickerProviderStateMixin {
  List<WithdrawHistoryData> withdrawhistoryList = [];
  var active= false;
  List isactive=[];
var isloading=true;
late ScrollController _controller;
bool _hasNextPage = true;
bool _isFirstLoadRunning = false;
bool _isLoadMoreRunning = false;
int _page = 1;

  @override
  void initState() {
    _firstLoad();
    //secureScreen();
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
      Repository().WithdrawHistory(
          userId: SharedPreferencesFunctions().getLoginUserId()!,
          page: _page,
          context: context).then(
              (value) {
            setState(() {
              isloading = false;
            });
            value!.forEach(
                    (element) {
                  print("elementtttt$element");
                  setState(() {
                    withdrawhistoryList.add(element);
                  });
                });
          });
    }
    else{
      Repository().Withdraw1v1History(
          userId: SharedPreferencesFunctions().getLoginUserId()!,
          page: _page,
          context: context).then(
              (value) {
            setState(() {
              isloading = false;
            });
            value!.forEach(
                    (element) {
                  print("elementtttt$element");
                  setState(() {
                    withdrawhistoryList.add(element);
                  });
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
        Repository().WithdrawHistory(
            userId: SharedPreferencesFunctions().getLoginUserId()!,
            page: _page,
            context: context).then(
                (value) {
              setState(() {
                isloading = false;
              });
              value!.forEach(
                      (element) {
                    print("elementtttt$element");
                    setState(() {
                      withdrawhistoryList.add(element);
                    });
                  });
            });
      }
      else{
        Repository().Withdraw1v1History(
            userId: SharedPreferencesFunctions().getLoginUserId()!,
            page: _page,
            context: context).then(
                (value) {
              setState(() {
                isloading = false;
              });
              value!.forEach(
                      (element) {
                    print("elementtttt$element");
                    setState(() {
                      withdrawhistoryList.add(element);
                    });
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
        withdrawhistoryList.isEmpty ? Center(child: Text("No Record Found",
          style: TextStyle(color: Colors.white, fontSize: 25),)) :
        Container(
            height: MediaQuery
                .of(context)
                .size
                .height -  250,
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
              itemCount: withdrawhistoryList.length,
              itemBuilder: (context, index) {
                //var reverselist = withdrawhistoryList.reversed.toList();
                var longtext = withdrawhistoryList[index].requestAddress;
                print(isactive);
                return AnimatedContainer(
                  duration: Duration(milliseconds:500),
                  //height: isactive.contains(index)?180:110,
                  padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Color(0xff240E3F),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                         if(withdrawhistoryList[index].status==2)...[
                           Text("Rejected", style: TextStyle(
                               color: Color(0xffC92727), fontSize: 18),),
                         ]else if(withdrawhistoryList[index].status==0)...[
                           Text("Pending", style: TextStyle(
                               color: Color(0xffFA6900), fontSize: 18),),
                         ]else
                           Text("Accepted", style: TextStyle(
                               color:Color(0xff13E900), fontSize: 18),),
                        Text(
                          "${withdrawhistoryList[index].createdAt!.toString().substring(0,10)+" "+ withdrawhistoryList[index].createdAt!.toString().substring(11,19)} UTC", style: TextStyle(fontSize: 12,
                            color: Colors.white),),
                      ],),
                      AnimatedSize(
                       // vsync: this,
                        duration: Duration(milliseconds:500),
                        child: isactive.contains(index)?
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("Wallet ID :", style: TextStyle(
                                  color: Colors.white, fontSize: 14),),
                              Spacer(),
                              Tooltip(
                                message: longtext,
                                child: Text(
                                  "${longtext!.substring(0,10)}", style: TextStyle(
                                    color: Colors.white),),
                              ),
                              Text("...", style: TextStyle(color: Colors.white),),
                            ],),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Amount:", style: TextStyle(
                                    color: Colors.white, fontSize: 14),),
                                Text(
                                  "${double.parse(withdrawhistoryList[index].requestAmount!).toStringAsFixed(2)}", style: TextStyle(
                                    color: Colors.white),),
                              ],),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Withdraw Charges:", style: TextStyle(
                                    color: Colors.white, fontSize: 14),),
                                Text(
                                  "${withdrawhistoryList[index].charge}", style: TextStyle(
                                    color: Colors.white),),
                              ],),
                          ],
                        ):SizedBox.shrink(),
                      ),

                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                        Text("Receivable amount:", style: TextStyle(
                            color: Colors.white, fontSize: 14),),
                          if(withdrawhistoryList[index].status==2)...[
                            Text("${withdrawhistoryList[index].receivable}", style: TextStyle(
                                color: Color(0xffC92727), fontSize: 14,fontWeight: FontWeight.w500),),
                          ]else if(withdrawhistoryList[index].status==0)...[
                            Text("${withdrawhistoryList[index].receivable}", style: TextStyle(
                                color: Color(0xffFA6900), fontSize: 14,fontWeight: FontWeight.w500),),
                          ]else
                            Text("${withdrawhistoryList[index].receivable}", style: TextStyle(
                                color: Color(0xff13E900), fontSize: 14,fontWeight: FontWeight.w500),),
                      ],),
                      Row(
                        children: [
                          Spacer(),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              constraints: BoxConstraints(),
                              onPressed: (){
                                print(index);
                            setState(() {
                              if(isactive.contains(index)){
                                isactive.remove(index);
                                print(isactive);
                              }else{
                               isactive.add(index);
                                print(isactive);
                              }


                            });
                          }, icon:
                            AnimatedSwitcher(
                                duration: Duration(milliseconds:500),
                                transitionBuilder: (child, anim) => RotationTransition(
                                  turns: child.key == ValueKey('icon1')
                                      ? Tween<double>(begin: 1, end: 0).animate(anim)
                                      : Tween<double>(begin: 0, end: 1).animate(anim),
                                  child: FadeTransition(opacity: anim, child: child),
                                ),

                              child: isactive.contains(index)? Icon(Icons.keyboard_arrow_up_outlined,color: Color(0xffEA1E63),size: 30, key: const ValueKey('icon1'),):
                          Icon(Icons.keyboard_arrow_down,color: Color(0xffEA1E63),size: 30, key: const ValueKey('icon2'),)),
                          ),
                            ],
                      ),
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
              }
                ),
                ),]
    ]);
  }
}