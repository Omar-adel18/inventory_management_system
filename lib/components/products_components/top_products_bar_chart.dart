import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TopProductsBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> topProducts;

  const TopProductsBarChart({super.key, required this.topProducts});

  @override
  Widget build(BuildContext context) {
    // Filter out null or invalid TotalQuantity values and convert to double
    final validQuantities = topProducts
        .map((p) =>
            (p['TotalQuantity'] as int?)?.toDouble()) // Convert int to double
        .where((quantity) => quantity != null)
        .toList();

    // Calculate maxY, or use a default value if there are no valid quantities
    final double maxY = validQuantities.isNotEmpty
        ? validQuantities.reduce((a, b) => a! > b! ? a : b)! + 10
        : 10; // Default value if no valid quantities

    return Column(
      children: [
        Text(
          "Top 5 Products by Order Quantity", // Chart title
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 500,
          child: BarChart(

            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barGroups: topProducts.asMap().entries.map((entry) {
                final index = entry.key;
                final product = entry.value;
                final quantity =
                    (product['TotalQuantity'] as int?)?.toDouble() ??
                        0.0; // Convert int to double
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: quantity,
                      color: Colors.blue,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                );
              }).toList(),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 65,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= topProducts.length) {
                        return Text(''); // Handle out-of-bounds values
                      }

                      // Split the product name into words
                      final productName = topProducts[value.toInt()]['Name'];
                      final words = productName.split(' '); // Split by spaces

                      // Display each word in a column
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: words.map<Widget>((word) {
                          return Text(
                            word,
                            style: TextStyle(fontSize: 14 ,),
                            textAlign: TextAlign.center,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value % 5 == 0) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
