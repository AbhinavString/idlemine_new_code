import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idlemine_latest/screens/tabs_Screen.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;


import '../constants/BaseController.dart';
import '../constants/custom_widget.dart';
import '../models/getbalance_model.dart';
import '../models/kling_api_model.dart';
import '../reposiratory/repo.dart';
import '../utils/sharedPreferences.dart';
import 'IdleMineDrawer.dart';


class MarketScreen extends BaseController {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _SalesData {
  _SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 3))
        ..repeat();
  bool status = false;
  List<_StepAreaData> chartData = [];

  KlingPrize klingPrize = KlingPrize();
  KlingChart klingChart = KlingChart();
  var symbol = "USD";
  var activeChart = 0;
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  void updateKlingPrice() async {
    var requestURL =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=$symbol&ids=kling&order=market_cap_desc";
    var url = Uri.parse(requestURL);
    var response = await http.get(url);
    // print(response.body);
    klingPrize = KlingPrize();
    setState(() {
      klingPrize.dictToObject(response.body);
    });
  }

  void updateChart(int interval) async {
    activeChart = interval;
    updateKlingPrice();
    DateTime time = DateTime.now();
    var toTime = (time.microsecondsSinceEpoch / 1000).toString();
    var fromTime = "";
    switch (interval) {
      case 0:
        fromTime =
            (time.subtract(Duration(days: 4)).millisecondsSinceEpoch / 1000)
                .toString();
        break;
      case 1:
        fromTime =
            (time.subtract(Duration(days: 30)).millisecondsSinceEpoch / 1000)
                .toString();
        break;
      case 2:
        fromTime =
            (time.subtract(Duration(days: 365)).millisecondsSinceEpoch / 1000)
                .toString();
    }

    var requestURL =
        "https://api.coingecko.com/api/v3/coins/kling/market_chart/range?vs_currency=$symbol&from=$fromTime&to=$toTime";
    Uri url = Uri.parse(requestURL);
    http.Response response = await http.get(url);

    klingChart = KlingChart();
    klingChart.dictToObject(response.body);
    chartData.clear();

    setState(() {
      chartData = [];
      for (var i = 0; i < klingChart.price.length; i++) {
        chartData.add(_StepAreaData(
            klingChart.xAxis[i], double.parse(klingChart.price[i])));
        // chartData.add(_ChartData(double.parse(klingChart.xAxis[i]),
        //   double.parse(klingChart.price[i])));

      }
    });
  }

  Timer mytimer = Timer.periodic(Duration(seconds: 10000000000), (timer) {});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity(context);
    updateChart(0);
    mytimer.cancel();
    mytimer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateKlingPrice();
    });
    getBalance();
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
  void dispose() {
    // TODO: implement dispose
    mytimer.cancel();
    _controller.clearListeners();
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TabScreen(index: 0),
            ));
        return true;

      },
      child: Scaffold(
        key: scaffoldKey,
        drawerEdgeDragWidth: 0,
        drawer: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: IdleMineDrawer()),
        body:Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              customAppBar(context, scaffoldKey,Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 30,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Market',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 15, right: 15),
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent.withOpacity(.4),
                      border: Border.all(width: 1),
                    ),
                    child: Row(
                      children: [
                        //sound_icon
                        Container(
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _controller.value * 2 * math.pi,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/images/kling_newicon.png',
                              height: 110,
                              width: 110,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: Text(
                            'Kling',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 25),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, right: 20),
                              child: Text(
                                '${klingPrize.current_price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2, right: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    (klingPrize.price_change_percentage_24h
                                            .contains("+"))
                                        ? Icons.arrow_drop_up_outlined
                                        : Icons.arrow_drop_down_outlined,
                                    color: (klingPrize.price_change_percentage_24h
                                            .contains("+"))
                                        ? Colors.green
                                        : Colors.redAccent,
                                    size: 30.0,
                                  ),
                                  Text(
                                    '${klingPrize.price_change_percentage_24h} %',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffda286f),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 20,
                        color: (activeChart == 0)
                            ? Colors.pinkAccent
                            : Colors.pinkAccent.shade100,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(5.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () => updateChart(0),
                            child: Text("1 D")),
                      )),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 20,
                        color: (activeChart == 1)
                            ? Colors.pinkAccent
                            : Colors.pinkAccent.shade100,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(5.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () => updateChart(1),
                            child: Text("1 M")),
                      )),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 20,
                        color: (activeChart == 2)
                            ? Colors.pinkAccent
                            : Colors.pinkAccent.shade100,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(5.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () => updateChart(2),
                            child: Text("1 Y")),
                      )),
                ],
              ),
              SfCartesianChart(
                legend: Legend(isVisible: false),
                title: ChartTitle(text: 'Kling'),
                plotAreaBorderWidth: 0,
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0)),
                series: _getStepAreaSeries().cast<CartesianSeries<dynamic, dynamic>>(),
                tooltipBehavior: TooltipBehavior(enable: true),
              ),

              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     //Initialize the spark charts widget
              //     child: SfSparkLineChart.custom(
              //       //Enable the trackball
              //       trackball: SparkChartTrackball(
              //           activationMode: SparkChartActivationMode.tap),
              //       //Enable marker
              //       marker: SparkChartMarker(
              //           displayMode: SparkChartMarkerDisplayMode.all),
              //       //Enable data label
              //       labelDisplayMode: SparkChartLabelDisplayMode.all,
              //       xValueMapper: (int index) => data[index].year,
              //       yValueMapper: (int index) => data[index].sales,
              //       dataCount: 5,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChartSeries<_StepAreaData, double>> _getStepAreaSeries() {
    return <ChartSeries<_StepAreaData, double>>[
      StepAreaSeries<_StepAreaData, double>(
        dataSource: chartData,
        borderColor: const Color.fromRGBO(192, 108, 132, 1),
        color: const Color.fromRGBO(192, 108, 132, 0.6),
        borderWidth: 1,
        name: 'Low',
        xValueMapper: (_StepAreaData sales, _) => double.parse(sales.x),
        yValueMapper: (_StepAreaData sales, _) => sales.high,
      )
    ];
  }
}

class _StepAreaData {
  _StepAreaData(this.x, this.high);
  final String x;
  final double high;
}
