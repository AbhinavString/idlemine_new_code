import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import 'package:intl/intl.dart';
import '../models/getbalance_model.dart';
import '../models/playtoearn_history_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'IdleMineDrawer.dart';
import 'login_screen.dart';

class FreeTwoPlay extends StatefulWidget {
  const FreeTwoPlay({Key? key}) : super(key: key);

  @override
  State<FreeTwoPlay> createState() => _FreeTwoPlayState();
}

class _FreeTwoPlayState extends State<FreeTwoPlay> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  List<GameHistoryData> FreeToPlayHistoryData=[];
  var isloading=true;
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  late ScrollController _controller;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _page = 1;
  final int _limit = 10;


  @override
  void initState() {
    getConnectivity(context);
   // secureScreen();
    _firstLoad();
    _controller = ScrollController();
    super.initState();
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


  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
      isloading=true;
    });

    Repository().getHistory(isFreeGame: "1",context: context,page: _page,userid: SharedPreferencesFunctions().getLoginUserId()) .then(
            (value) {
          setState(() {
            isloading=false;
          });
          print('getGameHistory');
          value!.forEach(
                  (element) {
                print("elementtttt$element");
                setState(() {
                  FreeToPlayHistoryData.add(element);
                });
                print("gameList=============$FreeToPlayHistoryData");
              });
        });

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

      Repository().getHistory(isFreeGame: "1",page: _page,context: context,userid: SharedPreferencesFunctions().getLoginUserId()) .then(
              (value) {
            setState(() {
              isloading=false;
            });
            print('getGameHistory');
            value!.forEach(
                    (element) {
                  print("elementtttt$element");
                  setState(() {
                    FreeToPlayHistoryData.add(element);
                  });
                  print("gameList=============$FreeToPlayHistoryData");
                });
          });

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
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
                    Balance1v1 =   balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
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
          child:   _isFirstLoadRunning||isloading?Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 70,
            ),
          ):Column(children: [
            SecondAppBar(context, "", Balance.toStringAsFixed(4), Balance1v1.toStringAsFixed(4),),
            SizedBox(height: 30,),
            Text("Free 2 Play History",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 25)),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(10,10,10,0),
              decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                        color: Colors.white),
                  ),
                  Text(
                    "Amount",
                    style: TextStyle(
                      color: Colors.white,),
                  ),
                  Text(
                    "Date/Time",
                    style: TextStyle(
                      color: Colors.white,),
                  ),
                ],
              ),
            ),
            FreeToPlayHistoryData.isEmpty?Center(child: Text("No Record Found",style: TextStyle(color: AppColors.white,fontSize: 25),)):
            Container(
              height: MediaQuery.of(context).size.height-280,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  itemCount: FreeToPlayHistoryData.length,
                  controller: _controller
                    ..addListener(() async {
                      if(_controller.position.extentAfter <= 0) {
                        print("loadmore");
                        _loadMore();
                      }
                    }),
                  itemBuilder:
                      (BuildContext context, int index) {
                        DateTime temp = FreeToPlayHistoryData[index].createdAt!;
                        print(temp.toLocal());
                        var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ssZ');
                        var inputDate = inputFormat.parse(temp.toLocal().toString()); // <-- dd/MM 24H format
                        var outputFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');
                        var outputDate = outputFormat.format(inputDate);
                    return Container(
                      padding: EdgeInsets.all(14),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration( color: Color(0xff240E3F),borderRadius: BorderRadius.circular(15) ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FreeToPlayHistoryData[index].isWin==1?
                          Text("Won",style: TextStyle(color:  Color(0xff13E900),fontSize: 16),):
                          Text("Loss",style: TextStyle(color: Color(0xffC92727),fontSize: 16),),

                          FreeToPlayHistoryData[index].isWin==1?
                          Text(
                            "\$ ${FreeToPlayHistoryData[index].winingAmount=="0"?FreeToPlayHistoryData[index].winingAmount!.toStringAsFixed(4):FreeToPlayHistoryData[index].winingAmount!.toStringAsFixed(4)}",
                            style: TextStyle(
                                color:  Color(0xff13E900)),
                          ): Text(
                            "\$ ${FreeToPlayHistoryData[index].winingAmount=="0"?FreeToPlayHistoryData[index].winingAmount!.toStringAsFixed(4):FreeToPlayHistoryData[index].winingAmount!.toStringAsFixed(4)}",
                            style: TextStyle(
                                color: Color(0xffC92727)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${FreeToPlayHistoryData[index].createdAt!.toString().substring(0,10)}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                              Text(
                                "${FreeToPlayHistoryData[index].createdAt!.toString().substring(11,19)} UTC",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12),
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
                        ],
                      ),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
