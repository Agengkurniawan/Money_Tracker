import 'package:flutter/material.dart';
import 'package:cash_track/Authentication/login.dart'; // Import file login.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    // Tambahkan logika logout di sini, misalnya menghapus token pengguna
    // Arahkan pengguna kembali ke halaman login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.zero, // Menghilangkan padding default ListView
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profil.png'), // Pastikan Anda memiliki gambar di folder assets
            ),
            const SizedBox(height: 20),
            const Text(
              'ageng kurniawan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'agengkurnia@unesa.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk mengedit profil di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman pengaturan di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                // Tambahkan logika untuk navigasi ke halaman bantuan di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _logout(context); // Panggil fungsi logout saat tombol Logout ditekan
              },
            ),
          ],
        ),
      ),
    );
  }
}
