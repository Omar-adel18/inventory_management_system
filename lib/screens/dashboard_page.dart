import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_management_system/components/products_components/top_products_bar_chart.dart';
import 'package:inventory_management_system/utils/databasehelper.dart';
import '../components/categories_components/category_pie_chart.dart';

class DashboardScreen extends StatelessWidget {
  final dpHelper = DatabaseHelper();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverview(),
            Divider(
              height: 50,
              color: Colors.teal,
              indent: 20,
              endIndent: 20,
              thickness: 4,
            ),
            _buildOrdersPerDayChart(),
            Divider(
              height: 50,
              color: Colors.teal,
              indent: 20,
              endIndent: 20,
              thickness: 4,
            ),
            categoryOrderChart(),
            Divider(
              height: 50,
              color: Colors.teal,
              indent: 20,
              endIndent: 20,
              thickness: 4,
            ),
            topProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return FutureBuilder<Map<String, int>>(
      future: dpHelper.getOrdersAndItemsLastMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available"));
        }

        int totalOrders = snapshot.data!['totalOrders']!;
        int totalOrderItems = snapshot.data!['totalOrderItems']!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                " 📊 Current Month's Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    title: "Total Orders",
                    value: totalOrders,
                    subtitle: "Orders placed current month",
                    icon: Icons.shopping_cart,
                    color: Colors.teal,
                  ),
                  _buildStatCard(
                    title: "Items Sold",
                    value: totalOrderItems,
                    subtitle: "Products sold current month",
                    icon: Icons.inventory_2,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 8),
              Text(
                "$value",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersPerDayChart() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dpHelper.getOrdersPerDay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text("No orders data");
        }

        List<FlSpot> spots = snapshot.data!
            .asMap()
            .entries
            .map((e) => FlSpot(
                e.key.toDouble(), (e.value['totalOrders'] as int).toDouble()))
            .toList();

        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Orders Per Last 15 Days",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        isStepLineChart: true,
                        preventCurveOverShooting: true,
                        color: Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.4),
                        ),
                        aboveBarData: BarAreaData(
                          show: true,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) {
                            return true;
                          },
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            return (index >= 0 && index < snapshot.data!.length)
                                ? Text(
                                    DateTime.parse(
                                            snapshot.data![index]['OrderDate'])
                                        .day
                                        .toString(),
                                    style: TextStyle(fontSize: 12))
                                : Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      // border: Border.all(
                      //   color: Colors.black,
                      //   width: 4,
                      // ),
                      border: const Border(
                        right: BorderSide(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget categoryOrderChart() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dpHelper.getProductsPerCategoryInOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No order data available"));
        }
        return CategoryPieChart(data: snapshot.data!);
      },
    );
  }

  Widget topProducts() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dpHelper.getTop5ProductsByOrderQuantity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available"));
        }
        return TopProductsBarChart(topProducts: snapshot.data!);
      },
    );
  }
}
