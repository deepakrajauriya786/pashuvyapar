import 'package:flutter/material.dart';

import '../../../const/calender_selector.dart';
import '../../../const/color.dart';

class CattleCard extends StatefulWidget {
  final Map<String, dynamic> cattle;
  final Function(String) onCrossDateSelected;

  const CattleCard({required this.cattle, required this.onCrossDateSelected});

  @override
  _CattleCardState createState() => _CattleCardState();
}

class _CattleCardState extends State<CattleCard> {
  @override
  Widget build(BuildContext context) {
    final cattle = widget.cattle;
    final hasCrossDate = cattle["crossDate"] != null;

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Tag Number:- ${cattle["tag"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    cattle["image"],
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (!hasCrossDate) ...[
// Initial Card UI
              Text("Last Delivery Date",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.green),
                  SizedBox(width: 5),
                  Text(cattle["lastDeliveryDate"]),
                ],
              ),
              SizedBox(height: 10),
              const Text(
                "Note: It is advised to cross your animal within 100 days of delivery to know more contact TabelaWala Dr.",
                style: TextStyle(color: Colors.green),
              ),
              Divider(),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Select Cross Date",
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: darkbrown,
                  ),
                ),
                onTap: () async {
                  widget.onCrossDateSelected(await selectDate(context));
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final today = DateTime.now();
                  final crossDate = "${today.day}-${today.month}-${today.year}";
                  widget.onCrossDateSelected(crossDate);
                },
                child: Container(
                  height: 35,
                  width: 90,
                  child: Center(
                    child: Text(
                      "Send",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ] else ...[
// After Cross Date Selection
              Text("Last Delivery Date",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.green),
                  SizedBox(width: 5),
                  Text(cattle["lastDeliveryDate"]),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Cross Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.orange),
                  SizedBox(width: 5),
                  Text(cattle["crossDate"]),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Expected Check Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue),
                  SizedBox(width: 5),
                  Text("Mar 22, 2025 - Apr 6, 2025"),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Note: It is advised to check your animal pregnancy after 100 days of cross date.",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
