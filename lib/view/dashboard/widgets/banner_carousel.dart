import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../const/app_sizes.dart';



class BannerCarousel extends StatefulWidget {
  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  List<dynamic> _bannerImages = [];

  //  List<String> _bannerImages = [
  //   // Add your image assets here
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  //   'assets/images/banner.png',
  // ];



  @override
  void initState() {
    super.initState();

    fetchData();

  }

  Future<void> fetchData() async {
    try {
      await getBannerList();

    } catch (e) {
      print('Error fetching data: $e');
    }
  }



  Future<String> getBannerList() async {
    try {
      final response = await http.get(Uri.parse(AppSizes.BASEURL +
          "banners.php?place_id=0"));
      if (response.statusCode == 200) {
        print("banner ${json.decode(response.body)}");

        for (var item in json.decode(response.body)) {
          _bannerImages.add(item['img']);
        }
        setState(() {});
        print("banner ${_bannerImages}");
        return "success";
      } else {
        throw Exception("Failed to fetch car list");
      }
    } catch (e) {
      print('Error fetching car list: $e');
      throw Exception("Error fetching car data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: _bannerImages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 183.0,
              viewportFraction: 1.0,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: _bannerImages
                .map((item) => buildBannerItem(item))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _bannerImages.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = entry.key),
                child: Container(
                  width: 0.0,
                  height: 0.0,
                  margin: EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.amber
                        : Colors.amber,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildBannerItem(String imagePath) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image:  NetworkImage(banner_img+imagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          // Image.network(BANNERIMAGE+imagePath)
        ],
      ),
    );
  }
}
