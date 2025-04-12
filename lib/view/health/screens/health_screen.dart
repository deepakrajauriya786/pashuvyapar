import 'package:flutter/material.dart';

import '../../dashboard/widgets/custom_header.dart';

class HealthScreen extends StatelessWidget {
  // Dummy JSON Data
  final List<Map<String, String>> dairyTips = [
    {
      "title": "Winter Care Tips",
      "description":
          "Take special care of your animals in winter season with Tips.",
    },
    {
      "title": "Effects of Cold",
      "description": "Cold weather can impact animal health significantly.",
    },
    {
      "title": "Nutrition Tips",
      "description": "Proper nutrition is key for animal well-being.",
    },
    {
      "title": "Winter Care Tips",
      "description":
          "Take special care of your animals in winter season with Tips.",
    },
    {
      "title": "Effects of Cold",
      "description": "Cold weather can impact animal health significantly.",
    },
    {
      "title": "Nutrition Tips",
      "description": "Proper nutrition is key for animal well-being.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const CustomHeader(
              title: "Health Request",
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/cow.png",
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Talk to our Pashumitra',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tell us animal problems now and we will get back to you with a solution.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  // Input Box
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Submit problem',
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 16),
                  // Book a Call Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        // Add your logic here
                      },
                      child: const Text(
                        'Book a Call',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Dairy Tips Header
                  Text(
                    'Dairy Tips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Horizontal ListView
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dairyTips.length,
                      itemBuilder: (context, index) {
                        final tip = dairyTips[index];
                        return Container(
                          width: 200,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tip['title']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  tip['description']!,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Colors.white // Background color for the page
        );
  }
}
