import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabela_wala/const/screen_sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import '../../../const/app_sizes.dart';
import '../../../const/color.dart';
import '../../../const/dummy_data.dart';
import '../../dashboard/screens/bottom_navigation_screen.dart';
import '../../dashboard/widgets/custom_header.dart';

class SellScreenNew extends StatefulWidget {
  const SellScreenNew({super.key});

  @override
  State<SellScreenNew> createState() => _SellScreenNewState();
}

class _SellScreenNewState extends State<SellScreenNew> {
  @override
  final PageController _pageController = PageController();
  final TextEditingController priceController = TextEditingController();
  // final TextEditingController locationController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  bool isLoading = false; // Track loading state
  bool isLoadingVideo = false; // Track loading state

  // Form State
  String? selectedAnimal;
  String? locationController;
  String? selectedBreed;
  List<String> availableBreeds = [];


  String? selectedVyaatHai;
  String? selectedCalfHai;

  String? selectedVyaatType;
  String? selectedVyaatTypeMonth;
  List<String> availableselectedVyaatType = [];

  String? selectedPregnantType;
  String? selectedPregnantTypeMonth;
  List<String> availableselectedPregnantType = [];



  double lactationValue = 5;
  double milkCapacity = 15;
  double currentMilkCapacity = 10;
  double _progressValue = 0.33; // Initial progress for step 1
  int _currentStep = 1;

  File? _image;
  File? _image1;
  File? _image2;
  File? _image3;
  File? _video;
  final ImagePicker _picker = ImagePicker();

  // Method to pick video
  // Future<void> _pickVideo() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _video = File(pickedFile.path);
  //     });
  //   }
  // }

  // File? _video;
  // VideoPlayerController? _controller;

  // Max allowed duration (e.g., 30 seconds)
  final Duration maxDuration = Duration(seconds: 30);

  // Future<void> _pickVideo() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     File file = File(pickedFile.path);
  //
  //     // Initialize a temporary video player to get duration
  //     VideoPlayerController tempController = VideoPlayerController.file(file);
  //     await tempController.initialize();
  //     Duration videoDuration = tempController.value.duration;
  //
  //     if (videoDuration > maxDuration) {
  //       setState(() {
  //         isLoadingVideo=false;
  //       });
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Video is too long. Max duration is 30 seconds.')),
  //       );
  //       tempController.dispose();
  //       return;
  //     }
  //
  //     // Compress the video
  //     final info = await VideoCompress.compressVideo(
  //       file.path,
  //       quality: VideoQuality.LowQuality,
  //       deleteOrigin: false, // set to true to remove original file
  //     );
  //
  //     if (info != null && info.file != null) {
  //       setState(() {
  //         _video = info.file;
  //         setState(() {
  //           isLoadingVideo=false;
  //         });
  //         // _controller = VideoPlayerController.file(_video!)
  //         //   ..initialize().then((_) {
  //         //     setState(() {});
  //         //     _controller!.play();
  //         //   });
  //       });
  //     }
  //
  //     tempController.dispose();
  //   }
  // }


  Future<File> compressImage(File file) async {
    final Uint8List imageBytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      return file; // Return the original file if decoding fails
    }

    // Resize and encode as JPEG with quality 80
    final img.Image resizedImage = img.copyResize(image, width: 500); // Adjust width as needed
    final Uint8List compressedBytes = img.encodeJpg(resizedImage, quality: 80);

    final tempDir = await getTemporaryDirectory();
    final compressedFile = File('${tempDir.path}/compressed_${file.path.split('/').last}');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File compressedFile = await compressImage(File(pickedFile.path));
      setState(() {
        _image = compressedFile;
      });
    }
  }

  Future<void> _pickImage1() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File compressedFile = await compressImage(File(pickedFile.path));
      setState(() {
        _image1 = compressedFile;
      });
    }
  }

  Future<void> _pickImage2() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File compressedFile = await compressImage(File(pickedFile.path));
      setState(() {
        _image2 = compressedFile;
      });
    }
  }
  Future<void> _pickImage3() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File compressedFile = await compressImage(File(pickedFile.path));
      setState(() {
        _image3 = compressedFile;
      });
    }
  }

  Future<void> _uploadImage() async {

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select images")),
      );
      return;
    }
    if (_image1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select images")),
      );
      return;
    }  if (_image2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select images")),
      );
      return;
    }

    // if (_video == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Please select images")),
    //   );
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    final userId = await AppSizes.uid;

    final uri = Uri.parse(AppSizes.BASEURL + "upload_product.php");
    var request = http.MultipartRequest('POST', uri);

    // Add the image file
    request.files.add(await http.MultipartFile.fromPath('img', _image!.path));
    request.files.add(await http.MultipartFile.fromPath('img1', _image1!.path));
    request.files.add(await http.MultipartFile.fromPath('img2', _image2!.path));
    // Add the video file
    // request.files.add(await http.MultipartFile.fromPath('img3', _image3!.path)); // New video field

    // Add the user ID
    request.fields['u_id'] = userId.toString();
    request.fields['selectedAnimal'] = selectedAnimal.toString();
    request.fields['selectedBreed'] = selectedBreed.toString();
    request.fields['lactationValue'] = lactationValue.toString();
    request.fields['milkCapacity'] = milkCapacity.toString();
    request.fields['currentMilkCapacity'] = currentMilkCapacity.toString();
    request.fields['price'] = priceController.text;
    request.fields['location'] = locationController.toString();
    request.fields['desc'] = descController.text;
    request.fields['selectedVyaatHai'] = selectedVyaatHai.toString();
    request.fields['selectedCalfHai'] = selectedCalfHai.toString();
    request.fields['selectedVyaatType'] = selectedVyaatType.toString();
    request.fields['selectedVyaatTypeMonth'] = selectedVyaatTypeMonth.toString();
    request.fields['selectedPregnantType'] = selectedPregnantType.toString();
    request.fields['selectedPregnantTypeMonth'] = selectedPregnantTypeMonth.toString();

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("Response: $responseBody");

        var jsondata = jsonDecode(responseBody.toString());
        print(jsondata);

        if (jsondata[0]['message'] == "1") {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Uploaded successfully")),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const BottomNavigatorScreen(), // Replace with your home screen
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed !")),
          );
        }

        // Get.back();
      } else {
        print("Upload failed with status: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred")),
      );
    }

    setState(() {
      isLoading = false;
    });

  }

  Future<void> openwhatsappmessage( number) async {
    final userId = await AppSizes.uid;
   String message ="Hello, I am interested to Uploading Video. And My Registration Id =$userId";
   String androidUrl = "whatsapp://send?phone=91$number&text=$message";
    String webUrl =
        "https://api.whatsapp.com/send/?phone=91$number&text=$message";

    // Check if WhatsApp is installed
    // bool? appIsInstalled = await InstalledApps.isAppInstalled("com.whatsapp");
    // if (appIsInstalled!) {
      if (await canLaunchUrl(Uri.parse(androidUrl))) {
        await launchUrl(Uri.parse(androidUrl));
      } else {
        print("WhatsApp URL could not be launched.");
      }
    // } else {
    //   // Launch web URL if WhatsApp is not installed
    //   await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    // }
  }

  // Navigation
  void _goToNextPage() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
        _progressValue += 0.33;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToPreviousPage() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _progressValue -= 0.33;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(
            title: "Add Your Cattle",
            addcattle: false,
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 10,
                        width:
                            MediaQuery.of(context).size.width * _progressValue,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text("${(_progressValue * 100).toInt()}%"),
              ],
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Cattle Type
                _buildCattleTypeStep(),
                // Step 2: Breed, Price, and Sliders
                _buildBreedAndSlidersStep(),
                // Step 3: Confirmation
                _buildConfirmationStep(),
              ],
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 1)
                  GestureDetector(
                    onTap: _goToPreviousPage,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: darkbrown, width: 1.5),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Text(
                        "PREVIOUS",
                        style: TextStyle(
                            color: darkbrown,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (_currentStep < 3)
                  GestureDetector(
                    onTap: _goToNextPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          color: lightbrown,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Text(
                        "NEXT",
                        style: TextStyle(
                            color: darkbrown,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (_currentStep == 3)
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      _uploadImage();

                    },
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text("SUBMIT"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Cattle Type Selection
  Widget _buildCattleTypeStep() {
    return SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth(context),
            child: const Text(
              textAlign: TextAlign.center,
              "Cattle Information",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'Select Cattle Type'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedAnimal,
            items: animalData
                .map((animal) => DropdownMenuItem(
              value: animal["name"],
              child: Row(
                children: [
                  Image.asset(
                    animal["image"]!,
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(animal["name"]!),
                ],
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedAnimal = value;
                availableBreeds = breedData
                    .firstWhere((breed) => breed["animal"] == value)["breeds"]
                    .cast<String>();
                selectedBreed = null;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'Select Breed'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedBreed,
            items: availableBreeds
                .map((breed) => DropdownMenuItem(
              value: breed,
              child: Text(breed),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedBreed = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const SizedBox(height: 20),
          _buildSlider("Lactation", lactationValue, 10, (value) {
            setState(() {
              lactationValue = value;
            });
          }),
          const SizedBox(
            height: 10,
          ),
          _buildSlider("Milk Capacity", milkCapacity, 25, (value) {
            setState(() {
              milkCapacity = value;
            });
          }),
          const SizedBox(
            height: 10,
          ),
          _buildSlider("Current Milk Capacity", currentMilkCapacity, 25,
                  (value) {
                setState(() {
                  currentMilkCapacity = value;
                });
              }),
        ],
      ),
    ),) ;
  }

  // Step 2: Breed Selection, Price, and Sliders
  Widget _buildBreedAndSlidersStep() {
    return SingleChildScrollView(child:  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth(context),
            child: const Text(
              textAlign: TextAlign.center,
              "Price and Others Information",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          // RichText(
          //   text: const TextSpan(
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16,
          //       color: Colors.black, // Default color for all text
          //     ),
          //     children: <TextSpan>[
          //       TextSpan(text: 'Vyaat'),
          //
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 10),
          // DropdownButtonFormField<String>(
          //   value: selectedVyaatHai,
          //   items: animalVyaat
          //       .map((animal) => DropdownMenuItem(
          //     value: animal["name"],
          //     child: Row(
          //       children: [
          //         Text(animal["name"]!),
          //       ],
          //     ),
          //   ))
          //       .toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       selectedVyaatHai = value;
          //     });
          //   },
          //   decoration: InputDecoration(
          //     prefixIcon: Icon(
          //       Icons.face,
          //       color: Colors.grey,
          //     ),
          //     border:
          //     OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'Does the animal have a calf/heifer ?'),

              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedCalfHai,
            items: calf
                .map((animal) => DropdownMenuItem(
              value: animal["name"],
              child: Row(
                children: [
                  Text(animal["name"]!),
                ],
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCalfHai = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),

          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'vyaayee huee hai ?'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedVyaatType,
            items: vyaatData
                .map((animal) => DropdownMenuItem(
              value: animal["name"],
              child: Row(
                children: [

                  Text(animal["name"]!),
                ],
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedVyaatType = value;
                availableselectedVyaatType = isVyaatType
                    .firstWhere((breed) => breed["animal"] == value)["breeds"]
                    .cast<String>();
                selectedVyaatTypeMonth = null;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'Calf Age'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedVyaatTypeMonth,
            items: availableselectedVyaatType
                .map((breed) => DropdownMenuItem(
              value: breed,
              child: Text(breed),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedVyaatTypeMonth = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),


          // is pragnent


          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'is pregnant ?'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedPregnantType,
            items: pregnentData
                .map((animal) => DropdownMenuItem(
              value: animal["name"],
              child: Row(
                children: [

                  Text(animal["name"]!),
                ],
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPregnantType = value;
                availableselectedPregnantType = isPragnentType
                    .firstWhere((breed) => breed["animal"] == value)["breeds"]
                    .cast<String>();
                selectedPregnantTypeMonth = null;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const SizedBox(height: 15),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'how many ago'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedPregnantTypeMonth,
            items: availableselectedPregnantType
                .map((breed) => DropdownMenuItem(
              value: breed,
              child: Text(breed),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPregnantTypeMonth = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'Other Information ( Optional )'),

              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.title),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              hintText: "Enter Description ( Optional )",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'Price'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.currency_rupee),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              hintText: "Enter price",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // Default color for all text
              ),
              children: <TextSpan>[
                TextSpan(text: 'State'),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red), // Make the star red
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: locationController,
            items: indianStates
                .map((animal) => DropdownMenuItem(
              value: animal["name"],
              child: Row(
                children: [

                  Text(animal["name"]!),
                ],
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                locationController = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.face,
                color: Colors.grey,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),


          // const SizedBox(height: 20),
          // _buildSlider("Lactation", lactationValue, 10, (value) {
          //   setState(() {
          //     lactationValue = value;
          //   });
          // }),
          // _buildSlider("Milk Capacity", milkCapacity, 25, (value) {
          //   setState(() {
          //     milkCapacity = value;
          //   });
          // }),
          // _buildSlider("Current Milk Capacity", currentMilkCapacity, 25,
          //     (value) {
          //   setState(() {
          //     currentMilkCapacity = value;
          //   });
          // }),
        ],
      ),
    ),);


  }

  Widget _buildSlider(
      String label, double value, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black, // Default color for all text
                ),
                children: <TextSpan>[
                  TextSpan(text: label),
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red), // Make the star red
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.5)),
              child: Center(
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: max.toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Step 3: Confirmation
  Widget _buildConfirmationStep() {
    return SingleChildScrollView(child: Center(
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(
          child: Text(
            "Upload Image ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Upload Image 1 "),
            ),
            const SizedBox(height: 20),
            _image != null
                ? Image.file(
              _image!,
              height: 100,
              width: 100,
            )
                : Text("Select Image 1 "),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _pickImage1,
              child: const Text("Upload Image 2 "),
            ),
            const SizedBox(height: 20),
            _image1 != null
                ? Image.file(
              _image1!,
              height: 100,
              width: 100,
            )
                : Text("Select Image 2 "),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: _pickImage2,
              child: const Text("Upload Image 3 "),
            ),
            const SizedBox(height: 20),
            _image2 != null
                ? Image.file(
              _image2!,
              height: 100,
              width: 100,
            )
                : Text("Select Image 3 "),
          ],
        ),  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: (){
                final phoneNumber = "9131739457";
                if (phoneNumber != null && phoneNumber.isNotEmpty) {
                  // Ensure number format is correct for WA link (e.g., no +)
                  launchUrlString(
                      "https://wa.me/91$phoneNumber"); // Assuming +91 country code
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text("WhatsApp number not available.")),
                  );
                }
              },
              child: const Text("Upload Video by Whatsapp "),
            ),
            // const SizedBox(height: 20),
            // _image3 != null
            //     ? Image.file(
            //   _image3!,
            //   height: 100,
            //   width: 100,
            // )
            //     : Text("Share video on Whatsapp"),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   // mainAxisSize: MainAxisSize.max,
        //   children: [
        //     ElevatedButton(
        //       onPressed: (){
        //         setState(() {
        //           isLoadingVideo=true;
        //         });
        //         _pickVideo();
        //       },
        //       child: const Text("Upload Video"),
        //     ),
        //     const SizedBox(height: 20),
        //     _video != null
        //         ? Text("Video Selected !"
        //       ,style: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.bold),)
        //         : isLoadingVideo ? CircularProgressIndicator():Text("Select Video..."),
        //   ],
        // ),
      ]).marginSymmetric(horizontal: 20),
    ),)
    ;
  }
}
