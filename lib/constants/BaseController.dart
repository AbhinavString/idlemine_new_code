import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';


class BaseController extends StatefulWidget {
  const BaseController({Key? key}) : super(key: key);

  @override
  State<BaseController> createState() => _BaseControllerState();
}

class _BaseControllerState extends State<BaseController> {
  late Timer mytimer = Timer(Duration(days: 100), () {});
  // void CheckAppCloseStatus() {
  //   mytimer = Timer.periodic(Duration(seconds: 10), (timer) {
  //     AppUser appUser = AppUser();
  //     appUser.appStatus().then((value) {
  //       if (value.status) {
  //         AppUtil.showSnackBar(
  //             context, 'Due to maintenance app is shutting down', 3,
  //             override: true);
  //         mytimer.cancel();
  //         exit(1);
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //CheckAppCloseStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
