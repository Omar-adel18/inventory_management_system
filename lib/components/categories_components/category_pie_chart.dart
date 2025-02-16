import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../const.dart';

class CategoryPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CategoryPieChart({super.key, required this.data});

  Widget buildLegend() {
    return Column(
      children: data.map((entry) {
        final String categoryName = entry['CategoryName'];
        final int productCount = entry['ProductCount'];

        return ListTile(
          leading: Container(
            width: 20,
            height: 20,
            color: getCategoryColor(categoryName),
          ),
          title: Text(
            categoryName,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            '$productCount products',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalProducts =
        data.fold(0, (sum, item) => sum + item['ProductCount'] as int);

    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Product Involvement in Orders: Category View",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: data.map((category) {
                  final percentage =
                      (category['ProductCount'] as int) / totalProducts * 100;
                  return PieChartSectionData(
                    value: category['ProductCount'].toDouble(),
                    title: "${percentage.toStringAsFixed(1)}%",
                    color: getCategoryColor(category['CategoryName']),
                    radius: 60,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            children: data.map((category) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: getCategoryColor(category['CategoryName']),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      category['CategoryName'],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          buildLegend(),
        ],
      ),
    );
  }

}
