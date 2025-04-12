import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/const/screen_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../onboard/screens/splash_screen.dart';

class NavigationDrawerLayout extends StatelessWidget {
  const NavigationDrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: screenWidth(context) * 0.7,
      child: Column(
        children: [
          customheader(context),
          // Menu Items
          SizedBox(
            height: 15,
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                // _buildListTile(Icons.person, 'Profile', () {}),
                // _buildListTile(Icons.favorite, 'Favorite Cattle', () {}),
                // _buildListTile(Icons.sell, 'On For Sell', () {}),
                // _buildListTile(Icons.report, 'Daily Reports', () {}),
                // _buildListTile(Icons.my_library_add, 'Your Cattle', () {}),
                // _buildListTile(
                //     Icons.production_quantity_limits_sharp, 'Products', () {}),
                // _buildListTile(Icons.more_horiz, 'Others', () {}),
                _buildListTile(Icons.group, 'Refer a Friend', () {
                  Share.share('Install my App: https://play.google.com/store/apps/details?id=');
                }),
                _buildListTile(Icons.policy, 'Terms & Conditions', () {
                  launchURI();
                }),
                const Divider(),
                _buildListTile(Icons.logout, 'Logout', () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final success = await prefs.remove('u_id');
                  print(success);
                  if(success){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(),
                        ));
                  }
                }, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void launchURI() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.example.myapp'); // Replace with your package name
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');}
  }
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? darkbrown : Colors.black),
      title: Text(
        title,
        style: TextStyle(color: isLogout ? darkbrown : Colors.black),
      ),
      onTap: onTap,
    );
  }

  Widget customheader(context) {
    return Container(
      height: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/cow.png",
            height: 90,
            width: 90,
          ),
        ],
      ),
    );
  }
}
