import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_task/auth/login_screen.dart';
import 'package:quiz_task/storage/shared_preferences.dart';

import 'UI/homeScreen/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom( // Text color
            surfaceTintColor:Colors.blue,
            overlayColor:Colors.blue,
            shadowColor: Colors.black, // Shadow color
            elevation: 2, // Elevation
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:UserSharedPreferences.getUserAccessToken() == null? LoginScreen():QuestionScreen(),
    );
  }
}

