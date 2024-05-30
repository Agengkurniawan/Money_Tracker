//category_page.dart
import 'package:flutter/material.dart';
import 'package:cash_track/models/database.dart';
// Import Category model

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  late int type;
  final AppDb database = AppDb();
  List<Category> listCategory = [];
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    type = isExpense ? 2 : 1;
    _refreshCategoryList();
  }

  Future<void> _refreshCategoryList() async {
    listCategory = await getAllCategory(type);
    setState(() {});
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future<void> insert(String name, int type) async {
    DateTime now = DateTime.now();
    await database.into(database.categories).insertReturning(
          CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updatedAt: now,
          ),
        );
    _refreshCategoryList();
  }

  Future<void> update(int categoryId, String newName) async {
    await database.updateCategoryRepo(categoryId, newName);
    _refreshCategoryList();
  }

  void openDialog(Category? category) {
    categoryNameController.clear();
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (category != null ? 'Edit Category ' : 'Add Category ') +
                        (isExpense ? "Expense" : "Income"),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: categoryNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null) {
                        insert(categoryNameController.text, isExpense ? 2 : 1);
                      } else {
                        update(category.id, categoryNameController.text);
                      }
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Management"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: isExpense,
                          inactiveTrackColor: Colors.grey[400],
                          inactiveThumbColor: Colors.grey[600],
                          activeColor: Colors.blueAccent,
                          onChanged: (bool value) {
                            setState(() {
                              isExpense = value;
                              type = value ? 2 : 1;
                              _refreshCategoryList();
                            });
                          },
                        ),
                        Text(
                          isExpense ? "Pengeluaran" : "Pemasukan",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        openDialog(null);
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Category>>(
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading data"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No data available"),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Card(
                            elevation: 10,
                            color: Colors.blueGrey[50],
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await database.deleteCategoryRepo(snapshot.data![index].id);
                                      _refreshCategoryList();
                                    },
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      openDialog(snapshot.data![index]);
                                    },
                                    color: Colors.blueAccent,
                                  ),
                                ],
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(3),
                                decoration
                                : BoxDecoration(
                                  color: isExpense
                                      ? Colors.redAccent
                                      : Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isExpense
                                      ? Icons.shopping_cart
                                      : Icons.attach_money,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                snapshot.data![index].name,
                                style: TextStyle(
                                  color: Colors.blueGrey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
