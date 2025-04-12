import 'package:flutter/material.dart';

import '../../../const/dummy_data.dart';
import '../../dashboard/widgets/custom_header.dart';
import '../widgets/cattle_card.dart';

class YourCattleScreen extends StatefulWidget {
  @override
  State<YourCattleScreen> createState() => _YourCattleScreenState();
}

class _YourCattleScreenState extends State<YourCattleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(
            title: "Your Cattle",
            addcattle: true,
          ),
          const Divider(),
          Expanded(
            child: cattleData.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cattleData.length,
                    itemBuilder: (context, index) {
                      final cattle = cattleData[index];
                      return CattleCard(
                        cattle: cattle,
                        onCrossDateSelected: (selectedDate) {
                          setState(() {
                            cattle["crossDate"] = selectedDate;
                          });
                        },
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[400],
                          child: const Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No Data Available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}
