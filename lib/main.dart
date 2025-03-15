import 'package:flutter/material.dart';
import 'package:kototinder/screens/home_page.dart';

void main() {
  runApp(const TinderApp());
}

class TinderApp extends StatelessWidget {
  const TinderApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Cat Tinder',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.grey[300],
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.pink[500],
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
            bodyMedium: TextStyle(fontSize: 17, color: Colors.grey[700]),
          ),
          iconTheme: IconThemeData(color: Colors.pink[500]),
        ),
        home: const HomePage(),
      );
}
