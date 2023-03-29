import 'package:flutter/material.dart';

import 'home_page.dart';
import 'palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Cera-Pro').copyWith(
        scaffoldBackgroundColor: Palette.whiteColor,
        primaryColor: Palette.firstSuggestionBoxColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Palette.whiteColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Palette.blackColor),
          titleTextStyle: TextStyle(
            color: Palette.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
