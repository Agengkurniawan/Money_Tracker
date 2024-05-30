//chart_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cash_track/models/database.dart';
import 'package:cash_track/models/transaction_with_category.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late Stream<List<TransactionWithCategory>> _transactionsStream;
  late List<TransactionWithCategory> _transactions = [];

  @override
  void initState() {
    super.initState();
    _transactionsStream = AppDb().transactionsWithCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Transaksi'),
      ),
      body: StreamBuilder<List<TransactionWithCategory>>(
        stream: _transactionsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _transactions = snapshot.data!;
            return _buildChart();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildChart() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: _transactions.length.toDouble() - 1,
            minY: 0,
            maxY: _calculateMaxY(),
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                interval: 50000,
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (value) {
                  int index = value.toInt();
                  if (index >= 0 && index < _transactions.length) {
                    DateTime date = _transactions[index].transaction.transaction_date;
                    return DateFormat('MM/dd').format(date);
                  }
                  return '';
                },
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey),
            ),
            lineBarsData: [
              _generateLineChartBarData(true), // Pemasukan (biru)
              _generateLineChartBarData(false), // Pengeluaran (merah)
            ],
          ),
        ),
      ),
    );
  }

  double _calculateMaxY() {
    double maxAmount = 0;
    for (var transaction in _transactions) {
      if (transaction.category.type == 1) {
        if (transaction.transaction.amount > maxAmount) {
          maxAmount = transaction.transaction.amount.toDouble();
        }
      }
    }
    return maxAmount + 50000 - (maxAmount % 50000);
  }

  LineChartBarData _generateLineChartBarData(bool isIncome) {
    List<FlSpot> spots = [];
    for (int i = 0; i < _transactions.length; i++) {
      if (isIncome && _transactions[i].category.type == 1) {
        spots.add(FlSpot(i.toDouble(), _transactions[i].transaction.amount.toDouble()));
      } else if (!isIncome && _transactions[i].category.type != 1) {
        spots.add(FlSpot(i.toDouble(), _transactions[i].transaction.amount.toDouble()));
      }
    }
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [isIncome ? Colors.blue : Colors.red],
      barWidth: 4,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
    );
  }
}
