import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/const/screen_sizes.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

// Remove unused video_player import if VideoPlayerScreen handles it
// import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import '../../../const/app_sizes.dart';
import '../../../const/dummy_data.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../sell/screens/sell_screen_new.dart';
import '../../sell/screens/video_play.dart'; // Assuming this contains VideoPlayerScreen
import '../widgets/banner_carousel.dart';

// --- Constants (Assuming these exist elsewhere but added for context) ---
// const String ImageURL = "YOUR_IMAGE_BASE_URL";
// const String VideoURL = "YOUR_VIDEO_BASE_URL";
// --- End Constants ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // REMOVE: This controller is no longer needed here
  // late PageController _pageController;
  String? locationController;

  // REMOVE: This controller and its initialization/dispose are likely handled within VideoPlayerScreen now
  // late VideoPlayerController _controller;

  // late Future<List<dynamic>> data;

  @override
  void initState() {
    super.initState();
    // REMOVE: Initialization of the shared controller
    // _pageController = PageController();
    // data = fetchProduct();
    // REMOVE: Video controller initialization if not used directly here
    // _controller = VideoPlayerController.network(...) // Example
  }

  @override
  void dispose() {
    // REMOVE: Disposal of the shared controller
    // _pageController.dispose();
    // REMOVE: Disposal of the video controller if not used directly here
    // _controller.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchProduct() async {
    try {
      String state='';
      if(locationController != null){
        state=locationController.toString();
      }else{
        state='';
      }

      final response =
          await http.get(Uri.parse("${AppSizes.BASEURL}product_fetch.php?state=${state.toString()}"));
      if (response.statusCode == 200) {
        print("Product data fetched: ${response.body}"); // More informative log
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // --- Top Row (AppBar like) ---
              Row(
                children: [
                  Image.asset("assets/images/cow.png", height: 40, width: 40),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellScreenNew(),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                          color: lightbrown,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Text("SELL",
                          style: TextStyle(
                              color: darkbrown,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ));
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade400, width: 1),
                          borderRadius: BorderRadius.circular(18)),
                      child: const Center(
                          child: Icon(Icons.notifications_none_outlined,
                              color: lightbrown)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Make sure your Scaffold has an endDrawer defined
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: const Icon(Icons.menu, color: darkbrown),
                  )
                ],
              ),
              const SizedBox(height: 10),

              // --- Search Bar ---
              Container(
                height: 45,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: darkbrown.withOpacity(0.5), width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Expanded(
                      child: DropdownButtonFormField<String>(
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
                          border:InputBorder.none,
                        ),
                      )
                      // TextField(
                      //   decoration: InputDecoration(
                      //     hintText: "Search Animals by Location...",
                      //     hintStyle: TextStyle(fontSize: 14),
                      //     border: InputBorder.none,
                      //     contentPadding: EdgeInsets.symmetric(
                      //         horizontal: 8, vertical: 12), // Adjusted padding
                      //   ),
                      // ),
                    ),
                    // Filter Button aligned with TextField height
                    InkWell(
                      // Use InkWell for tap feedback
                      onTap: () {

                        FutureBuilder<List<dynamic>>(
                          future: fetchProduct(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(color: darkbrown));
                            } else if (snapshot.hasError) {
                              print(
                                  "Error in FutureBuilder: ${snapshot.error}"); // Log error
                              return Center(child: Text("Error: ${snapshot.error}"));
                            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              final products = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                // Important for ListView inside SingleChildScrollView
                                physics: const NeverScrollableScrollPhysics(),
                                // Disable scrolling for this inner list
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  // *** USE THE NEW STATEFUL WIDGET ***
                                  return AnimalCardItem(data: products[index]);
                                },
                              );
                            } else {
                              return const Center(child: Text('No Animals Found'));
                            }
                          },
                        );

                        /* Add filter logic */
                      },
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: Container(
                        height: double.infinity,
                        // Takes full height of parent row
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: darkbrown,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.search,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // --- Animal Type Filter ---
              SizedBox(
                height: 40, // Adjust the height as needed
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: animalData.length,
                  // Assuming animalData is defined
                  itemBuilder: (context, index) {
                    final animal = animalData[index];
                    return _buildAnimalTypeChip(
                        animal['name']!, animal['image']!);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // --- Banner Carousel ---
              Container(
                height: 191, // Set a fixed height for the carousel
                child: BannerCarousel(), // Assuming BannerCarousel is defined
              ),
              const SizedBox(height: 20), // Added spacing

              // --- Product List ---
              FutureBuilder<List<dynamic>>(
                future: fetchProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: darkbrown));
                  } else if (snapshot.hasError) {
                    print(
                        "Error in FutureBuilder: ${snapshot.error}"); // Log error
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final products = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      // Important for ListView inside SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(),
                      // Disable scrolling for this inner list
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        // *** USE THE NEW STATEFUL WIDGET ***
                        return AnimalCardItem(data: products[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('No Animals Found'));
                  }
                },
              ),
              const SizedBox(height: 70), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the animal type chips at the top
  Widget _buildAnimalTypeChip(String title, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      // Reduced horizontal margin
      // height: 40, // Height is constrained by parent SizedBox
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // Adjusted padding
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: darkbrown.withOpacity(0.5))),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Take only necessary width
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            // Make circle slightly smaller
            child: Image.asset(
              imagePath,
              height: 30, // Adjust size
              width: 30, // Adjust size
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 13)),
          // Slightly smaller text
        ],
      ),
    );
  }
}

//-----------------------------------------------------
// NEW STATEFUL WIDGET FOR THE ANIMAL CARD ITEM
//-----------------------------------------------------
class AnimalCardItem extends StatefulWidget {
  final Map<String, dynamic> data;

  const AnimalCardItem({required this.data, super.key});

  @override
  State<AnimalCardItem> createState() => _AnimalCardItemState();
}

class _AnimalCardItemState extends State<AnimalCardItem> {
  // Each card item now manages its own PageController
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  // Function to handle sharing (moved here for better organization)
  void shareImageWithText(Map<String, dynamic> itemData) async {
    // Check if images list exists and is not empty
    if (itemData['images'] == null || (itemData['images'] as List).isEmpty) {
      print("No images found for sharing.");
      // Optionally show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image available to share.")),
      );
      return;
    }

    try {
      // Download the first image from the URL
      final String imageUrl = ImageURL +
          itemData['images'][0]
              .toString(); // Assuming ImageURL is your base URL
      print("Attempting to download image: $imageUrl");
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/shared_image_${DateTime.now().millisecondsSinceEpoch}.jpg'; // Unique name
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(response.bodyBytes);
        print("Image saved to: $imagePath");

        String text =
            'Welcome to Pashu Vyapar\n${itemData['bread'] ?? 'N/A'} ${itemData['cattle'] ?? 'N/A'}, ${itemData['total_milk'] ?? 'N/A'} Liter Capacity, '
            '${itemData['selectedPregnantTypeMonth'] ?? 'N/A'} pregnant, ${itemData['selectedVyaatTypeMonth'] ?? 'N/A'} Vyaat, '
            'Neeche Hai - ${itemData['selectedCalfHai'] ?? 'N/A'}\nprice: ₹ ${itemData['price'] ?? 'N/A'}\n'
            'Address: ${itemData['location'] ?? 'N/A'}\nDescription: ${itemData['description'] ?? 'N/A'}\n'
            'Install my App: https://play.google.com/store/apps/details?id=com.pashuvyapar.pashuvyapar'; // Replace with your actual app link

        await Share.shareXFiles([XFile(imagePath)], text: text);
        print("Sharing successful.");
      } else {
        print("Failed to download image. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to download image for sharing (${response.statusCode}).")),
        );
      }
    } catch (e) {
      print("Error sharing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while sharing: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the data passed to the widget
    final itemData = widget.data;
    final List<dynamic> mediaItems = itemData['images'] as List<dynamic>? ??
        []; // Handle null or non-list case

    return Card(
      margin: const EdgeInsets.only(bottom: 25),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Add some rounding
      clipBehavior: Clip.antiAlias,
      // Clip content to rounded border
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        // Only bottom padding for the Card's content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0), // Add top padding here
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // Use Expanded to prevent overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Use null-aware operators for safety
                          "${itemData['bread'] ?? 'N/A'} ${itemData['cattle'] ?? 'N/A'}, ${itemData['total_milk'] ?? 'N/A'} Liter Capacity, ${itemData['selectedPregnantTypeMonth'] ?? 'N/A'} pregnant, ${itemData['selectedVyaatTypeMonth'] ?? 'N/A'} Vyaat, Neeche Hai - ${itemData['selectedCalfHai'] ?? 'N/A'}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15, // Slightly smaller
                              color: darkbrown),
                          maxLines: 3, // Limit lines
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "₹ ${itemData['price'] ?? 'N/A'}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: darkbrown),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing before icon
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 25,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),

            // --- PageView and Indicator ---
            if (mediaItems.isNotEmpty) // Only show if there are items
              Column(
                children: [
                  SizedBox(
                    height: 350, // Adjust height as needed
                    child: PageView.builder(
                      controller: _pageController, // Use the local controller
                      itemCount: mediaItems.length,
                      pageSnapping: true,
                      itemBuilder: (context, index) {
                        final mediaUrl = mediaItems[index].toString();
                        if (mediaUrl.contains(".mp4")) {
                          print(
                              "Rendering Video: $VideoURL$mediaUrl"); // Assuming VideoURL base
                          return VideoPlayerScreen(
                              mediaUrl,mediaItems[0].toString()); // Pass the full or relative URL as needed by VideoPlayerScreen
                        } else {
                          // Assume it's an image
                          print(
                              "Rendering Image: $ImageURL$mediaUrl"); // Assuming ImageURL base
                          return Image.network(
                            ImageURL + mediaUrl, // Assuming ImageURL base
                            fit: BoxFit.cover,
                            // Add error and loading builders for better UX
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: darkbrown));
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  "Error loading image $ImageURL$mediaUrl: $error");
                              return const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.grey, size: 50));
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Use the local controller here too
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: mediaItems.length,
                    effect: const WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: darkbrown,
                      // Use your theme color
                      dotHeight: 8,
                      dotWidth: 8,
                      // Make dots square or adjust width
                      spacing: 6.0,
                    ),
                  ),
                ],
              )
            else
              // Placeholder if no images/videos
              Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                      child: Text("No Media Available",
                          style: TextStyle(color: Colors.grey)))),

            const SizedBox(height: 15), // Increased spacing
            // --- Location and Time ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(itemData['time'] ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  Flexible(
                    // Allow location text to wrap or shrink
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // Align to right if space allows
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 5),
                        Flexible(
                            // Inner flexible for text
                            child: Text(
                          itemData['location'] ?? 'N/A',
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                          overflow:
                              TextOverflow.ellipsis, // Handle long locations
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // --- Description ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(itemData['description'] ?? 'No description provided.',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
            ),
            const SizedBox(height: 15), // Increased spacing
            const Divider(height: 1, thickness: 0.5), // Add a subtle divider
            const SizedBox(height: 10),

            // --- Seller Info and Actions ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Seller Info (use Expanded for flexible width)
                  Expanded(
                    flex: 3, // Give more space to seller info initially
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          // Make avatar circular
                          child: Image.asset(
                            "assets/images/cow.png",
                            // Replace with actual user avatar if available
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          // Allow name to take remaining space and ellipsis if needed
                          child: Text(
                            itemData['name'] ?? 'Seller',
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            overflow:
                                TextOverflow.ellipsis, // Handle long names
                          ),
                        )
                      ],
                    ),
                  ),

                  // Action Buttons (use Expanded with less flex or fixed widths if preferred)
                  Expanded(
                    flex: 4, // Give slightly more space to buttons combined
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // Align buttons to the end
                      children: [
                        // Call Button
                        InkWell(
                          onTap: () {
                            final phoneNumber = itemData['mobile']?.toString();
                            if (phoneNumber != null && phoneNumber.isNotEmpty) {
                              launchUrlString("tel:$phoneNumber");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Phone number not available.")),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text("CALL",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 5),

                        // WhatsApp Button
                        InkWell(
                          onTap: () {
                            final phoneNumber = itemData['mobile']?.toString();
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
                          child: Image.asset("assets/images/whatsapp.png",
                              width: 35, height: 35), // Slightly smaller
                        ),
                        const SizedBox(width: 5),

                        // Share Button
                        InkWell(
                          onTap: () => shareImageWithText(itemData),
                          // Call the share function
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                                color: darkbrown,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text("SHARE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
