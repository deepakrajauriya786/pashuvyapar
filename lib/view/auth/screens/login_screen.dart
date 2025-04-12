import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:http/http.dart' as http;

import '../../../const/app_sizes.dart';
import '../../../const/screen_sizes.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _nameNumberController = TextEditingController();
  bool _isReferredByTabelaWala = false;

  Future<String> sendOtp(Map<String, dynamic> data) async {
    try {
      var response = await http.post(
        Uri.parse(AppSizes.BASEURL +"login_otp.php"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("otp send");
        return "success";
      } else {
        print(response.body);
        // server error
        print("Failed !");
        return "err";
      }
    } catch (SocketException ) {
      // fetching error
      print("Failed Server !");
      return "err";
    }
  }


  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Image.asset(
              //   'assets/images/tabela_wala_logo.png', // Replace with the actual logo path
              // ),
              // const SizedBox(height: 20),
              Image.asset(
                'assets/images/smartphone.png', height: 120,
                width: 120, // Replace with the actual illustration path
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We will send you a One Time Password on this number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameNumberController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        prefixText: "+91 ",
                        hintText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Checkbox(
                    value: _isReferredByTabelaWala,
                    onChanged: (value) {
                      setState(() {
                        _isReferredByTabelaWala = value!;
                      });
                    },
                  ),
                  const Text('Referred by Pashu Vyapar'),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 140,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                if (_mobileNumberController.text.length < 10) {


                  Fluttertoast.showToast(msg: "Please Enter Valid Number");

                } else {

                  String otp = randomNumeric(4);
                  Map<String, dynamic> data = {
                    'mobile': _mobileNumberController.text.toString(),
                    'otp': otp.toString()
                  };

                  String response= await sendOtp(data);
                  if(response == "success"){
                    // EasyLoading.dismiss();
                    Fluttertoast.showToast(msg: "OTP Sent Successfully ");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpScreen(_mobileNumberController.text.toString(),otp.toString(),_nameNumberController.text.toString()),
                        ));

                  }else{
                    // EasyLoading.dismiss();
                    Fluttertoast.showToast(msg: "Failed ! Please try again...");

                  }





                }




              },
              child: Container(
                width: screenWidth(context),
                height: 55,
                decoration: BoxDecoration(
                    color: darkbrown, borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Get OTP",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/images/startup_india_logo.png', // Replace with the actual logo path
                // ),
                Text(
                  'Recognised by Startup India',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              '100% Secure and Trusted by User',
              style: TextStyle(fontSize: 12),
            ),

          ],
        ),
      ),
    );
  }
}
