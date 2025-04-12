import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//google location api
const String ImageURL="https://pashuvyapar.in/tabela_wala/images/";
const String VideoURL="https://pashuvyapar.in/tabela_wala/videos/";

class AppSizes {
  static late MediaQueryData mediaQueryData;
  static late double screenheight;
  static late double screenwidth;

  static String BASEURL="https://pashuvyapar.in/tabela_wala/api/";

  static Future<String> get uid async {
    return await readStringFromPref();
  }

  // Method to read from SharedPreferences
  static Future<String> readStringFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('u_id') ?? '';
    return stringValue;
  }


  void initSizes(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenwidth = mediaQueryData.size.width;
    screenheight = mediaQueryData.size.height;
  }

}

Future<bool> showExitPopup(BuildContext context) async {
  return await showDialog(
    //show confirm dialogue
    //the return value will be from "Yes" or "No" options
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Exit App'),
      content: const Text('Do you want to exit an App?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black)),
              //return false when click on "NO"
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ).paddingSymmetric(horizontal: 30),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black)),
              //return true when click on "Yes"
              child: const Text('Yes').paddingSymmetric(horizontal: 30),
            ),
          ],
        )

      ],
    ),
  ) ??
      false; //if showDialogue had returned null, then return false
}
