import 'package:flutter/material.dart';
import 'package:cash_track/Authentication/signup.dart';
import 'package:cash_track/models/users.dart';
import 'package:cash_track/SQLite/sqlite.dart';
import 'package:cash_track/pages/mainpage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isVisible = false;
  bool isLoginTrue = false;
  final db = DatabaseHelper();
  final formKey = GlobalKey<FormState>();

  login() async {
    var response = await db
        .login(User(name: username.text, password: password.text));
    if (response == true) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainPage()));
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'lib/assets/uang.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(243, 240, 236, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: username,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white), // Set border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.white), // Set border color
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    obscureText: !isVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                      border: OutlineInputBorder(
                        
                        borderSide: const BorderSide(color: Colors.white), // Set border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        
                        borderSide: const BorderSide(color: Colors.white), // Set border color
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(243, 240, 236, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("LOGIN"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                    ],
                  ),
                  if (isLoginTrue)
                    Text(
                      "Username or password is incorrect",
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
