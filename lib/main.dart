import 'package:flutter/material.dart';
//import 'package:webapp/views/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webapp/views/create_post.dart';
import 'package:webapp/views/home_page.dart';
import 'package:webapp/views/login.dart';
import 'package:webapp/views/post_detail.dart';
import 'package:webapp/views/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD3EdIhy0tBjB4BDSb3gHHVapjsFTGEgQM",
      appId: "1:864161521062:web:b66c445198afb2947a8367",
      messagingSenderId: "864161521062",
      projectId: "webboardapp-3e283",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Board',
      theme: ThemeData(),
      home: Register(),
    );
  }
}
