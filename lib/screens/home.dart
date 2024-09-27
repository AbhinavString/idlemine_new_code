// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:idlemine_latest/screens/waiting_page.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import '../constants/EncryptDecryptUtil.dart';
// import '../constants/add_helper.dart';
// import '../constants/custom_widget.dart';
// import '../main.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// import '../models/gameid_model.dart';
// import '../models/get_gamelist_model.dart';
// import '../models/getbalance_model.dart';
// import '../models/getbanner_model.dart';
// import '../models/multiplayergamelist_model.dart';
// import '../reposiratory/repo.dart';
// import '../utils/app_colors.dart';
// import '../utils/sharedPreferences.dart';
// import 'IdleMineDrawer.dart';
// import 'hold_to_earn.dart';
// import 'login_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   //final _controller=PageController();
//   final _controller = CarouselController();
//   final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
//   List<BannerData> banners = [];
//   late YoutubePlayerController _videocontroller;
//   Future<void>? _initializeVideoPlayerFuture;
//   List<GameListModel> gameList = [];
//   List<MultiplayerGamelistModel> multigameList = [];
//   BannerAd? _bannerAd;
//   List<BalanceData> balanceData = [];
//   var _current = 0;
//   List<GameIdModel> GameIdList = [];
//   double Balance = 00;
//   double Balance1v1 = 00;
//   Uint8List? myImage;
//   var count = 0;
//   var status;
//   var isloading = false;
//   var istap = true;
//   var isbuttontap = true;
//
//   @override
//   void initState() {
//     //isRealDevices(context);
//     //secureScreen();
//     getConnectivity(context);
//     getBalance();
//     getBanner();
//     sharedPreferences!.remove('Isloginstatus');
//     Repository()
//         .isLogin(
//             token: SharedPreferencesFunctions().getLoginToken()!,
//             context: context)
//         .then((value) async {
//       if (SharedPreferencesFunctions().getIsloginstatus() == "0") {
//         Navigator.pushReplacement(context,
//             new MaterialPageRoute(builder: (context) => LoginScreen()));
//         final prefs = await SharedPreferences.getInstance();
//         prefs.clear();
//         SharedPreferencesFunctions().logout();
//         GoogleSignIn googleSignIn = GoogleSignIn();
//         await googleSignIn.signOut();
//       }
//     });
//     const url = "https://www.youtube.com/watch?v=pbCV975qIEU";
//     _videocontroller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(url)!,
//       flags: YoutubePlayerFlags(
//         mute: false,
//         autoPlay: false,
//         hideThumbnail: true,
//       ),
//     );
//     super.initState();
//     BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       request: AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _bannerAd = ad as BannerAd;
//             // print("adss===$_bannerAd");
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           //print('Failed to load a banner ad: ${err.message}');
//           ad.dispose();
//         },
//       ),
//     ).load();
//     getGameList();
//     getMultiplayerGameList();
//   }
//
//   getBanner() {
//     Repository().getBanner(context).then((value) {
//       value!.forEach((element) {
//         setState(() {
//           banners.add(element);
//         });
//       });
//     });
//   }
//
//   getBalance() {
//     Repository()
//         .getBalance(id: SharedPreferencesFunctions().getLoginUserId()!)
//         .then((value) {
//       value!.forEach((element) {
//         setState(() {
//           balanceData.add(element);
//           if (balanceData.isEmpty) {
//             Balance = 00;
//             Balance1v1 = 00;
//           } else {
//             Balance = balanceData.first.moneyInWallet.toDouble().toDouble();
//             Balance1v1 =
//                 balanceData.first.moneyInWallet1V1.toDouble().toDouble();
//           }
//         });
//       });
//     });
//   }
//
//   getGameList() {
//     gameList.clear();
//     Repository().getGameList(context).then((value) {
//       value!.forEach((element) {
//         setState(() {
//           gameList.add(element);
//         });
//       });
//     });
//   }
//
//   getMultiplayerGameList() {
//     multigameList.clear();
//     Repository().getmultiplayerGameList(context).then((value) {
//       value!.forEach((element) {
//         setState(() {
//           multigameList.add(element);
//         });
//       });
//       print("multigameList====$multigameList");
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: Dispose a BannerAd object
//     _videocontroller!.pause();
//     _bannerAd?.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (scaffoldKey.currentState!.isDrawerOpen) {
//           Navigator.of(context).pop();
//           return false;
//         }
//         showExitPopup(context);
//         return true;
//       },
//       child: Scaffold(
//         key: scaffoldKey,
//         drawer: IdleMineDrawer(),
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: SafeArea(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     _videocontroller.pause();
//                                     scaffoldKey.currentState!.openDrawer();
//                                   },
//                                   icon: Icon(
//                                     Icons.menu,
//                                     color: AppColors.appcolordmiddark,
//                                     size: 40,
//                                   )),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Text(
//                                   "Single Player Balance",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Text(
//                                   "\$ ${Balance.toStringAsFixed(4)}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14,
//                                       color: AppColors.appcolordmiddark),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Spacer(),
//                           Column(
//                             children: [
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Image.asset(
//                                   'assets/images/idleminesmall_icon.png',
//                                   width: 40,
//                                   height: 40),
//                               Text(
//                                 "V $version",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 6,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Text(
//                                   "1v1 Balance",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Text(
//                                   "\$ ${Balance1v1.toStringAsFixed(4)}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14,
//                                       color: AppColors.appcolordmiddark),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           SizedBox(height: 10),
//                           if (banners == null || banners.isEmpty) ...[
//                             SizedBox.shrink(),
//                           ] else
//                             SizedBox(
//                                 height: 200,
//                                 child: CarouselSlider.builder(
//                                   carouselController: _controller,
//                                   itemCount: banners.length,
//                                   itemBuilder: (context, index, realIndex) {
//                                     if (banners[index].image == "" ||
//                                         banners[index].image == null) {
//                                     } else {
//                                       String base64Image = banners[index].image;
//                                       final UriData? data =
//                                           Uri.parse(base64Image).data;
//                                       myImage = data!.contentAsBytes();
//                                     }
//                                     return GestureDetector(
//                                       onTap: () {
//                                         launchUrlString(banners[index].link);
//                                       },
//                                       child: Container(
//                                         margin: EdgeInsetsDirectional.all(10),
//                                         height: 180,
//                                         width:
//                                             MediaQuery.of(context).size.width -
//                                                 20,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           image: DecorationImage(
//                                               image: MemoryImage(myImage!),
//                                               fit: BoxFit.fill),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   options: CarouselOptions(
//                                     enlargeCenterPage: true,
//                                     aspectRatio:
//                                         MediaQuery.of(context).size.width,
//                                     autoPlayCurve: Curves.fastOutSlowIn,
//                                     enableInfiniteScroll: true,
//                                     disableCenter: true,
//                                     autoPlayAnimationDuration:
//                                         Duration(milliseconds: 800),
//                                     viewportFraction: 1,
//                                     onPageChanged: (index, reason) {
//                                       setState(() {
//                                         _current = index;
//                                       });
//                                     },
//                                     autoPlay: true,
//                                   ),
//                                 )),
//                           SizedBox(height: 20),
//                           _bannerAd == null
//                               ? SizedBox.shrink()
//                               : Container(
//                                   width: _bannerAd!.size.width.toDouble(),
//                                   height: _bannerAd!.size.height.toDouble(),
//                                   child: AdWidget(ad: _bannerAd!),
//                                 ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "Start Earning USDT",
//                             style: TextStyle(
//                                 color: AppColors.white,
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text("Single Player",
//                               style: TextStyle(
//                                   color: AppColors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w500)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           InkWell(
//                               onTap: () {
//                                 _videocontroller.pause();
//                                 if (gameList.isEmpty) {
//                                   getGameList();
//                                 }
//
//                                 if (istap) {
//                                   setState(() {
//                                     istap = false;
//                                   });
//                                   showModalBottomSheet<void>(
//                                     isScrollControlled: false,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(20),
//                                             topLeft: Radius.circular(20))),
//                                     context: context,
//                                     isDismissible: false,
//                                     enableDrag: false,
//                                     builder: (BuildContext context) {
//                                       return StatefulBuilder(
//                                         builder: (context, setModalState) {
//                                           return WillPopScope(
//                                             onWillPop: () async {
//                                               setState(() {
//                                                 istap = true;
//                                                 isbuttontap = true;
//                                               });
//                                               Navigator.pop(context);
//                                               return true;
//                                             },
//                                             child: Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       (BorderRadius.circular(
//                                                           20)),
//                                                 ),
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .height /
//                                                     1.2,
//                                                 child: Column(
//                                                     children: <Widget>[
//                                                       Container(
//                                                         height: 30,
//                                                         width: 50,
//                                                         margin: EdgeInsets.only(
//                                                             left: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width -
//                                                                 50),
//                                                         child: ElevatedButton(
//                                                             child: const Icon(
//                                                               Icons.close,
//                                                               color:
//                                                                   Colors.black,
//                                                             ),
//                                                             onPressed: () {
//                                                               setState(() {
//                                                                 istap = true;
//                                                                 isbuttontap =
//                                                                     true;
//                                                               });
//                                                               Navigator.pop(
//                                                                   context);
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               primary:
//                                                                   Colors.white,
//                                                               backgroundColor:
//                                                                   Color(
//                                                                       0xffda286f),
//                                                               animationDuration:
//                                                                   Duration(
//                                                                       seconds:
//                                                                           1),
//                                                             )),
//                                                       ),
//                                                       Container(
//                                                         child: Image.asset(
//                                                           "assets/images/start_game.png",
//                                                           height: 80,
//                                                           width: 80,
//                                                         ),
//                                                       ),
//                                                       Container(
//                                                         margin: EdgeInsets.only(
//                                                             top: 10),
//                                                         child: Text(
//                                                           'Thumb Activity',
//                                                           style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             fontSize: 16,
//                                                             color: Color(
//                                                                 0xffda286f),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Container(
//                                                         margin: EdgeInsets.only(
//                                                             top: 5),
//                                                         child: Text(
//                                                           'Press your thumb down and earn USDT',
//                                                           style: TextStyle(
//                                                               fontSize: 16,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                               color:
//                                                                   Colors.black),
//                                                         ),
//                                                       ),
//                                                       gameList == null ||
//                                                               gameList.isEmpty
//                                                           ? CircularProgressIndicator()
//                                                           : Stack(
//                                                               children: [
//                                                                 Container(
//                                                                   height: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .height /
//                                                                       3,
//                                                                   child: GridView
//                                                                       .builder(
//                                                                     itemCount:
//                                                                         gameList
//                                                                             .length,
//                                                                     padding:
//                                                                         const EdgeInsets
//                                                                             .all(
//                                                                             15),
//                                                                     shrinkWrap:
//                                                                         true,
//                                                                     scrollDirection:
//                                                                         Axis.vertical,
//                                                                     //physics: NeverScrollableScrollPhysics(),
//                                                                     gridDelegate:
//                                                                         new SliverGridDelegateWithFixedCrossAxisCount(
//                                                                       mainAxisSpacing:
//                                                                           15,
//                                                                       crossAxisSpacing:
//                                                                           15,
//                                                                       crossAxisCount:
//                                                                           2,
//                                                                       childAspectRatio: MediaQuery.of(context)
//                                                                               .size
//                                                                               .width /
//                                                                           (360 /
//                                                                               2.5),
//                                                                     ),
//                                                                     itemBuilder:
//                                                                         (context,
//                                                                             index) {
//                                                                       return InkWell(
//                                                                           onTap:
//                                                                               () {
//                                                                             if (isbuttontap) {
//                                                                               if (Balance >= gameList[index].gameAmount!) {
//                                                                                 setModalState(() {
//                                                                                   isloading = true;
//                                                                                   isbuttontap = false;
//                                                                                 });
//                                                                                 checkGameTimes(gameid: gameList[index].id).then((value) {
//                                                                                   setModalState(() {
//                                                                                     isloading = false;
//                                                                                   });
//                                                                                   if (status == 1) {
//                                                                                     Navigator.pop(context);
//                                                                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HoldToEarn(gameDuration: gameList[index].gameDuration.toString(), thumbDuration: gameList[index].thumbDuration.toString(), gameId: gameList[index].id.toString(), gameAmount: gameList[index].gameAmount.toString())));
//                                                                                   } else {
//                                                                                     setState(() {
//                                                                                       istap = true;
//                                                                                       isbuttontap = true;
//                                                                                     });
//                                                                                     Navigator.pop(context);
//                                                                                   }
//                                                                                 });
//                                                                               } else {
//                                                                                 showToast("Insufficient Balance");
//                                                                               }
//                                                                             }
//                                                                           },
//                                                                           // splashColor: gameList[index].gameAmount==0? Colors.orange.shade500
//                                                                           // : Colors.blue.shade500,
//                                                                           splashFactory: InkRipple
//                                                                               .splashFactory,
//                                                                           child:
//                                                                               Container(
//                                                                             padding:
//                                                                                 const EdgeInsets.all(5),
//                                                                             decoration:
//                                                                                 BoxDecoration(
//                                                                               borderRadius: BorderRadius.circular(10),
//                                                                               border: Border.all(color: AppColors.grey),
//                                                                               color: gameList[index].gameAmount == 0 ? Colors.orange.shade900 : Colors.blue.shade900,
//                                                                             ),
//                                                                             child:
//                                                                                 Row(
//                                                                               children: [
//                                                                                 Container(
//                                                                                   // color: Colors.red,
//                                                                                   height: 50,
//                                                                                   child: Image.asset(
//                                                                                     "assets/images/stopwatch.png",
//                                                                                     color: Colors.white,
//                                                                                     height: 50,
//                                                                                     width: 35,
//                                                                                   ),
//                                                                                 ),
//                                                                                 SizedBox(width: 5),
//                                                                                 Column(
//                                                                                   children: [
//                                                                                     Container(
//                                                                                         padding: EdgeInsets.only(top: 10),
//                                                                                         child: gameList[index].gameAmount == 0
//                                                                                             ? Row(
//                                                                                                 children: [
//                                                                                                   Text("${gameList[index].gameDuration / 60} mins",
//                                                                                                       textAlign: TextAlign.left,
//                                                                                                       style: TextStyle(
//                                                                                                         fontWeight: FontWeight.w500,
//                                                                                                         fontSize: 13,
//                                                                                                         color: Colors.white,
//                                                                                                       )),
//                                                                                                   Text(" (FreePlay)",
//                                                                                                       textAlign: TextAlign.left,
//                                                                                                       style: TextStyle(
//                                                                                                         fontWeight: FontWeight.w500,
//                                                                                                         fontSize: 12,
//                                                                                                         color: Colors.white,
//                                                                                                       ))
//                                                                                                 ],
//                                                                                               )
//                                                                                             : Row(
//                                                                                                 children: [
//                                                                                                   Text("${gameList[index].gameDuration / 60} mins",
//                                                                                                       textAlign: TextAlign.left,
//                                                                                                       style: TextStyle(
//                                                                                                         fontWeight: FontWeight.w500,
//                                                                                                         fontSize: 13,
//                                                                                                         color: Colors.white,
//                                                                                                       )),
//                                                                                                   SizedBox(
//                                                                                                     width: 5,
//                                                                                                   ),
//                                                                                                   gameList[index].gameAmount != 0
//                                                                                                       ? Text("(Earn ${gameList[index].earningPercentage * double.parse(gameList[index].gameAmount.toString()) / 100} \$)",
//                                                                                                           textAlign: TextAlign.left,
//                                                                                                           style: TextStyle(
//                                                                                                             fontWeight: FontWeight.w500,
//                                                                                                             fontSize: 9,
//                                                                                                             color: Colors.white,
//                                                                                                           ))
//                                                                                                       : SizedBox.shrink(),
//                                                                                                 ],
//                                                                                               )),
//                                                                                     Container(alignment: Alignment.centerLeft, child: gameList[index].gameAmount == 0 ? Text("Earn ${gameList[index].earningPercentage / 100} \$", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)) : Text('${gameList[index].gameAmount} \$-USDT', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
//                                                                                   ],
//                                                                                 )
//                                                                               ],
//                                                                             ),
//                                                                           ));
//                                                                     },
//                                                                   ),
//                                                                 ),
//                                                                 isloading
//                                                                     ? Positioned
//                                                                         .fill(
//                                                                         child:
//                                                                             Center(
//                                                                           child:
//                                                                               LoadingAnimationWidget.staggeredDotsWave(
//                                                                             color:
//                                                                                 AppColors.appcolordmiddark,
//                                                                             size:
//                                                                                 60,
//                                                                           ),
//                                                                         ),
//                                                                       )
//                                                                     : Container(),
//                                                               ],
//                                                             ),
//                                                     ])),
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 }
//                               },
//                               child: Image.asset(
//                                 "assets/images/start_game.png",
//                                 width: MediaQuery.of(context).size.width / 4,
//                               )),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text("Battle",
//                               style: TextStyle(
//                                   color: AppColors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w500)),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           InkWell(
//                               onTap: () {
//                                 _videocontroller.pause();
//                                 if (multigameList.isEmpty) {
//                                   getMultiplayerGameList();
//                                 }
//                                 if (istap) {
//                                   setState(() {
//                                     istap = false;
//                                   });
//                                   showModalBottomSheet<void>(
//                                     isScrollControlled: false,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(20),
//                                             topLeft: Radius.circular(20))),
//                                     context: context,
//                                     isDismissible: false,
//                                     enableDrag: false,
//                                     builder: (BuildContext context) {
//                                       return StatefulBuilder(
//                                         builder: (context, setModalState) {
//                                           return WillPopScope(
//                                             onWillPop: () async {
//                                               setState(() {
//                                                 istap = true;
//                                                 isbuttontap = true;
//                                               });
//                                               Navigator.pop(context);
//                                               return true;
//                                             },
//                                             child: Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       (BorderRadius.circular(
//                                                           20)),
//                                                 ),
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .height /
//                                                     1.2,
//                                                 child:
//                                                     Column(children: <Widget>[
//                                                   Container(
//                                                     height: 30,
//                                                     width: 50,
//                                                     margin: EdgeInsets.only(
//                                                         left: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .width -
//                                                             50),
//                                                     child: ElevatedButton(
//                                                         child: const Icon(
//                                                           Icons.close,
//                                                           color: Colors.black,
//                                                         ),
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             istap = true;
//                                                             isbuttontap = true;
//                                                           });
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                           primary: Colors.white,
//                                                           backgroundColor:
//                                                               Color(0xffda286f),
//                                                           animationDuration:
//                                                               Duration(
//                                                                   seconds: 1),
//                                                         )),
//                                                   ),
//                                                   Container(
//                                                     height: 80,
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width /
//                                                             3.5,
//                                                     padding: EdgeInsets.all(10),
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(15),
//                                                         border: Border.all(
//                                                             color: Color(
//                                                                 0xffda286f)),
//                                                         image: DecorationImage(
//                                                           image: AssetImage(
//                                                               "assets/images/multiplayer_start_game.png"),
//                                                           fit: BoxFit.fill,
//                                                         )),
//                                                   ),
//                                                   Container(
//                                                     margin: EdgeInsets.only(
//                                                         top: 10),
//                                                     child: Text(
//                                                       'Battle',
//                                                       style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         fontSize: 16,
//                                                         color:
//                                                             Color(0xffda286f),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     margin:
//                                                         EdgeInsets.only(top: 5),
//                                                     child: Text(
//                                                       'Press your thumb down to battle and earn!',
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                   multigameList == null ||
//                                                           multigameList.isEmpty
//                                                       ? CircularProgressIndicator()
//                                                       : Stack(
//                                                           children: [
//                                                             Container(
//                                                               height: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .height /
//                                                                   3,
//                                                               child: GridView
//                                                                   .builder(
//                                                                 itemCount:
//                                                                     multigameList
//                                                                         .length,
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                         .all(
//                                                                         15),
//                                                                 shrinkWrap:
//                                                                     true,
//                                                                 scrollDirection:
//                                                                     Axis.vertical,
//                                                                 gridDelegate:
//                                                                     new SliverGridDelegateWithFixedCrossAxisCount(
//                                                                   mainAxisSpacing:
//                                                                       15,
//                                                                   crossAxisSpacing:
//                                                                       15,
//                                                                   crossAxisCount:
//                                                                       2,
//                                                                   childAspectRatio: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .width /
//                                                                       (360 /
//                                                                           2.5),
//                                                                 ),
//                                                                 itemBuilder:
//                                                                     (context,
//                                                                         index) {
//                                                                   return InkWell(
//                                                                       onTap:
//                                                                           () {
//                                                                         if (isbuttontap) {
//                                                                           if (Balance1v1 >=
//                                                                               multigameList[index].amount!) {
//                                                                             setModalState(() {
//                                                                               isloading = true;
//                                                                               isbuttontap = false;
//                                                                             });
//                                                                             Repository().startGame(userId: SharedPreferencesFunctions().getLoginUserId(), gameId: multigameList[index].id, context: context).then((value) {
//                                                                               value!.forEach((element) {
//                                                                                 setModalState(() {
//                                                                                   isloading = false;
//                                                                                 });
//                                                                                 setState(() {
//                                                                                   GameIdList.add(element);
//                                                                                 });
//                                                                               });
//                                                                               Navigator.pop(context);
//                                                                               if (GameIdList.isNotEmpty) {
//                                                                                 Navigator.pushReplacement(
//                                                                                     context,
//                                                                                     MaterialPageRoute(
//                                                                                         builder: (context) => WaitingPage(
//                                                                                               gameId: GameIdList.last.gameId,
//                                                                                               thumbconfig: multigameList[index].thumbconfig,
//                                                                                               gameAmount: multigameList[index].amount.toString(),
//                                                                                             )));
//                                                                               } else {
//                                                                                 setState(() {
//                                                                                   istap = true;
//                                                                                   isbuttontap = true;
//                                                                                 });
//                                                                                 showToast("Something wents wrong");
//                                                                               }
//                                                                             });
//                                                                           } else {
//                                                                             showToast("Insufficient Balance");
//                                                                           }
//                                                                         }
//                                                                       },
//                                                                       splashFactory:
//                                                                           InkRipple
//                                                                               .splashFactory,
//                                                                       child:
//                                                                           Container(
//                                                                         padding: const EdgeInsets
//                                                                             .all(
//                                                                             5),
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(10),
//                                                                           border:
//                                                                               Border.all(color: AppColors.grey),
//                                                                           color: Colors
//                                                                               .blue
//                                                                               .shade900,
//                                                                         ),
//                                                                         child:
//                                                                             Row(
//                                                                           children: [
//                                                                             Container(
//                                                                               height: 50,
//                                                                               child: Image.asset(
//                                                                                 "assets/images/stopwatch.png",
//                                                                                 color: Colors.white,
//                                                                                 height: 50,
//                                                                                 width: 35,
//                                                                               ),
//                                                                             ),
//                                                                             SizedBox(width: 5),
//                                                                             Column(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 Container(alignment: Alignment.centerLeft, child: Text('${multigameList[index].amount} \$-USDT', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
//                                                                                 SizedBox(
//                                                                                   height: 3,
//                                                                                 ),
//                                                                                 Container(
//                                                                                     child: Text("Game Fee : ${multigameList[index].adminearningper} %",
//                                                                                         textAlign: TextAlign.left,
//                                                                                         style: TextStyle(
//                                                                                           fontWeight: FontWeight.w500,
//                                                                                           fontSize: 12,
//                                                                                           color: Colors.white,
//                                                                                         ))),
//                                                                               ],
//                                                                             )
//                                                                           ],
//                                                                         ),
//                                                                       ));
//                                                                 },
//                                                               ),
//                                                             ),
//                                                             isloading
//                                                                 ? Positioned
//                                                                     .fill(
//                                                                     child:
//                                                                         Center(
//                                                                       child: LoadingAnimationWidget
//                                                                           .staggeredDotsWave(
//                                                                         color: AppColors
//                                                                             .appcolordmiddark,
//                                                                         size:
//                                                                             60,
//                                                                       ),
//                                                                     ),
//                                                                   )
//                                                                 : Container(),
//                                                           ],
//                                                         ),
//                                                 ])),
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 }
//                               },
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width / 3,
//                                 height: 100,
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     // border: Border.all(color: Color(0xffda286f)),
//                                     image: DecorationImage(
//                                       image: AssetImage(
//                                           "assets/images/multiplayer_start_game.png"),
//                                       fit: BoxFit.fill,
//                                     )),
//                               )),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: YoutubePlayerBuilder(
//                                 player: YoutubePlayer(
//                                   controller: _videocontroller,
//                                   bottomActions: [
//                                     const SizedBox(width: 14.0),
//                                     CurrentPosition(
//                                         controller: _videocontroller),
//                                     const SizedBox(width: 8.0),
//                                     ProgressBar(
//                                         isExpanded: true,
//                                         controller: _videocontroller,
//                                         colors: ProgressBarColors(
//                                             backgroundColor: Colors.white,
//                                             handleColor: Colors.pink,
//                                             playedColor: Colors.pink)),
//                                     RemainingDuration(
//                                         controller: _videocontroller),
//                                     const PlaybackSpeedButton(),
//                                   ],
//                                   showVideoProgressIndicator: true,
//                                 ),
//                                 builder: (context, player) {
//                                   return Container(child: player);
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
//
//   checkGameTimes({var gameid}) async {
//     try {
//       Uri uri = Uri.parse("${baseurl}api/gameHistory/checkgameduration");
//       var response = await http.post(
//         uri,
//         headers: {
//           'appversion': version,
//           'devicetype': 'android',
//           'Content-Type': 'application/json',
//           'userid': SharedPreferencesFunctions().getLoginUserId()!,
//         },
//         body: json.encode({
//           "userID": SharedPreferencesFunctions().getLoginUserId()!,
//           "gameID": gameid
//         }),
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           status = jsonDecode(response.body)['status'];
//           if (status == 1) {
//           } else {
//             showToast(jsonDecode(response.body)['message']);
//           }
//         });
//       } else if (response.statusCode == 403) {
//         SharedPreferencesFunctions().logout();
//         GoogleSignIn googleSignIn = GoogleSignIn();
//         await googleSignIn.signOut();
//         Navigator.push(context,
//             new MaterialPageRoute(builder: (context) => LoginScreen()));
//       } else {
//         setState(() {
//           status = jsonDecode(response.body)['status'];
//         });
//         showToast(jsonDecode(response.body)['message']);
//       }
//     } catch (e) {
//       return Future.error(e);
//     }
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idlemine_latest/screens/waiting_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants/EncryptDecryptUtil.dart';
import '../constants/add_helper.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/gameid_model.dart';
import '../models/get_gamelist_model.dart';
import '../models/getbalance_model.dart';
import '../models/getbanner_model.dart';
import '../models/multiplayergamelist_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'IdleMineDrawer.dart';
import 'hold_to_earn.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final _controller=PageController();
  final _controller = CarouselController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  List<BannerData> banners = [];
  late YoutubePlayerController _videocontroller;
  Future<void>? _initializeVideoPlayerFuture;
  List<GameListModel> gameList = [];
  List<MultiplayerGamelistModel> multigameList = [];
  BannerAd? _bannerAd;
  List<BalanceData> balanceData = [];
  var _current = 0;
  List<GameIdModel> GameIdList = [];
  double Balance = 00;
  double Balance1v1 = 00;
  Uint8List? myImage;
  var count = 0;
  var status;
  var isloading = false;
  var istap = true;
  var isbuttontap = true;

  @override
  void initState() {
    // isRealDevices(context);
    //secureScreen();
    getConnectivity(context);
    getBalance();
    getBanner();
    sharedPreferences!.remove('Isloginstatus');
    Repository()
        .isLogin(
            token: SharedPreferencesFunctions().getLoginToken()!,
            context: context)
        .then((value) async {
      if (SharedPreferencesFunctions().getIsloginstatus() == "0") {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      }
    });
    const url = "https://www.youtube.com/watch?v=pbCV975qIEU";
    _videocontroller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        hideThumbnail: true,
      ),
    );
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            // print("adss===$_bannerAd");
          });
        },
        onAdFailedToLoad: (ad, err) {
          //print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    getGameList();
    getMultiplayerGameList();
  }

  getBanner() {
    Repository().getBanner(context).then((value) {
      value!.forEach((element) {
        setState(() {
          banners.add(element);
        });
      });
    });
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
            Balance = balanceData.first.moneyInWallet.toDouble().toDouble();
            Balance1v1 =
                balanceData.first.moneyInWallet1V1.toDouble().toDouble();
          }
        });
      });
    });
  }

  getGameList() {
    gameList.clear();
    Repository().getGameList(context).then((value) {
      value!.forEach((element) {
        setState(() {
          gameList.add(element);
        });
      });
    });
  }

  getMultiplayerGameList() {
    multigameList.clear();
    Repository().getmultiplayerGameList(context).then((value) {
      value!.forEach((element) {
        setState(() {
          multigameList.add(element);
        });
      });
      print("multigameList====$multigameList");
    });
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _videocontroller!.pause();
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        showExitPopup(context);
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: IdleMineDrawer(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _videocontroller.pause();
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    color: AppColors.appcolordmiddark,
                                    size: 40,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Single Player Balance",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "\$ ${Balance.toStringAsFixed(4)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: AppColors.appcolordmiddark),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                  'assets/images/idleminesmall_icon.png',
                                  width: 40,
                                  height: 40),
                              Text(
                                "V $version",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 6,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "1v1 Balance",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "\$ ${Balance1v1.toStringAsFixed(4)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: AppColors.appcolordmiddark),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          if (banners == null || banners.isEmpty) ...[
                            SizedBox.shrink(),
                          ] else
                            SizedBox(
                                height: 200,
                                child: CarouselSlider.builder(
                                  carouselController: _controller,
                                  itemCount: banners.length,
                                  itemBuilder: (context, index, realIndex) {
                                    if (banners[index].image == "" ||
                                        banners[index].image == null) {
                                    } else {
                                      String base64Image = banners[index].image;
                                      final UriData? data =
                                          Uri.parse(base64Image).data;
                                      myImage = data!.contentAsBytes();
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        launchUrlString(banners[index].link);
                                      },
                                      child: Container(
                                        margin: EdgeInsetsDirectional.all(10),
                                        height: 180,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: MemoryImage(myImage!),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    aspectRatio:
                                        MediaQuery.of(context).size.width,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    disableCenter: true,
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 800),
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    },
                                    autoPlay: true,
                                  ),
                                )),
                          SizedBox(height: 20),
                          _bannerAd == null
                              ? SizedBox.shrink()
                              : Container(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Start Earning USDT",
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Single Player",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                _videocontroller.pause();
                                if (gameList.isEmpty) {
                                  getGameList();
                                }

                                if (istap) {
                                  setState(() {
                                    istap = false;
                                  });
                                  showModalBottomSheet<void>(
                                    isScrollControlled: false,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20))),
                                    context: context,
                                    isDismissible: false,
                                    enableDrag: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return WillPopScope(
                                            onWillPop: () async {
                                              setState(() {
                                                istap = true;
                                                isbuttontap = true;
                                              });
                                              Navigator.pop(context);
                                              return true;
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      (BorderRadius.circular(
                                                          20)),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.2,
                                                child: Column(
                                                    children: <Widget>[
                                                      // Container(
                                                      //   height: 30,
                                                      //   width: 50,
                                                      //   margin: EdgeInsets.only(
                                                      //       left: MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .width -
                                                      //           50),
                                                      //   child: ElevatedButton(
                                                      //       child: const Icon(
                                                      //         Icons.close,
                                                      //         color:
                                                      //             Colors.black,
                                                      //       ),
                                                      //       onPressed: () {
                                                      //         setState(() {
                                                      //           istap = true;
                                                      //           isbuttontap =
                                                      //               true;
                                                      //         });
                                                      //         Navigator.pop(
                                                      //             context);
                                                      //       },
                                                      //       style:
                                                      //           ElevatedButton
                                                      //               .styleFrom(
                                                      //         primary:
                                                      //             Colors.white,
                                                      //         backgroundColor:
                                                      //             Color(
                                                      //                 0xffda286f),
                                                      //         animationDuration:
                                                      //             Duration(
                                                      //                 seconds:
                                                      //                     1),
                                                      //       )),
                                                      // ),
                                                      Container(
                                                        height: 30,
                                                        width: 50,
                                                        margin: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              istap = true;
                                                              isbuttontap =
                                                                  true;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor: Colors
                                                                .white, // Deprecated, replaced by 'foregroundColor' and 'backgroundColor'
                                                            backgroundColor: Color(
                                                                0xFFDA286F), // Ensure proper color code format
                                                           /* onPrimary: Colors
                                                                .black,*/ // Sets the foreground color for text and icons
                                                            minimumSize: Size(
                                                                30,
                                                                40), // Set the minimum size of the button
                                                            padding: EdgeInsets
                                                                .zero, // Remove padding to align icon center
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .zero, // If you need a square button
                                                            ),
                                                            animationDuration:
                                                                Duration(
                                                                    seconds: 1),
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Image.asset(
                                                          "assets/images/start_game.png",
                                                          height: 80,
                                                          width: 80,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: Text(
                                                          'Thumb Activity',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xffda286f),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5),
                                                        child: Text(
                                                          'Press your thumb down and earn USDT',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      gameList == null ||
                                                              gameList.isEmpty
                                                          ? CircularProgressIndicator()
                                                          : Stack(
                                                              children: [
                                                                Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      3,
                                                                  child: GridView
                                                                      .builder(
                                                                    itemCount:
                                                                        gameList
                                                                            .length,
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    //physics: NeverScrollableScrollPhysics(),
                                                                    gridDelegate:
                                                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                                                      mainAxisSpacing:
                                                                          15,
                                                                      crossAxisSpacing:
                                                                          15,
                                                                      crossAxisCount:
                                                                          2,
                                                                      childAspectRatio: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          (360 /
                                                                              2.5),
                                                                    ),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (isbuttontap) {
                                                                              if (Balance >= gameList[index].gameAmount!) {
                                                                                setModalState(() {
                                                                                  isloading = true;
                                                                                  isbuttontap = false;
                                                                                });
                                                                                checkGameTimes(gameid: gameList[index].id).then((value) {
                                                                                  setModalState(() {
                                                                                    isloading = false;
                                                                                  });
                                                                                  if (status == 1) {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HoldToEarn(gameDuration: gameList[index].gameDuration.toString(), thumbDuration: gameList[index].thumbDuration.toString(), gameId: gameList[index].id.toString(), gameAmount: gameList[index].gameAmount.toString())));
                                                                                  } else {
                                                                                    setState(() {
                                                                                      istap = true;
                                                                                      isbuttontap = true;
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                });
                                                                              } else {
                                                                                showToast("Insufficient Balance");
                                                                              }
                                                                            }
                                                                          },
                                                                          // splashColor: gameList[index].gameAmount==0? Colors.orange.shade500
                                                                          // : Colors.blue.shade500,
                                                                          splashFactory: InkRipple
                                                                              .splashFactory,
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(5),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              border: Border.all(color: AppColors.grey),
                                                                              color: gameList[index].gameAmount == 0 ? Colors.orange.shade900 : Colors.blue.shade900,
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  // color: Colors.red,
                                                                                  color: gameList[index].gameAmount == 0 ? Colors.orange.shade900 : Colors.blue.shade900,
                                                                                  // color: const Color.fromARGB(255, 255, 255, 255),
                                                                                  height: 50,
                                                                                  child: Image.asset(
                                                                                    "assets/images/stopwatch.png",
                                                                                    color: Colors.white,
                                                                                    height: 50,
                                                                                    width: 35,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                Column(
                                                                                  children: [
                                                                                    Container(
                                                                                        padding: EdgeInsets.only(top: 10),
                                                                                        child: gameList[index].gameAmount == 0
                                                                                            ? Row(
                                                                                                children: [
                                                                                                  Text("${gameList[index].gameDuration / 60} mins",
                                                                                                      textAlign: TextAlign.left,
                                                                                                      style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: 13,
                                                                                                        color: Colors.white,
                                                                                                      )),
                                                                                                  Text(" (FreePlay)",
                                                                                                      textAlign: TextAlign.left,
                                                                                                      style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: 12,
                                                                                                        color: Colors.white,
                                                                                                      ))
                                                                                                ],
                                                                                              )
                                                                                            : Row(
                                                                                                children: [
                                                                                                  Text("${(gameList[index].gameDuration / 60).toStringAsFixed(3)} mins",
                                                                                                      textAlign: TextAlign.left,
                                                                                                      style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: 13,
                                                                                                        color: Colors.white,
                                                                                                      )),
                                                                                                  SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  gameList[index].gameAmount != 0
                                                                                                      ? Text("(Earn ${gameList[index].earningPercentage * double.parse(gameList[index].gameAmount.toString()) / 100} \$)",
                                                                                                          textAlign: TextAlign.left,
                                                                                                          style: TextStyle(
                                                                                                            fontWeight: FontWeight.w500,
                                                                                                            fontSize: 9,
                                                                                                            color: Colors.white,
                                                                                                          ))
                                                                                                      : SizedBox.shrink(),
                                                                                                ],
                                                                                              )),
                                                                                    Container(alignment: Alignment.centerLeft, child: gameList[index].gameAmount == 0 ? Text("Earn ${gameList[index].earningPercentage / 100} \$", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)) : Text('${gameList[index].gameAmount} \$-USDT', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ));
                                                                    },
                                                                  ),
                                                                ),
                                                                isloading
                                                                    ? Positioned
                                                                        .fill(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              LoadingAnimationWidget.staggeredDotsWave(
                                                                            color:
                                                                                AppColors.appcolordmiddark,
                                                                            size:
                                                                                60,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                    ])),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: Image.asset(
                                "assets/images/start_game.png",
                                width: MediaQuery.of(context).size.width / 4,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Battle",
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                _videocontroller.pause();
                                if (multigameList.isEmpty) {
                                  getMultiplayerGameList();
                                }
                                if (istap) {
                                  setState(() {
                                    istap = false;
                                  });
                                  showModalBottomSheet<void>(
                                    isScrollControlled: false,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20))),
                                    context: context,
                                    isDismissible: false,
                                    enableDrag: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return WillPopScope(
                                            onWillPop: () async {
                                              setState(() {
                                                istap = true;
                                                isbuttontap = true;
                                              });
                                              Navigator.pop(context);
                                              return true;
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      (BorderRadius.circular(
                                                          20)),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.2,
                                                child:
                                                    Column(children: <Widget>[
                                                  Container(
                                                    height: 30,
                                                    width: 50,
                                                    margin: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            50),
                                                    child: ElevatedButton(
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            istap = true;
                                                            isbuttontap = true;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor: Colors.white,
                                                          backgroundColor:
                                                              Color(0xffda286f),
                                                          animationDuration:
                                                              Duration(
                                                                  seconds: 1),
                                                        )),
                                                  ),
                                                  Container(
                                                    height: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffda286f)),
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/multiplayer_start_game.png"),
                                                          fit: BoxFit.fill,
                                                        )),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                      'Battle',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xffda286f),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      'Press your thumb down to battle and earn!',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  multigameList == null ||
                                                          multigameList.isEmpty
                                                      ? CircularProgressIndicator()
                                                      : Stack(
                                                          children: [
                                                            Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  3,
                                                              child: GridView
                                                                  .builder(
                                                                itemCount:
                                                                    multigameList
                                                                        .length,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        15),
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                gridDelegate:
                                                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                                                  mainAxisSpacing:
                                                                      15,
                                                                  crossAxisSpacing:
                                                                      15,
                                                                  crossAxisCount:
                                                                      2,
                                                                  childAspectRatio: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      (360 /
                                                                          2.5),
                                                                ),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (isbuttontap) {
                                                                          if (Balance1v1 >=
                                                                              multigameList[index].amount!) {
                                                                            setModalState(() {
                                                                              isloading = true;
                                                                              isbuttontap = false;
                                                                            });
                                                                            Repository().startGame(userId: SharedPreferencesFunctions().getLoginUserId(), gameId: multigameList[index].id, context: context).then((value) {
                                                                              value!.forEach((element) {
                                                                                setModalState(() {
                                                                                  isloading = false;
                                                                                });
                                                                                setState(() {
                                                                                  GameIdList.add(element);
                                                                                });
                                                                              });
                                                                              Navigator.pop(context);
                                                                              if (GameIdList.isNotEmpty) {
                                                                                Navigator.pushReplacement(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => WaitingPage(
                                                                                              gameId: GameIdList.last.gameId,
                                                                                              thumbconfig: multigameList[index].thumbconfig,
                                                                                              gameAmount: multigameList[index].amount.toString(),
                                                                                            )));
                                                                              } else {
                                                                                setState(() {
                                                                                  istap = true;
                                                                                  isbuttontap = true;
                                                                                });
                                                                                showToast("Something wents wrong");
                                                                              }
                                                                            });
                                                                          } else {
                                                                            showToast("Insufficient Balance");
                                                                          }
                                                                        }
                                                                      },
                                                                      splashFactory:
                                                                          InkRipple
                                                                              .splashFactory,
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          border:
                                                                              Border.all(color: AppColors.grey),
                                                                          color: Colors
                                                                              .blue
                                                                              .shade900,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 50,
                                                                              child: Image.asset(
                                                                                "assets/images/stopwatch.png",
                                                                                color: Colors.white,
                                                                                height: 50,
                                                                                width: 35,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Container(alignment: Alignment.centerLeft, child: Text('${multigameList[index].amount} \$-USDT', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
                                                                                SizedBox(
                                                                                  height: 3,
                                                                                ),
                                                                                Container(
                                                                                    child: Text("Game Fee : ${multigameList[index].adminearningper} %",
                                                                                        textAlign: TextAlign.left,
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: 12,
                                                                                          color: Colors.white,
                                                                                        ))),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ));
                                                                },
                                                              ),
                                                            ),
                                                            isloading
                                                                ? Positioned
                                                                    .fill(
                                                                    child:
                                                                        Center(
                                                                      child: LoadingAnimationWidget
                                                                          .staggeredDotsWave(
                                                                        color: AppColors
                                                                            .appcolordmiddark,
                                                                        size:
                                                                            60,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                ])),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 100,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // border: Border.all(color: Color(0xffda286f)),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/multiplayer_start_game.png"),
                                      fit: BoxFit.fill,
                                    )),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: YoutubePlayerBuilder(
                                player: YoutubePlayer(
                                  controller: _videocontroller,
                                  bottomActions: [
                                    const SizedBox(width: 14.0),
                                    CurrentPosition(
                                        controller: _videocontroller),
                                    const SizedBox(width: 8.0),
                                    ProgressBar(
                                        isExpanded: true,
                                        controller: _videocontroller,
                                        colors: ProgressBarColors(
                                            backgroundColor: Colors.white,
                                            handleColor: Colors.pink,
                                            playedColor: Colors.pink)),
                                    RemainingDuration(
                                        controller: _videocontroller),
                                    const PlaybackSpeedButton(),
                                  ],
                                  showVideoProgressIndicator: true,
                                ),
                                builder: (context, player) {
                                  return Container(child: player);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  checkGameTimes({var gameid}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/gameHistory/checkgameduration");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "userID": SharedPreferencesFunctions().getLoginUserId()!,
          "gameID": gameid
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          status = jsonDecode(response.body)['status'];
          if (status == 1) {
          } else {
            showToast(jsonDecode(response.body)['message']);
          }
        });
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        setState(() {
          status = jsonDecode(response.body)['status'];
        });
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
