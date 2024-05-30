//transaction_with_category.dart
import 'package:cash_track/models/database.dart';

class TransactionWithCategory {
  final Transaction transaction;
  final Category category;
  TransactionWithCategory(this.transaction, this.category);

}