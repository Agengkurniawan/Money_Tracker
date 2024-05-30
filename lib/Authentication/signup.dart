import 'package:flutter/material.dart';
import 'package:cash_track/Authentication/login.dart';
import 'package:cash_track/models/users.dart';
import 'package:cash_track/SQLite/sqlite.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF), // Ubah warna latar belakang
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar "hello.png" di atas teks "REGISTER"
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
                            "REGISTER",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(243, 240, 236, 1), // Ubah warna teks
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input field untuk username
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF6C63FF),
                      border: Border.all(color: Colors.white), // Tambahkan border putih
                    ),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 242, 225, 1),
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: Color.fromRGBO(255, 242, 225, 1)),
                        border: InputBorder.none,
                        hintText: "Username",
                        hintStyle: TextStyle(color: Color.fromRGBO(255, 242, 225, 1)),
                      ),
                    ),
                  ),

                  // Input field untuk password
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF6C63FF),
                      border: Border.all(color: Colors.white), // Tambahkan border putih
                    ),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 242, 225, 1),
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Color.fromRGBO(255, 242, 225, 1)),
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Color.fromRGBO(255, 242, 225, 1)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color.fromRGBO(255, 242, 225, 1),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Input field untuk konfirmasi password
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF6C63FF),
                      border: Border.all(color: Colors.white), // Tambahkan border putih
                    ),
                    child: TextFormField(
                      controller: confirmPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Confirm Password is required";
                        } else if (password.text != confirmPassword.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      style: const TextStyle(
                        color: Color.fromRGBO(243, 240, 236, 1), // Ubah warna teks
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Color.fromRGBO(243, 240, 236, 1)), // Ubah warna ikon
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                        hintStyle: const TextStyle(color: Color.fromRGBO(243, 240, 236, 1)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color.fromRGBO(243, 240, 236, 1), // Ubah warna ikon
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol "SIGN UP"
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Proses pendaftaran akan dijalankan di sini
                          final db = DatabaseHelper();
                          db.signup(User(
                            name: username.text,
                            password: password.text,
                          )).whenComplete(() {
                            // Setelah berhasil mendaftar, pindah ke layar login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Ubah warna tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1), // Ubah warna teks
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Tombol "Login"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Color.fromRGBO(243, 239, 235, 1)),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigasi ke halaman login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)), // Ubah warna teks
                        ),
                      ),
                    ],
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
