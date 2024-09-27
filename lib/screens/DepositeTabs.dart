import 'package:flutter/material.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';

import '../constants/custom_widget.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'DepositScreen.dart';
import 'Deposite1v1Screen.dart';

class DepositeTabsScreen extends StatefulWidget {
  const DepositeTabsScreen({Key? key}) : super(key: key);

  @override
  State<DepositeTabsScreen> createState() => _DepositeTabsScreenState();
}

class _DepositeTabsScreenState extends State<DepositeTabsScreen> {
  double Balance = 00;
  double Balance1v1 = 00;
  List<BalanceData> balanceData = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    //getConnectivity(context);
    getBalance();
    // secureScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowAlertMsg();
    });
  }

  ShowAlertMsg() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            scrollable: true,
            content: Container(
              //height: MediaQuery.of(context).size.height/2,
              //width: MediaQuery.of(context).size.width/3,
              child: Column(children: [
                Text("Attention!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "We are accepting Kling Tokens and all tokens (BEP-20) listed on Binance centralized exchange.",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                SizedBox(height: 10),
                Text(
                  "Note: Transactions can't be cancelled or reversed once initiated. It is essential to exercise caution when sending and make sure the address you are sending to is an exact match of the recipient's address. Transactions sent to the wrong addresses or network cannot be retrieved.",
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffda286f),
                    // side: BorderSide(color: Colors.yellow, width: 5),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    shadowColor: Colors.pinkAccent,
                    elevation: 3,
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "I Understood",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  getBalance() {
    Repository()
        .getBalance(id: SharedPreferencesFunctions().getLoginUserId()!)
        .then((value) {
      value!.forEach((element) {
        setState(() {
          balanceData.add(element);
          if (balanceData.isEmpty) {
            Balance = 00;
            Balance1v1 = 00;
          } else {
            Balance = balanceData.first.moneyInWallet.toDouble();
            Balance1v1 = balanceData.first.moneyInWallet1V1.toDouble();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => TabScreen(
                    index: 0,
                  )),
        );
        return true;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 2, // number of tabs
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SecondAppBar(context, "", Balance.toStringAsFixed(4),
                        Balance1v1.toStringAsFixed(4)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.transparent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white)),
                      child: TabBar(
                        indicator: BoxDecoration(
                            color: Colors.pink,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        tabs: [
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      30), // Increase horizontal padding
                              child: Text("Deposit"),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      30), // Increase horizontal padding
                              child: Text("1v1 Deposit"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          DepositScreen(),
                          Deposite1v1Screen(),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
