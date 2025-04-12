import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/view/dashboard/provider/bottom_navigation_provider.dart';

import '../../sell/screens/sell_screen_new.dart';
import '../../sell/screens/subscription.dart';

class BottomNavigationLayout extends StatelessWidget {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
      return Container(
        width: size.width,
        height: 80,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.6,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionPage(),
                        ));
                  },
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: lightbrown,
                          borderRadius: BorderRadius.circular(32)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "SELL",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: darkbrown),
                          ),
                          Image.asset(
                            "assets/images/cow.png",
                            height: 30,
                            width: 30,
                          )
                        ],
                      ))),
            ),
            Container(
              width: size.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      provider.setcurrentstate(0);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: provider.getcurrentstate() == 0
                              ? lightbrown
                              : Colors.white,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 11,
                            color: provider.getcurrentstate() == 0
                                ? lightbrown
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.setcurrentstate(1);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.ac_unit,
                          color: provider.getcurrentstate() == 1
                              ? lightbrown
                              : Colors.white,
                        ),
                        Text(
                          "Your Cattle",
                          style: TextStyle(
                            fontSize: 11,
                            color: provider.getcurrentstate() == 1
                                ? lightbrown
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.20,
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.setcurrentstate(2);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book,
                          color: provider.getcurrentstate() == 2
                              ? lightbrown
                              : Colors.white,
                        ),
                        Text(
                          "Pay Now",
                          style: TextStyle(
                            fontSize: 11,
                            color: provider.getcurrentstate() == 2
                                ? lightbrown
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.setcurrentstate(3);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.healing,
                          color: provider.getcurrentstate() == 3
                              ? lightbrown
                              : Colors.white,
                        ),
                        Text(
                          "List Detail",
                          style: TextStyle(
                            fontSize: 11,
                            color: provider.getcurrentstate() == 3
                                ? lightbrown
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = darkbrown
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
