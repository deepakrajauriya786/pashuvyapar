import 'package:flutter/material.dart';

import 'color.dart';

Future<String> selectDate(BuildContext context) async {
  // DateTime? pickedDate = await showDatePicker(
  //   context: context,
  //   initialDate: DateTime.now()
  //       .subtract(const Duration(days: 365 * 10)), // 10 years ago
  //   firstDate: DateTime(1900),
  //   lastDate: DateTime.now(),
  // );
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // 10 years ago
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    // .subtract(const Duration(days: 365 * 10)),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: darkbrown,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textTheme: TextTheme(
            bodyLarge: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontFamily: "Outfit"),
            bodyMedium: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkbrown,
                fontFamily: "Outfit"),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: darkbrown,
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Outfit"),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    String formattedDate =
        "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
    return formattedDate;
  }

  return "";
}
