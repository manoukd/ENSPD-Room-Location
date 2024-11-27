import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/details_page.dart';
import 'pages/welcome_page.dart'; // Import de la WelcomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ENSPD Rooms',
      theme: ThemeData(
        fontFamily: 'Poppins',  // Applique la police directement ici
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/home': (context) => HomePage(),
        '/detail': (context) => DetailsPage(),  // La route qui accepte l'argument
      },
    );
  }
}
