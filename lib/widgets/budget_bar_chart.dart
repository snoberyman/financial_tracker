import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BudgetBarChart extends StatelessWidget {
  final List<double> budgetData;
  final List<double> expensesData;

  const BudgetBarChart({
    super.key,
    required this.budgetData,
    required this.expensesData,
  });

  @override
  Widget build(BuildContext context) {
    if (budgetData.isEmpty || expensesData.isEmpty) {
      return Center(
        child: Text(
          'No data found',
          style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.6)),
        ),
      );
    }

    // Ensure there's at least one non-zero value in budgetData
    final maxYValue =
        (budgetData.isNotEmpty && budgetData.any((element) => element > 0))
            ? (budgetData.reduce((a, b) => a > b ? a : b) + 20).toDouble()
            : 100.00; // Default maxY to 100 if no valid budget data

    // Ensure budgetData and expensesData have at least 12 values
    final adjustedBudgetData = List<double>.filled(12, 0.0)
      ..setRange(0, budgetData.length, budgetData);
    final adjustedExpensesData = List<double>.filled(12, 0.0)
      ..setRange(0, expensesData.length, expensesData);

    final currentYear = DateFormat.y().format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '$currentYear',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 16), // Space between year text and chart
          SizedBox(
            height: 300, // Set a fixed height for the chart
            child: BarChart(
              BarChartData(
                maxY: maxYValue,
                barGroups: List.generate(6, (index) {
                  int dataIndex = index; // Adjust index to show last 6 months
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: adjustedBudgetData[dataIndex],
                        color: Color(0xFF42A5F5),
                        width: 15,
                      ),
                      BarChartRodData(
                        toY: adjustedExpensesData[dataIndex],
                        color: Color(0xFFEF5350),
                        width: 15,
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final currentDate = DateTime.now();
                        final monthsAgo =
                            5 - value.toInt(); // Calculate how many months ago
                        final date = DateTime(
                            currentDate.year, currentDate.month - monthsAgo);

                        if (monthsAgo >= 0 && monthsAgo <= 5) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              DateFormat.MMM().format(date),
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }
                        return const SizedBox
                            .shrink(); // Return an empty widget if out of range
                      },
                    ),
                  ),
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String month = DateFormat.MMM().format(DateTime.now()
                          .subtract(
                              Duration(days: 30 * (5 - group.x.toInt()))));
                      String type = rodIndex == 0 ? 'Budget' : 'Expenses';
                      return BarTooltipItem(
                        '$month\n$type: \$${rod.toY}',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
