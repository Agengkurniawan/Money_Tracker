import 'package:flutter/material.dart';
import 'package:cash_track/models/database.dart';
import 'package:cash_track/models/transaction_with_category.dart';
import 'package:cash_track/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Track'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Today\'s Transactions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<List<TransactionWithCategory>>(
                stream: database.getTransactionByDateRepo(widget.selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TransactionPage(
                                          transactionsWithCategory: snapshot.data![index],
                                        ),
                                      ),
                                    ).then((value) {});
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(
                                      snapshot.data![index].category.type == 1
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    '${snapshot.data![index].transaction.amount} \$',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].category.name,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Text(
                          'No transactions yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add transaction page
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}