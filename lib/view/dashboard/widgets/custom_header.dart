import 'package:flutter/material.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/const/screen_sizes.dart';

import '../../your_cattle/screens/add_cattle_screen.dart';

class CustomHeader extends StatelessWidget {
  final String title;

  final bool addcattle;
  const CustomHeader({super.key, required this.title, this.addcattle = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: screenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: darkbrown, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          if (addcattle)
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCattleScreen(),
                    ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                height: 30,
                decoration: BoxDecoration(
                    color: lightbrown, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Add Cattle",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
