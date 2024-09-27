import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../constants/custom_widget.dart';
import '../models/getbalance_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'currentweekrank_paid.dart';
import 'lastweek_rank_paid.dart';

class GlobalRankPaidtabs extends StatefulWidget {
  const GlobalRankPaidtabs({Key? key}) : super(key: key);

  @override
  State<GlobalRankPaidtabs> createState() => _GlobalRankPaidtabsState();
}

class _GlobalRankPaidtabsState extends State<GlobalRankPaidtabs> {
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  void initState() {
    // TODO: implement initState
    super.initState();
    //getConnectivity(context);
    getBalance();
    //secureScreen();
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
    return DefaultTabController(
      initialIndex: 0,
      length: 2, // number of tabs
      child:  Scaffold(
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
                  SecondAppBar(context, "",  Balance.toStringAsFixed(4), Balance1v1.toStringAsFixed(4)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.transparent.withOpacity(0.3),
                        borderRadius:  BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: TabBar(
                      indicator: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(color: Colors.white),
                          borderRadius:  BorderRadius.circular(10)),
                      tabs: [
                        Tab(text: "Current Week"),
                        Tab(text: "Last Week"),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        CurrentRankPaid(),
                        LastWeekRankPaid(),
                      ],
                    ),
                  ),

                ]),
          ),
        ),
      ),
    );
  }
}
