import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/EncryptDecryptUtil.dart';
import '../constants/custom_widget.dart';
import '../main.dart';
import '../models/deposite_history_model.dart';
import '../models/gameid_model.dart';
import '../models/gameplay_model.dart';
import '../models/get_gamelist_model.dart';
import '../models/getbalance_model.dart';
import '../models/getbanner_model.dart';
import '../models/getprofile_model.dart';
import '../models/globalranking_model.dart';
import '../models/lastweekRanking_model.dart';
import '../models/login_model.dart';
import '../models/multiplayergamelist_model.dart';
import '../models/onevone_model.dart';
import '../models/playtoearn_history_model.dart';
import '../models/referdata_model.dart';
import '../models/refferalhistory_model.dart';
import '../models/withdraw_history_model.dart';
import '../screens/login_screen.dart';
import '../services/auth_methods.dart';
import '../utils/app_colors.dart';
import '../utils/sharedPreferences.dart';

class Repository {
  var ResetStatus;
  var otpStatus = "3";
  var status = false;
  var statusCode = 200;
  var errorMessage = "Something went wrong";
  var statusMessage = "";
  var body;
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: "application/json"
  };

  Future<List<LoginData>?> Register({
    String email = "",
    String password = "",
    String refferedBy = "",
    var registerBy,
    context,
  }) async {
    print('Register');
    print("${baseurl}api/auth/register");
    print("$email,$password");

    Uri uri = Uri.parse("${baseurl}api/auth/register");

    print("$uri/api/auth/register");

    var response = await http.post(
      uri,
      headers: {
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "email": email.toString(),
        "password": password.toString(),
        "refferedBy": refferedBy.toString(),
        "registerBy": registerBy
      }),
    );

    print("Register response status code: ${response.statusCode}");
    print("Register response body: ${response.body}");
    // print("Register response ----------> $response");

    if (response.statusCode == 200) {
      showToast(jsonDecode(response.body)['message']);
      print("jsonDecode(response.body)${jsonDecode(response.body)}");
      SharedPreferencesFunctions()
          .saveLoginStatus(jsonDecode(response.body)['status'].toString());
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
          "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp) as List;
      print("responseBody$responseBody");
      final List<LoginData> allPostList =
          responseBody.map((e) => LoginData.fromJson(e)).toList();
      return allPostList;
    } else if (response.statusCode == 501) {
      print("loginnnnnn status====>${jsonDecode(response.body)}");
      this.statusCode = 501;
      print("statusCode$statusCode");
      this.status = false;
      SharedPreferencesFunctions().saveLoginStatuscode("501");
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
          "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp) as List;
      print("responseBody$responseBody");
      final List<LoginData> allPostList =
          responseBody.map((e) => LoginData.fromJson(e)).toList();
      return allPostList;
    } else if (response.statusCode == 403) {
      print("logout");
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      SharedPreferencesFunctions()
          .saveLoginStatus(jsonDecode(response.body)['status'].toString());
      print(jsonDecode(response.body));
      showToast(jsonDecode(response.body)["data"][0]['msg']);
    }
  }

  Future<List<LoginData>?> loginData(
      {String email = "", String password = "", context}) async {
    print('I am Called :- ');
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/login");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );
      // print("${baseurl}api/auth/login  ::: " ${json.encode({"email": email, "password": password})});
      print("${baseurl}api/auth/login  ::: " +
          json.encode({"email": email, "password": password}));

      print(response.statusCode);
      // print("${response.statusCode}");
      if (response.statusCode == 200) {
        print("loginnnnnn status====>${jsonDecode(response.body)}");

        Fluttertoast.showToast(
          msg: jsonDecode(response.body)['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.appcolordmiddark,
          textColor: AppColors.white,
          fontSize: 12.0,
        );
        SharedPreferencesFunctions()
            .saveLoginStatus(jsonDecode(response.body)['status'].toString());
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<LoginData> allPostList =
            responseBody.map((e) => LoginData.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 501) {
        print("loginnnnnn status====>${jsonDecode(response.body)}");
        this.statusCode = 501;
        print("statusCode$statusCode");
        this.status = false;
        SharedPreferencesFunctions().saveLoginStatuscode("501");
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<LoginData> allPostList =
            responseBody.map((e) => LoginData.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 402) {
        print("loginnnnnn status====>${jsonDecode(response.body)}");
        showToast(jsonDecode(response.body)['message']);
        SharedPreferencesFunctions()
            .saveLoginStatus(jsonDecode(response.body)['status'].toString());
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<LoginData> allPostList =
            responseBody.map((e) => LoginData.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print("loginnnnnn status====>${jsonDecode(response.body)}");
        showToast(jsonDecode(response.body)['message']);
        SharedPreferencesFunctions()
            .saveLoginStatus(jsonDecode(response.body)['status'].toString());
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getBalance({String id = "", context}) async {
    print('getBalance');
    try {
      Uri uri = Uri.parse(
          "${baseurl}api/admin/user/get-user-wallet-balance?userId=$id");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['data']);
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        final List<BalanceData> allPostList =
            responseBody.map((e) => BalanceData.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getHistory({
    var isFreeGame,
    context,
    var userid,
    var page,
  }) async {
    var url = '${baseurl}api/gameHistory/played-game-list';
    var data = json.encode({
      "page": page,
      "limit": "20",
      "is_free": isFreeGame,
      "userId": SharedPreferencesFunctions().getLoginUserId()!
    });

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid': SharedPreferencesFunctions().getLoginUserId()!,
      },
      body: data,
    );
    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      print("success");
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
          "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp)["docs"] as List;
      print("responseBody$responseBody");
      final List<GameHistoryData> allPostList =
          responseBody.map((e) => GameHistoryData.fromJson(e)).toList();
      print("allPostList$allPostList");
      return allPostList;
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print("failed");
      var Playtoearn = "0";
      var Freetoearn = "0";
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('Playtoearn', Playtoearn.toString());
      pref.setString('Freetoearn', Freetoearn.toString());
      print(jsonDecode(response.body));
    }
  }

  WithdrawHistory({var userId, var page, context}) async {
    print(userId);
    try {
      Uri uri = Uri.parse("${baseurl}api/withdraw/getWithdraw");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "page": page,
          "limit": "20",
          "userId": userId,
        }),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp)["docs"] as List;
        print("responseBody$responseBody");
        final List<WithdrawHistoryData> allPostList =
            responseBody.map((e) => WithdrawHistoryData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Withdraw1v1History({var userId, var page, context}) async {
    print(userId);
    try {
      Uri uri = Uri.parse("${baseurl}api/withdraw/getWithdraw1v1");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "page": page,
          "limit": "20",
          "userId": userId,
        }),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp)["docs"] as List;
        print("responseBody$responseBody");
        final List<WithdrawHistoryData> allPostList =
            responseBody.map((e) => WithdrawHistoryData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  DepositeHistoryy({var userId, var page, context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/admin/user/depositlist");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({"page": page, "limit": "20", "userId": userId}),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp)["docs"] as List;
        print("responseBody$responseBody");
        final List<DepositeHistoryData> allPostList =
            responseBody.map((e) => DepositeHistoryData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Deposit1v1History({var userId, var page, context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/admin/user/depositlist1v1");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({"page": page, "limit": "20", "userId": userId}),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp)["docs"] as List;
        print("responseBody$responseBody");
        final List<DepositeHistoryData> allPostList =
            responseBody.map((e) => DepositeHistoryData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getReferralHistory({var userId, var page, context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/admin/user/get-referral-list");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({"page": page, "limit": "20", "userId": userId}),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<ReferralHistoryData> allPostList =
            responseBody.map((e) => ReferralHistoryData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  resetPasswordApi(
      {var userId, var oldpassword, var newpassword, context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/changepassword");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "userId": userId,
          "oldpassword": oldpassword,
          "newpassword": newpassword
        }),
      );

      if (response.statusCode == 200) {
        ResetStatus = jsonDecode(response.body)["status"];
        SharedPreferencesFunctions().setResetStatus(ResetStatus.toString());
        print(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        ResetStatus = jsonDecode(response.body)["status"];
        SharedPreferencesFunctions().setResetStatus(ResetStatus.toString());
        showToast(jsonDecode(response.body)["message"]);
        print(jsonDecode(response.body));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  saveProfilePic({String userid = "", String selectImage = "", context}) async {
    print("selectImage==============$selectImage");
    Uri uri = Uri.parse("${baseurl}api/auth/updateProfile");
    var response = await http.post(
      uri,
      headers: {
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid': SharedPreferencesFunctions().getLoginUserId()!,
      },
      body: json.encode({"userId": userid, "profile": selectImage}),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      showToast("Profile Updated Successfully");
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print(jsonDecode(response.body));
    }
  }

  getProfile({String userId = "", context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/getprofile");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<GetProfileModel> allPostList =
            responseBody.map((e) => GetProfileModel.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  CurrentRankingFree({context}) async {
    try {
      Uri uri =
          Uri.parse("${baseurl}api/leaderboardsetting/currentleaderboardfree");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<GlobalrankingData> allPostList =
            responseBody.map((e) => GlobalrankingData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        //showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  CurrentRankingPaid({context}) async {
    try {
      Uri uri =
          Uri.parse("${baseurl}api/leaderboardsetting/currentleaderboardpaid");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<GlobalrankingData> allPostList =
            responseBody.map((e) => GlobalrankingData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        //showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  LastWeekRankingFree({context}) async {
    try {
      Uri uri =
          Uri.parse("${baseurl}api/leaderboardsetting/lastleaderboardfree");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<LastWeekRankData> allPostList =
            responseBody.map((e) => LastWeekRankData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        //showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  LastWeekRankingPaid({context}) async {
    try {
      Uri uri =
          Uri.parse("${baseurl}api/leaderboardsetting/lastleaderboardpaid");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<LastWeekRankData> allPostList =
            responseBody.map((e) => LastWeekRankData.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        //showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  activateAccountApi({String email = "", String password = "", context}) async {
    Uri uri = Uri.parse("${baseurl}api/activateaccount");
    var response = await http.post(
      uri,
      headers: {
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid': SharedPreferencesFunctions().getLoginUserId()!,
      },
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 400) {
      print("ashu");
      print(jsonDecode(response.body));
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)["statusMessage"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    print(jsonDecode(response.body));
  }

  isLogin({String token = "", context}) async {
    Uri uri = Uri.parse("${baseurl}api/auth/islogin");
    var response = await http.post(
      uri,
      headers: {
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid': SharedPreferencesFunctions().getLoginUserId()!,
      },
      body: json.encode({
        'token': token,
      }),
    );
    if (response.statusCode == 200) {
      print("issssloginnn=======${jsonDecode(response.body)}");
      SharedPreferencesFunctions()
          .saveIsloginstatus(jsonDecode(response.body)["status"].toString());
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      SharedPreferencesFunctions()
          .saveIsloginstatus(jsonDecode(response.body)["status"].toString());
      print(jsonDecode(response.body));
    }
  }

  /// for deactivate account
  deactivateAccount({int? status, String email = "", context}) async {
    var headers = {
      'appversion': version,
      'devicetype': 'android',
      'Content-Type': 'application/json',
      'userid': SharedPreferencesFunctions().getLoginUserId()!,
    };
    var request = http.Request(
        'POST', Uri.parse('${baseurl}api/auth/change-account-status'));
    request.body = json.encode({"email": email, "status": 0});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showToast("Your account Deactivate successfully");
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print(response.reasonPhrase);
      showToast(response.reasonPhrase!);
    }
  }

  activateAccount({int? status, String email = "", context}) async {
    var headers = {
      'appversion': version,
      'devicetype': 'android',
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('${baseurl}api/auth/change-account-status'));
    request.body = json.encode({"email": email, "status": status});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showToast("Your request successfully submitted");
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print(response.reasonPhrase);
      showToast(response.reasonPhrase!);
    }
  }

  ///get banner
  getBanner(context) async {
    print('getBanner');
    try {
      Uri uri = Uri.parse("${baseurl}api/announcement");
      var response = await http.get(uri, headers: {
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid': SharedPreferencesFunctions().getLoginUserId()!,
      });
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        if (responseBody.isNotEmpty) {
          final List<BannerData> allPostList =
              responseBody.map((e) => BannerData.fromJson(e)).toList();
          print("allPostList$allPostList");
          return allPostList;
        }
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ///get game list
  getGameList(context) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/game/getlist");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({"page": "1", "limit": "20"}),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        final responseBody = jsonDecode(resp)["docs"] as List;
        final List<GameListModel> allPostList =
            responseBody.map((e) => GameListModel.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getmultiplayerGameList(context) async {
    print('I am Called :- ');
    try {
      Uri uri = Uri.parse("${baseurl}api/1v1game/getlist");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({"page": "1", "limit": "20"}),
      );
      if (response.statusCode == 200) {
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        final responseBody = jsonDecode(resp)["docs"] as List;
        print("multiplayer==$responseBody");
        final List<MultiplayerGamelistModel> allPostList = responseBody
            .map((e) => MultiplayerGamelistModel.fromJson(e))
            .toList();
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ResendOtp({var email, context}) async {
    try {
      print("ResendOtp");
      Uri uri = Uri.parse("${baseurl}api/auth/resend-verify-otp");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
        },
        body: json.encode({"email": email}),
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        otpStatus = jsonDecode(response.body)["status"].toString();
        SharedPreferencesFunctions().setOtpStatus(otpStatus);
        print(otpStatus);
        showToast(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      print("resentapi ee==$e");
      return Future.error(e);
    }
  }

  updatePassword({var id, var password, context}) async {
    print("id==$id");
    print('I am Called :- ');
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/updatepassword");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
        },
        body: json.encode({"id": id, "password": password}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ConfirmOtp({var email, var otp, context}) async {
    print("ConfirmOtp");
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/verify-otp");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
        body: json.encode({"email": email, "otp": otp}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
        SharedPreferencesFunctions().saveConfirmOtpStatus(
            jsonDecode(response.body)['status'].toString());
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  ConfirmOtpForget({var email, var otp, context}) async {
    print("ConfirmOtpForget==$email");
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/confirmOTP");
      var response = await http.post(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
        },
        body: json.encode({"email": email, "otp": otp}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
        SharedPreferencesFunctions().saveForgotConfirmOtpStatus(
            jsonDecode(response.body)['status'].toString());
        SharedPreferencesFunctions()
            .saveLoginUserId(jsonDecode(response.body)["data"][0]["id"]);
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
        SharedPreferencesFunctions().saveForgotConfirmOtpStatus(
            jsonDecode(response.body)['status'].toString());
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  playGame(
      {var userId = "",
      var gameId = "",
      var is_win,
      var spendTime,
      var historyid = "",
      context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/gameHistory/save-played-game");
      var response = await http.post(uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid': SharedPreferencesFunctions().getLoginUserId()!,
          },
          body: jsonEncode({
            "userId": userId,
            "gameId": gameId,
            "is_win": is_win,
            "spendTime": spendTime,
            "historyid": historyid
          }));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<GamePlayModel> allPostList =
            responseBody.map((e) => GamePlayModel.fromJson(e)).toList();
        print("allPostList$allPostList");
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getReferData({String id = "", context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/admin/user/get-referral-data/$id");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['data']);
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        final responseBody = jsonDecode(resp) as List;
        final List<Referdatamodel> allPostList =
            responseBody.map((e) => Referdatamodel.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  withdrawSave(
      {var userId = "",
      var Amount = "",
      var Address = "",
      var charge = "",
      var receivable = "",
      context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/withdraw/save-withdrawal");
      var response = await http.post(uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid': SharedPreferencesFunctions().getLoginUserId()!,
          },
          body: jsonEncode({
            "userId": userId,
            "Amount": Amount,
            "Address": Address,
            "charge": charge,
            "receivable": receivable
          }));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  withdrawSave1v1(
      {var userId = "",
      var Amount = "",
      var Address = "",
      var charge = "",
      var receivable = "",
      context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/withdraw/save-withdrawal1v1");
      var response = await http.post(uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid': SharedPreferencesFunctions().getLoginUserId()!,
          },
          body: jsonEncode({
            "userId": userId,
            "Amount": Amount,
            "Address": Address,
            "charge": charge,
            "receivable": receivable
          }));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getDepositeInWallet(context) async {
    try {
      Uri uri = Uri.parse(
          "${baseurl}api/admin/user/get-deposit-in-wallet?userId=${SharedPreferencesFunctions().getLoginUserId()}");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      print("resentapi ee==$e");
      return Future.error(e);
    }
  }

  getDepositeInWallet1v1(context) async {
    try {
      Uri uri = Uri.parse(
          "${baseurl}api/admin/user/get-deposit-in-wallet-1v1?userId=${SharedPreferencesFunctions().getLoginUserId()}");
      var response = await http.get(
        uri,
        headers: {
          'appversion': version,
          'devicetype': 'android',
          'Content-Type': 'application/json',
          'userid': SharedPreferencesFunctions().getLoginUserId()!,
        },
      );
      if (response.statusCode == 200) {
        print("getDepositeInWallet1v1${jsonDecode(response.body)}");
        showToast(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      print("resentapi ee==$e");
      return Future.error(e);
    }
  }

  ///1v1 api's
  pingCheck({var userId = "", var gameId = "", var status, context}) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/1v1game/pingcheck");
      var response = await http.post(uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid': SharedPreferencesFunctions().getLoginUserId()!,
          },
          body: jsonEncode(
              {"gameHistoryId": gameId, "userid": userId, "status": status}));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        print("resp====$resp");
        // final responseBody = jsonDecode(resp) as List;
        // print("responseBody$responseBody");
        // final List<PingCheckModel> allPostList = responseBody.map((e) =>
        //     PingCheckModel.fromJson(e)).toList();
        // print("allPostList$allPostList");
        // return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  startGame({var userId = "", var gameId = "", context}) async {
    print("userId--$userId");
    print("gameId---$gameId");
    try {
      Uri uri = Uri.parse("${baseurl}api/1v1game/startGame");
      var response = await http.post(uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid': SharedPreferencesFunctions().getLoginUserId()!,
          },
          body: jsonEncode({
            "usreId": userId,
            "gameId": gameId,
          }));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
        var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
            "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
        final responseBody = jsonDecode(resp) as List;
        print("responseBody$responseBody");
        final List<GameIdModel> allPostList =
            responseBody.map((e) => GameIdModel.fromJson(e)).toList();
        return allPostList;
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print(jsonDecode(response.body));
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  getOneVoneHistory({
    context,
    var userid,
    var page,
  }) async {
    var url = '${baseurl}api/1v1gameHistory/played-game-list';
    var data = json.encode({
      "page": page,
      "limit": "20",
      "userId": SharedPreferencesFunctions().getLoginUserId()!
    });

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'appversion': version,
        'devicetype': 'android',
        'Content-Type': 'application/json',
        'userid': SharedPreferencesFunctions().getLoginUserId()!,
      },
      body: data,
    );
    debugPrint("post response statuscode=======>${response.statusCode}");

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      print("success");
      var resp = decryptAESCryptoJS(jsonDecode(response.body)["data"],
          "FakyR%9^rhnRLEwqg4TTBN*bIQ6*h%Jt");
      print("resp====$resp");
      final responseBody = jsonDecode(resp) as List;
      print("responseBody$responseBody");
      final List<OneVOneModel> allPostList =
          responseBody.map((e) => OneVOneModel.fromJson(e)).toList();
      print("allPostList$allPostList");
      return allPostList;
    } else if (response.statusCode == 403) {
      SharedPreferencesFunctions().logout();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print("failed");
      var Playtoearn = "0";
      var Freetoearn = "0";
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('Playtoearn', Playtoearn.toString());
      pref.setString('Freetoearn', Freetoearn.toString());
      print(jsonDecode(response.body));
    }
  }

  Create1v1Wallet(context) async {
    try {
      Uri uri = Uri.parse("${baseurl}api/auth/create1v1wallet");
      var response = await http.post(uri,
          headers: {
            'appversion': version,
            'devicetype': 'android',
            'Content-Type': 'application/json',
            'userid': SharedPreferencesFunctions().getLoginUserId()!,
          },
          body: json.encode({
            "id": SharedPreferencesFunctions().getLoginUserId()!,
          }));

      if (response.statusCode == 200) {
        print("Create1v1Wallet${jsonDecode(response.body)}");
        showToast(jsonDecode(response.body)['message']);
      } else if (response.statusCode == 403) {
        SharedPreferencesFunctions().logout();
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showToast(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}





















// Future<User> signInWithApple({List<Scope> scopes = const [],context}) async {
  //   final _firebaseAuth = FirebaseAuth.instance;
  //
  //   // 1. perform the sign-in request
  //   final result = await TheAppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential!;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken!),
  //         accessToken:
  //         String.fromCharCodes(appleIdCredential.authorizationCode!),
  //       );
  //       final userCredential =
  //       await _firebaseAuth.signInWithCredential(credential);
  //       final firebaseUser = userCredential.user!;
  //       if (scopes.contains(Scope.fullName)) {
  //         final fullName = appleIdCredential.fullName;
  //         if (fullName != null &&
  //             fullName.givenName != null &&
  //             fullName.familyName != null) {
  //           final displayName = '${fullName.givenName} ${fullName.familyName}';
  //           await firebaseUser.updateDisplayName(displayName);
  //           print(displayName);
  //           AppUser appUser = AppUser();
  //           appUser.email = firebaseUser.email!;
  //           appUser.password = firebaseUser.uid;
  //
  //           ResponseSmartAuditor response =
  //           await appUser.userLogin();
  //           if (response.status) {
  //             //AppUtil.hideLoader();
  //             AppUser.sharedInstance.dictToObject(response.body);
  //             AppUser.sharedInstance
  //                 .setUserDetailInSharedInstance();
  //
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (_) => TabScreen(index: 0,)),
  //             );
  //             AppUtil.PlaySound("success.wav", override: true);
  //
  //             AppUtil.showSnackBar(context, 'Login Successful', 1,
  //                 override: true);
  //           } else {
  //             if (response.statusMessage !=
  //                 "Internet Connection Unavailable")
  //               AppUtil.showSnackBar(
  //                   context, response.statusMessage, 3,
  //                   override: true);
  //             else
  //               AppUtil.showSnackBar(
  //                   context, response.statusMessage, 3,
  //                   override: true);
  //           }
  //         }
  //       }
  //       return firebaseUser;
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );
  //
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }



  // Future<User> signUpWithApple({List<Scope> scopes = const [],context}) async {
  //   final _firebaseAuth = FirebaseAuth.instance;
  //
  //   // 1. perform the sign-in request
  //   final result = await TheAppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential!;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken!),
  //         accessToken:
  //         String.fromCharCodes(appleIdCredential.authorizationCode!),
  //       );
  //       final userCredential =
  //       await _firebaseAuth.signInWithCredential(credential);
  //       final firebaseUser = userCredential.user!;
  //       if (scopes.contains(Scope.fullName)) {
  //         final fullName = appleIdCredential.fullName;
  //         if (fullName != null &&
  //             fullName.givenName != null &&
  //             fullName.familyName != null) {
  //           final displayName = '${fullName.givenName} ${fullName.familyName}';
  //           await firebaseUser.updateDisplayName(displayName);
  //           print(displayName);
  //           AppUser appUser = AppUser();
  //           appUser.email = firebaseUser.email!;
  //           appUser.password = firebaseUser.uid;
  //
  //           ResponseSmartAuditor responseSmartAuditor =
  //           await appUser.userRegister();
  //           if (responseSmartAuditor.status) {
  //             //AppUtil.hideLoader();
  //             AppUser.sharedInstance
  //                 .dictToObject(responseSmartAuditor.body);
  //
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (_) => TabScreen(index: 0,)),
  //             );
  //           }else
  //             await FirebaseAuth.instance.signOut();
  //           AppUtil.showSnackBar(context, responseSmartAuditor.statusMessage, 3,
  //               override: true);
  //
  //         }
  //       }
  //       return firebaseUser;
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );
  //
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  
  









