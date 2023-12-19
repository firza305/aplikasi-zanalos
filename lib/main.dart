import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/controller/maincontroller.dart';
import 'package:loginpage/controller/servo_layout.dart';
import 'package:loginpage/primary_color.dart/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginpage/primary_color.dart/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBNPLPN8s5PHLje7oK7nI0RoP1l_fE-M04",
      appId: "1:398310096590:web:f780d4e0010c3c4eb2da9f",
      messagingSenderId: "398310096590",
      projectId: "tr-iot-a2b57",
      storageBucket: "tr-iot-a2b57.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ServoLayout(
        children: [],
      ),
      theme: ThemeData(primarySwatch: primaryBlack),
    );
  }
}
