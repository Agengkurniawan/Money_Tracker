//database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:cash_track/models/category.dart';
import 'package:cash_track/models/transaction.dart';
import 'package:cash_track/models/transaction_with_category.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Categories, Transactions],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  // Properti transactionsWithCategory
  Stream<List<TransactionWithCategory>> get transactionsWithCategory {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId))
    ])
      ..orderBy([
        OrderingTerm.desc(transactions.transactionDate),
      ]));
    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  // CRUD Category
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  }

  Future updateCategoryRepo(int id, String newName) async {
    return (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        name: Value(newName),
      ),
    );
  }

  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((t) => t.id.equals(id))).go();
  }

  // CRUD Transaction
  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
      DateTime date) {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryId))
    ])
      ..where(transactions.transactionDate.equals(date)));
    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
