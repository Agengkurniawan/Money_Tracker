import 'package:cash_track/pages/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:cash_track/models/database.dart';
import 'package:cash_track/pages/category_page.dart';
import 'package:cash_track/pages/home_page.dart';
import 'package:cash_track/pages/transaction_page.dart';
import 'package:cash_track/pages/chart_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  final database = AppDb();

  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    selectedDate = DateTime.now();
    updateView(0);
    super.initState();
  }

  Future<List<Category>> getAllCategory() {
    return database.select(database.categories).get();
  }

  void updateView(int index) {
    setState(() {
      currentIndex = index;
      _children = [
        HomePage(selectedDate: selectedDate),
        const CategoryPage(),
        ChartPage(), // Tambahkan halaman grafik
        const ProfilePage(), // Tambahkan halaman profil
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: (currentIndex == 0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) =>
                  const TransactionPage(transactionsWithCategory: null),
            ))
                .then((value) {
              setState(() {
                updateView(0);
              });
            });
          },
          backgroundColor: const Color(0xFF6C63FF), // Ubah warna FAB
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Ubah warna BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0);
              },
              icon: const Icon(Icons.home),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                updateView(1);
              },
              icon: const Icon(Icons.list),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChartPage(),
                ));
              },
              icon: const Icon(Icons.insert_chart),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                updateView(3); // Perbarui tampilan untuk halaman profil
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (currentIndex == 0)
            CalendarAppBar(
              fullCalendar: true,
              backButton: false,
              accent: const Color(0xFF6C63FF), // Ubah warna accent CalendarAppBar
              locale: 'id',
              onDateChanged: (value) {
                setState(() {
                  selectedDate = value;
                  updateView(0);
                });
              },
              lastDate: DateTime.now(),
            ),
          Expanded(child: _children[currentIndex]),
        ],
      ),
    );
  }
}
