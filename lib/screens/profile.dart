import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idlemine_latest/screens/tabs_Screen.dart';
import 'package:idlemine_latest/screens/withdraw.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/getbalance_model.dart';
import '../models/getprofile_model.dart';
import '../reposiratory/repo.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';
import 'IdleMineDrawer.dart';
import 'package:image_picker/image_picker.dart';

import 'add_address_page.dart';
import 'login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  double Balance=00;
  double Balance1v1=00;
  List<BalanceData> balanceData=[];
  var playtoearning;
  var freetoearning;
  var selectedImage="";
  var isloading=true;
  var  globalRankFree="";
  var  globalRankPaid="";
  var count=0;
  var  referral="";
  Uint8List? myImage;
  var walletId=null;
  List<GetProfileModel> profileData=[];



  @override
  void initState() {
    getConnectivity(context);
    super.initState();
    //secureScreen();
    Repository().getProfile(userId: SharedPreferencesFunctions().getLoginUserId()!,context: context).then(
            (value) {
              setState(() {
                isloading=false;
              });
          print('getGameList');
          value!.forEach(
                  (element) {
                print("elementtttt$element");
                setState(() {
                  profileData.add(element);
                  print(profileData.first.profile);

                  playtoearning=profileData.first.paidgameearn;
                  freetoearning=profileData.first.freegameearn;
                  globalRankFree=profileData.first.globalrankfree.toString();
                  globalRankPaid=profileData.first.globalrankpaid.toString();
                  referral=profileData.first.referralCode;
                  if(profileData.first.profile==""||profileData.first.profile==null) {
                  }
                  else{
                    String base64Image = profileData.first.profile;
                    final UriData? data = Uri
                        .parse(base64Image)
                        .data;
                    print(data!.isBase64);
                    myImage = data!.contentAsBytes();
                    if (myImage != null || myImage != "") {
                      count = 1;
                      print("myImage==$myImage");
                    }
                  }

                });
                print("profileData=============$profileData");
              });
        });
    getBalance();
    getwalletId();
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
                    Balance =  balanceData.first.moneyInWallet.toDouble();
                    Balance1v1= balanceData.first.moneyInWallet1V1.toDouble();
                  }
                });
              });
        });
  }

  getwalletId() async {
    var url = '${baseurl}api/leaderboardsetting/getRewardWallet/${SharedPreferencesFunctions().getLoginUserId()}';

    final response = await http.get(Uri.parse(url),
      headers:<String, String>{
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid':SharedPreferencesFunctions().getLoginUserId()!,
      },
    );
    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print("success");
      print(jsonDecode(response.body));
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
          "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp) as List;
      if (responseBody.isNotEmpty)
        setState(() {
          walletId = responseBody.first["rewardWalletId"];
        });


    }
    else {
      print("failed");
      print(jsonDecode(response.body));
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TabScreen(index: 0,),
            ));
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: IdleMineDrawer(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customAppBar(context, scaffoldKey,Balance.toStringAsFixed(4),Balance1v1.toStringAsFixed(4)),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 30,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // testing for child widget which is using FlutterLogo
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child:  GestureDetector(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.orange,
                            child: count==0?ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: selectedImage==""?
                                    AssetImage("assets/images/profile_drawer.png"):
                                    FileImage(File(selectedImage))as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ):ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:MemoryImage(myImage!)as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ),
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context)
                              {
                                return SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(onPressed: () {
                                          Navigator.pop(context);
                                          _getFromGallery();
                                        }, child: Text('Gallery',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),)),
                                        Divider(thickness: 1,),
                                        TextButton(onPressed: () {
                                          Navigator.pop(context);
                                          _getFromCamera();
                                        }, child: Text('Camera',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black)))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                      ),
                      ),
                      SizedBox(height: 30,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         SizedBox(
                           width: MediaQuery.of(context).size.width/2-20,
                           child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Color(0xffda286f),
                               textStyle: const TextStyle(
                                   color: Colors.white,fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(10))),
                               shadowColor: Colors.pinkAccent,
                               elevation: 3,
                             ),
                             onPressed: () {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (_) => WithdrawScreen(route: "",)),
                               );
                             },
                             child: Container(
                               height: 50,
                               width: 200,
                               child: Center(
                                 child: Text(
                                   'Withdraw',

                                 ),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(
                           width: MediaQuery.of(context).size.width/2-20,
                           child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Color(0xffda286f),
                               textStyle: const TextStyle(
                                   color: Colors.white,fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(10))),
                               shadowColor: Colors.pinkAccent,
                               elevation: 3,
                             ),
                             onPressed: () {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (_) => WithdrawScreen(route: "1v1",)),
                               );
                             },
                             child: Container(
                               height: 50,
                               width: 200,
                               child: Center(
                                 child: Text(
                                   '1v1 Withdraw',
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),

                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(top: 35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Color(0xff240E3F),
                          border: Border.all(
                            //color: Colors.red,
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Play 2 Earn Earnings',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                playtoearning==null||playtoearning=="null"||playtoearning==""?"0.0000":
                                '${playtoearning.toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Color(0xff240E3F),
                          border: Border.all(
                            //color: Colors.red,
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Free 2 Play Earnings',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                freetoearning==null||freetoearning=="null"||freetoearning==""?"0.0000":
                                '${freetoearning.toStringAsFixed(4)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Color(0xff240E3F),
                          border: Border.all(
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Global Rank Free',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                globalRankFree=="null"||globalRankFree==""?"0":
                                '${globalRankFree.toString()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Color(0xff240E3F),
                          border: Border.all(
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Global Rank Paid',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                globalRankPaid=="null"||globalRankPaid==""?"0":
                                '${globalRankPaid.toString()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff240E3F),
                          border: Border.all(
                            //color: Colors.red,
                              width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Referral Code',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                '${referral==""?"":referral}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if(isloading)...[
                        Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      ]else...[
                        if(walletId==null)...[
                          SizedBox(height: 20,),
                          Container(
                              width: MediaQuery.of(context).size.width/1.5,
                              child: Text("Note:- Submit your Wallet ID (BEP-20) to Get Airdrop, Prizes, Rewards & More.",style: TextStyle(color: Colors.white))),
                          SizedBox(height: 10,),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff240E3F),
                              border: Border.all(
                                //color: Colors.red,
                                  width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Submit Wallet Id',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddress(),));
                                      }, child: Text("Submit")),
                                )
                              ],
                            ),
                          ),
                        ]else...[
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 30,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff240E3F),
                              border: Border.all(
                                //color: Colors.red,
                                  width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Submit Wallet Id',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(Icons.check_circle,color: Color(0xff12D202),),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddress(),));
                                      }, child: Text("Edit")),
                                )
                              ],
                            ),
                          ),
                        ]],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 150,
      imageQuality: 90,
    );
    if (pickedFile != null) {
      setState(() {
        count=0;
        selectedImage = pickedFile.path;
      });
      List<int> imageBytes = await File(pickedFile!.path).readAsBytesSync();
        print(imageBytes);
        String base64Image = "data:image/png;base64,"+base64Encode(imageBytes);
       // String base64Image = pre+base64Encode(bytes);
        print("img_pan : ${base64Image}");
        Repository().saveProfilePic(userid: SharedPreferencesFunctions().getLoginUserId()!, selectImage: base64Image,context: context);
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 150,
      imageQuality: 90,
    );
    if (pickedFile != null) {
      setState(() {
        count=0;
        selectedImage = pickedFile.path;
      });
      List<int> imageBytes = await File(pickedFile!.path).readAsBytesSync();
      print(imageBytes);
      String base64Image = "data:image/png;base64,"+base64Encode(imageBytes);
      // String base64Image = pre+base64Encode(bytes);
      print("img_pan : ${base64Image}");
      Repository().saveProfilePic(userid: SharedPreferencesFunctions().getLoginUserId()!, selectImage: base64Image,context: context);
    }
  }

}
