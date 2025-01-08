import 'package:flutter/material.dart';
import 'package:getnextframe_bug_demo/listings.dart';
import 'package:getnextframe_bug_demo/map_page.dart';

Future<void> main() async {
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mill Road Winter Fair',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapPage(listings: listings, key: mapPageKey),
    );
  }
}
