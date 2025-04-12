import 'package:flutter/material.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/const/screen_sizes.dart';

import '../../../const/calender_selector.dart';
import '../../../const/dummy_data.dart';
import '../../dashboard/widgets/custom_header.dart';

class AddCattleScreen extends StatefulWidget {
  @override
  _CattleFormState createState() => _CattleFormState();
}

class _CattleFormState extends State<AddCattleScreen> {
  final TextEditingController tagNameController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  String? selectedAnimal;

  @override
  void initState() {
    super.initState();
    deliveryDateController.text = "01-Jan-2025"; // Default value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(
            title: "Add Cattle",
            addcattle: false,
          ),
          Divider(),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for Cattle Type
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black, // Default color for all text
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Cattle Type'),
                        TextSpan(
                          text: ' *',
                          style:
                              TextStyle(color: Colors.red), // Make the star red
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedAnimal,
                    hint: Text("Select Cattle Type"),
                    decoration: InputDecoration(
                      iconColor: darkbrown,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    items: animalData.map((animal) {
                      return DropdownMenuItem<String>(
                        value: animal["name"],
                        child: Row(
                          children: [
                            Image.asset(
                              animal["image"]!,
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(animal["name"]!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAnimal = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tag/Name Input
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black, // Default color for all text
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Tag/Name'),
                        TextSpan(
                          text: ' *',
                          style:
                              TextStyle(color: Colors.red), // Make the star red
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: tagNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      hintText: "Enter Tag/Name",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Last Delivery Date

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black, // Default color for all text
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Last Delivery Date'),
                        TextSpan(
                          text: ' *',
                          style:
                              TextStyle(color: Colors.red), // Make the star red
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: deliveryDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      hintText: "Select Date",
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: darkbrown,
                      ),
                    ),
                    onTap: () async {
                      deliveryDateController.text = await selectDate(context);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Add Cattle Button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: screenWidth(context) / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: lightbrown, width: 1.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Cattle",
                              style: TextStyle(
                                  color: lightbrown,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
