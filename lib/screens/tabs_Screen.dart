import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:idlemine_latest/screens/setting_page.dart';

import '../utils/app_colors.dart';
import 'home.dart';
import 'profile.dart';


class TabScreen extends StatefulWidget {
  var index;
  TabScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List screens= [HomeScreen(), SettingPage(),Profile()];
  var _currentIndex =0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex=widget.index;
    });
   // secureScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.transparent_blk,
        selectedItemColor: AppColors.appcolordmiddark,
        unselectedItemColor: Colors.white70,
        type:BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/home.png"),
              size: 26,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/images/settings.png"),
                size: 26),
            label: '',
            backgroundColor: Color(0xff113162),
          ),
          // BottomNavigationBarItem(
          //   icon: ImageIcon(
          //     AssetImage("assets/images/market.png"),
          //     size: 26,),
          //   label: '',
          //   backgroundColor: Color(0xff113162),
          // ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/profile.png"),
              size: 26),
            label: '',
            backgroundColor: Color(0xff113162),
          ),
        ],
        onTap: (index) => setState(() { _currentIndex = index; },),
      ),
    );
  }
}