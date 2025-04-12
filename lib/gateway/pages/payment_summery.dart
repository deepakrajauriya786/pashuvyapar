
import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import 'home_page.dart';

class PaymentStatus extends StatefulWidget {
  final String resp;

  const PaymentStatus({required this.resp});

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushAndRemoveUntil<bool>(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text("Payment Status"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    widget.resp,
                    style:
                        new TextStyle(fontSize: 14, color: AppColors.blackLight),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
