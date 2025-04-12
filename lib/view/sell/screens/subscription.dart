import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../const/app_sizes.dart';
import '../../../gateway/pages/home_page.dart';
import 'sell_screen_new.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SubscriptionPage> {

  Future<List<dynamic>> statusUser() async {
    try {
      final userId = await AppSizes.uid;

      final response = await http.get(Uri.parse(
          "${AppSizes.BASEURL}user_status.php?u_id=${userId.toString()}"));
      if (response.statusCode == 200) {

        var jsondata = jsonDecode(response.body.toString());

        if (jsondata[0]['message']=="1") {

          // Fluttertoast.showToast(msg: "Delete Successfully");

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellScreenNew(),
              ));

          return jsonDecode(response.body.toString());
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));

          return jsonDecode(response.body.toString());
        }

        return jsonDecode(response.body);
      } else {
        print(
            "Server Error fetching products: ${response.statusCode} ${response.reasonPhrase}");
        throw Exception("Server Error!");
      }
    } catch (e) {
      print("Error fetching product data: $e");
      return Future.error("Error Fetching Data!");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sell On Subscription/Free"),
        ),
        body: Column(children: [
          Divider(),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellScreenNew(),
                    ));
              },
              child: Center(
                  child: Card(
                elevation: 2,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                // Add some rounding
                clipBehavior: Clip.antiAlias,
                // Clip content to rounded border
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  // Only bottom padding for the Card's content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- Description ---
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                            child: Text('Sell on Free',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ))),
                      )),

                      // --- Seller Info and Actions ---
                    ],
                  ),
                ),
              )).marginAll(20.0)),
          SizedBox(height: 10,),
          GestureDetector(
              onTap: () {
                statusUser();
              },
              child: Center(
                  child: Card(
                elevation: 2,
                color: Colors.yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                // Add some rounding
                clipBehavior: Clip.antiAlias,
                // Clip content to rounded border
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  // Only bottom padding for the Card's content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- Description ---
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                            child: Text('Sell on Paid',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ))),
                      )),

                      // --- Seller Info and Actions ---
                    ],
                  ),
                ),
              )).marginAll(20.0)),
        ]));
  }
}
