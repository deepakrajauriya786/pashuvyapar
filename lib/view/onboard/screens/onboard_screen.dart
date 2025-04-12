import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../const/color.dart';
import '../../../const/screen_sizes.dart';
import '../../auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to our App",
      "description": "This is the first onboarding screen",
      "image": "assets/images/cow.png", // Replace with actual image path
    },
    {
      "title": "Feature 1",
      "description": "Description of feature 1",
      "image": "assets/images/cow.png", // Replace with actual image path
    },
    {
      "title": "Feature 2",
      "description": "Description of feature 2",
      "image": "assets/images/cow.png", // Replace with actual image path
    },
    {
      "title": "Get Started",
      "description": "Let's begin your journey",
      "image": "assets/images/cow.png", // Replace with actual image path
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightbrown,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          data['image'],
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 10)   ,
                        // Text(
                        //   data['description'],
                        //   style: const TextStyle(fontSize: 16),
                        //   textAlign: TextAlign.center,
                        // ),
                      ],
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: _onboardingData.length,
                effect: const ExpandingDotsEffect(
                  dotColor: Colors.white70,
                  dotWidth: 13.0,
                  dotHeight: 11.0,
                  activeDotColor: darkbrown,
                  spacing: 7.0,
                  radius: 8.0,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (_currentPage == _onboardingData.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreen(), // Replace with your home screen
                      ),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Container(
                  width: screenWidth(context),
                  height: 55,
                  decoration: BoxDecoration(
                      color: darkbrown,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      _currentPage == _onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
