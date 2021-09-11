import 'package:concoin/screens/introduction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import './screens/coin_flip_screen.dart';

int? initScreen;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Flipper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: initScreen == null || initScreen == 0 ? OnboardingScreen(): CoinFlipScreen(),
    );
  }
}
