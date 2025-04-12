import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/view/onboard/screens/onboard_screen.dart';

import '../../../const/app_sizes.dart';
import '../../dashboard/screens/bottom_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => userCheck()
    );
  }

  void userCheck() async {
    String userId = await AppSizes.uid;
    print(userId);
    if(userId.isEmpty){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ));
    }else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigatorScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightbrown,
      body: Center(
        child: Image.asset(
          "assets/images/cow.png",
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
