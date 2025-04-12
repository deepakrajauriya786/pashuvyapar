import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tabela_wala/const/color.dart';
import 'package:tabela_wala/view/dashboard/provider/bottom_navigation_provider.dart';
import 'package:tabela_wala/view/onboard/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Colors.transparent, // Set the status bar color to transparent
    statusBarIconBrightness:
        Brightness.dark, // Adjust icon brightness for contrast
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomNavigationProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pashu Vyapar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: darkbrown),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
