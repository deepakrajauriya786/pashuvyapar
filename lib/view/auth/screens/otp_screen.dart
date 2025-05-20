import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:http/http.dart' as http;

import '../../../const/app_sizes.dart';
import '../../../const/screen_sizes.dart';
import '../../dashboard/screens/bottom_navigation_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final String otpSend;
  final String name;

  const OtpScreen(this.mobile, this.otpSend,this.name, {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _mobileNumberController = TextEditingController();
  bool _isReferredByTabelaWala = false;

  String otp = "";
  String userId="";


  Future<String> loginAccount(Map<String, dynamic> data) async {
    try {
      var response = await http.post(
        Uri.parse(AppSizes.BASEURL + "registration.php"),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        print("data ${data['mobile']}");
        var jsondata = jsonDecode(response.body.toString());

        if (jsondata[0]['message']=="1") {
          addStringToPref(jsondata[0]['u_id'].toString(),data['mobile'].toString());

          return "success";
        } else {
          return "Failed";
        }
        return "Failed";
      } else {
        // server error
        print("Server Error !");
        return Future.error("Server Error !");
      }
    } catch (SocketException) {
      // fetching error
      print("Error Fetching Data !");
      return Future.error("Error Fetching Data !");
    }
  }

  Future<void> addStringToPref(String u_id,String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('u_id', u_id);
    prefs.setString('mobile', mobile);
    setState(() {});
    user();
  }

  void user() async {
    userId = await AppSizes.uid;
    setState(() {
      print("User ID: $userId");
    });

  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: darkbrown),
      borderRadius: BorderRadius.circular(8),
    );
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
                'OTP Verification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              widget.mobile=='1234567890'?
              Text(
                textAlign: TextAlign.center,
                "Login OTP is ${widget.otpSend} ",
                style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "outfit",
                    fontSize: 14),
              ): Text(
                textAlign: TextAlign.center,
                "Please enter your OTP that has been sent on your mobile number.",
                style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "outfit",
                    fontSize: 14),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                      child: Pinput(
                    focusedPinTheme: focusedPinTheme,
                    defaultPinTheme: defaultPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) =>
                    setState(() {
                      otp=pin;
                      print(otp);
                    }),

                  )),
                ],
              ),
              // const SizedBox(height: 5),
              // Row(
              //   children: [
              //     Checkbox(
              //       value: _isReferredByTabelaWala,
              //       onChanged: (value) {
              //         setState(() {
              //           _isReferredByTabelaWala = value!;
              //         });
              //       },
              //     ),
              //     const Text('Referred by TabelaWala'),
              //   ],
              // ),
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
                print("OTP: ${widget.otpSend}");
                if (otp.length == 4) {
                  // Add OTP submission logic here
                  if (otp == widget.otpSend) {
                    Map<String, dynamic> data = {'mobile': widget.mobile,'name': widget.name,};
                    String response = await loginAccount(data);

                    if (response == "success") {
                      Fluttertoast.showToast(msg: "Login Successfully");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigatorScreen(),
                          ));
                    } else {
                      Fluttertoast.showToast(msg: "Failed ! Please try again...");

                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please Enter Valid OTP");


                  }
                } else {
                  Fluttertoast.showToast(msg: "Please Enter Valid OTP");
                }


              },
              child: Container(
                width: screenWidth(context),
                height: 55,
                decoration: BoxDecoration(
                    color: darkbrown, borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Next",
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
            // const Text(
            //   '#startupindia',
            //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
