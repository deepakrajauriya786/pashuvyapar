import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_wala/view/dashboard/provider/bottom_navigation_provider.dart';
import 'package:tabela_wala/view/dashboard/screens/home_screen.dart';
import 'package:tabela_wala/view/dashboard/widgets/bottom_navigation_layout.dart';

import '../../../gateway/pages/home_page.dart';
import '../../daily_reports/screens/daily_report_screen.dart';
import '../../health/screens/health_screen.dart';
import '../../sell/screens/sell_screen_new.dart';
import '../../sell/screens/subscription.dart';
import '../../your_cattle/screens/your_cattle_screen.dart';
import '../widgets/navigation_drawer_layout.dart';
import 'list_product.dart';

class BottomNavigatorScreen extends StatelessWidget {
  const BottomNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Consumer<BottomNavigationProvider>(
            builder: (context, bottomnavigationprovider, child) {
          if (bottomnavigationprovider.getcurrentstate() == 0) {
            return HomeScreen();
          } else if (bottomnavigationprovider.getcurrentstate() == 1) {
            return YourCattleScreen();
          } else if (bottomnavigationprovider.getcurrentstate() == 2) {
            return SubscriptionPage();
          } else {
            return ListScreen();
          }
        }),
        Positioned(bottom: 0, left: 0, child: BottomNavigationLayout())
      ]),
      endDrawer: NavigationDrawerLayout(),
    );
  }
}
