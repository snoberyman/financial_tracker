import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TotalExpenseList extends StatelessWidget {
  const TotalExpenseList({
    super.key,
    required this.groupedExpenses,
    required this.totalExpense,
  });

  final Map<String, double> groupedExpenses;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    if (groupedExpenses.isEmpty) {
      return const Center(
        child: Text(
          'No records found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final sortedEntries = groupedExpenses.entries.toList()
      ..sort((a, b) =>
          b.value.compareTo(a.value)); // Sort by amount in descending orderd

    // Convert sortedEntries back to a Map<String, double>
    final sortedMap = Map<String, double>.fromEntries(sortedEntries);
    return Column(
      children: [
        // Expense Categories
        // Expanded ListView for scrolling
        Expanded(
          child: ListView.builder(
            itemCount: sortedEntries.length,
            itemBuilder: (ctx, index) {
              String category = sortedEntries[index].key;
              double amount = sortedEntries[index].value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expense Name
                    Text(
                      category,
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Amount
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(),
        // Total Expense Row
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalExpense.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          child: PieChart(
            dataMap: sortedMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 2.5,
            initialAngleInDegree: 0,
            chartType: ChartType.disc,
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.left,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
            colorList: const [
              Color(0xFFFF8A65), // Medium Peach
              Color(0xFF81C784), // Medium Green
              Color(0xFFFFF176), // Warm Yellow
              Color(0xFFFFB74D), // Medium Orange
              Color(0xFFBA68C8), // Medium Lavender
              Color(0xFF9575CD), // Medium Purple
              Color(0xFF4DD0E1), // Medium Cyan
              Color(0xFFF06292), // Medium Pink
              Color(0xFFDCE775), // Warm Lime
              Color(0xFF9CCC65), // Olive Green
              Color(0xFF90A4AE), // Medium Grayish Blue
              Color(0xFFB0BEC5), // Medium Blue Gray
              Color(0xFFA1887F), // Warm Taupe
              Color(0xFF6D4C41), // Dark Brown
              Color(0xFF9E9D24), // Olive
            ],
            // gradientList: ---To add gradient colors---
            // emptyColorGradient: ---Empty Color gradient---
          ),
        )
      ],
    );
  }
}
