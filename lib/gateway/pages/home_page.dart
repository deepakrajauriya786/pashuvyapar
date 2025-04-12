import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../const/app_sizes.dart';
import '../../const/color.dart';
import '../../view/dashboard/screens/bottom_navigation_screen.dart';
import '../../view/dashboard/widgets/custom_header.dart';
import '../../view/sell/screens/subscription.dart';
import '../data/payData.dart';
import '../style/app_colors.dart';
import '../utility/urlList.dart';
import 'test.dart';
import 'webview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _amountController = TextEditingController(text: "1.00");

  String errorText = "";

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigatorScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10), // Adds spacing
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 28, // Adjust size if needed
                  ),
                ).marginOnly(top: 30),
              ),
              Expanded( // Ensures proper alignment and spacing
                child: CustomHeader(
                  title: "Subscription Fees",
                  addcattle: false,
                ),
              ),
            ],
          ),

          Divider(),
          SizedBox(
            height: 20,
          ),
          Text("Pay ₹ 1/month For Paid Subscription",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _amountController,
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)),
                labelText: "Amount",
                errorText: errorText.isEmpty ? null : errorText,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5)),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty)
                  _fetchMerchantEncryptedData();
                else
                  setState(() {
                    errorText = "Please Enter valid amount";
                  });
              },
              child: Text("PAY"))
        ],
      ),
    ));
  }

  _fetchMerchantEncryptedData() async {
    try {
      setState(() {
        _loading = true;
        errorText = "";
      });

      Map<String, dynamic> datasend = {
        'amount': _amountController.text,
      };
      var response = await http.post(
        Uri.parse(AppSizes.BASEURL + "pay/ccavRequestHandler.php"),
        body: jsonEncode(datasend),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print("response is ${response.body}");

      final json = jsonDecode(response.body);
      final data = PaymentData.fromJson(json);
      if (data.statusMessage == "SUCCESS") {
        setState(() {
          _loading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => WebviewPageTest(
                      data: data,
                    )));
      } else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try again.")));
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _loading = false;
      });
    }
  }
}
