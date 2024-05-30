import 'package:flutter/material.dart';
import 'package:cash_track/Authentication/login.dart';
import 'package:cash_track/SQLite/sqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDB();
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
        colorScheme: ColorScheme.fromSeed(
          primary: const Color.fromRGBO(26, 18, 11, 1),
          seedColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
