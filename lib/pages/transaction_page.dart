//transaction_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cash_track/models/database.dart';
import 'package:cash_track/models/transaction_with_category.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionsWithCategory;
  const TransactionPage({Key? key, required this.transactionsWithCategory})
      : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  late int type;
  final AppDb database = AppDb();
  Category? selectedCategory;
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future insert(
      String description, int categoryId, int amount, DateTime date) async {
    DateTime now = DateTime.now();
    await database.into(database.transactions).insertReturning(
        TransactionsCompanion.insert(
            description: description,
            category_id: categoryId,
            amount: amount,
            transaction_date: date,
            created_at: now,
            updated_at: now));
  }

  @override
  void initState() {
    if (widget.transactionsWithCategory != null) {
      updateTransaction(widget.transactionsWithCategory!);
    } else {
      type = 2;
      dateController.text = "";
    }
    super.initState();
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  void updateTransaction(TransactionWithCategory initTransaction) {
    amountController.text = initTransaction.transaction.amount.toString();
    descriptionController.text =
        initTransaction.transaction.description.toString();
    dateController.text = DateFormat('yyyy-MM-dd')
        .format(initTransaction.transaction.transaction_date);
    type = initTransaction.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory = initTransaction.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Transaksi")),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Switch(
                      value: isExpense,
                      inactiveTrackColor: const Color.fromRGBO(167, 146, 119, 1),
                      inactiveThumbColor: const Color.fromRGBO(56, 49, 40, 1),
                      activeColor: const Color.fromRGBO(114, 95, 69, 1),
                      onChanged: (bool value) {
                        setState(() {
                          isExpense = value;
                          type = (isExpense) ? 2 : 1;
                          selectedCategory = null;
                        });
                      },
                    ),
                    Text(
                      isExpense ? "Pengeluaran" : "Pemasukan",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah',
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Kategori"),
                const SizedBox(height: 5),
                FutureBuilder<List<Category>>(
                  future: getAllCategory(type),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        return DropdownButtonFormField<Category>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          value: selectedCategory ?? snapshot.data!.first,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          onChanged: (Category? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          },
                          items: snapshot.data!.map((Category value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text("Belum ada kategori");
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Masukkan Tanggal",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Deskripsi',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      insert(
                        descriptionController.text,
                        selectedCategory!.id,
                        int.parse(amountController.text),
                        DateTime.parse(dateController.text),
                      );
                      Navigator.pop(context, true);
                    },
                    child: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
