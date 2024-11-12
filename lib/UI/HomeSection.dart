import 'package:flutter/material.dart';
import 'package:desktop_crud_app/UI/ProductListScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import '../Helper/ColorHelper.dart';
import '../Model/SalesCategory.dart';
import '../Model/SalesData.dart';
import 'BillingScreen.dart';
import 'CategoryManager.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  List<SalesData> salesData = [];
  List<SalesData> salesData2 = [];
  List<SalesCategory> data = [];

  @override
  void initState() {
    // TODO: implement initState
    salesData = generateSampleData();
    salesData2 = generateSampleData2();
    data = generateSalesData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.lightWhiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                height: MediaQuery.of(context).size.height*0.3,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: ColorHelper.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blueAccent,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final date = salesData[spot.x.toInt()].date;
                            return LineTooltipItem(
                              "${date.month}/${date.year}\n\$${spot.y.toStringAsFixed(0)}",
                              TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (p0, p1) {

                      },
                      handleBuiltInTouches: true,
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) => Text(
                            '\$${value.toInt()}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1, // Shows all labels on the X-axis
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < salesData.length) {
                              DateTime date = salesData[value.toInt()].date;
                              return Text(
                                "${date.month}/${date.year}",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.blueGrey, width: 1),
                    ),
                    minX: 0,
                    maxX: salesData.length.toDouble() - 1,
                    minY: 0,
                    maxY: salesData.map((data) => data.sales).reduce((a, b) => a > b ? a : b) * 1.2,
                    lineBarsData: [
                      LineChartBarData(
                        spots: salesData
                            .asMap()
                            .entries
                            .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value.sales))
                            .toList(),
                        isCurved: true,
                        color: ColorHelper.blueColor,
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) => spot.x % 2 == 0, // Only show dots on every other point
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent.withOpacity(0.3), Colors.cyanAccent.withOpacity(0.1)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 50,),
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                height: MediaQuery.of(context).size.height*0.3,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: ColorHelper.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blueAccent,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final date = salesData2[spot.x.toInt()].date;
                            return LineTooltipItem(
                              "${date.month}/${date.year}\n\$${spot.y.toStringAsFixed(0)}",
                              TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (p0, p1) {

                      },
                      handleBuiltInTouches: true,
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) => Text(
                            '\$${value.toInt()}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1, // Shows all labels on the X-axis
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < salesData2.length) {
                              DateTime date = salesData2[value.toInt()].date;
                              return Text(
                                "${date.month}/${date.year}",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.blueGrey, width: 1),
                    ),
                    minX: 0,
                    maxX: salesData2.length.toDouble() - 1,
                    minY: 0,
                    maxY: salesData2.map((data) => data.sales).reduce((a, b) => a > b ? a : b) * 1.2,
                    lineBarsData: [
                      LineChartBarData(
                        spots: salesData2
                            .asMap()
                            .entries
                            .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value.sales))
                            .toList(),
                        isCurved: true,
                        color: ColorHelper.blueColor,
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) => spot.x % 2 == 0, // Only show dots on every other point
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent.withOpacity(0.3), Colors.cyanAccent.withOpacity(0.1)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 50,),
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                height: MediaQuery.of(context).size.height*0.3,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: ColorHelper.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        if (event.isInterestedForInteractions && pieTouchResponse != null) {
                          // Optional: add behavior for tooltip or change UI on hover/click
                        }
                      },
                    ),
                    startDegreeOffset: 30, // Rotate to start the first segment at an angle
                    sections: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;

                      return PieChartSectionData(
                        color: category.color,
                        value: category.value,
                        title: '${category.category}\n${category.value}%', // Multiline title
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        badgeWidget: _Badge(
                          icon: Icons.shopping_cart,
                          size: 20,
                          color: category.color,
                        ),
                        badgePositionPercentageOffset: 1.3, // Position badge on the edge of each segment
                        /*gradientColor: [
                                category.color.withOpacity(0.6),
                                category.color.withOpacity(0.9)
                              ],*/
                        borderSide: BorderSide(color: Colors.white, width: 2), // Adds a border around each segment
                      );
                    }).toList(),
                    centerSpaceRadius: 50,
                    sectionsSpace: 3,
                  ),
                ),
              ),
            ],
          ),


        ],
      )
    );
  }


  List<SalesData> generateSampleData() {
    return [
      SalesData(DateTime(2024, 1, 1), 500),
      SalesData(DateTime(2024, 2, 1), 600),
      SalesData(DateTime(2024, 3, 1), 800),
      SalesData(DateTime(2024, 4, 1), 700),
      SalesData(DateTime(2024, 5, 1), 1200),
      SalesData(DateTime(2024, 6, 1), 900),
      SalesData(DateTime(2024, 3, 1), 1000),
      SalesData(DateTime(2024, 4, 1), 1100),
      SalesData(DateTime(2024, 5, 1), 1200),
      SalesData(DateTime(2024, 6, 1), 1500),
    ];
  }

  List<SalesData> generateSampleData2() {
    return [
      SalesData(DateTime(2024, 1, 1), 500),
      SalesData(DateTime(2024, 2, 1), 600),
      SalesData(DateTime(2024, 3, 1), 1100),
      SalesData(DateTime(2024, 4, 1), 700),
      SalesData(DateTime(2024, 5, 1), 100),
      SalesData(DateTime(2024, 6, 1), 900),
      SalesData(DateTime(2024, 3, 1), 1000),
      SalesData(DateTime(2024, 4, 1), 1200)
    ];
  }
  List<SalesCategory> generateSalesData() {
    return [
      SalesCategory("Electronics", 300, Colors.blue),
      SalesCategory("Clothing", 200, Colors.red),
      SalesCategory("Home Goods", 100, Colors.green),
      SalesCategory("Beauty", 150, Colors.purple),
      SalesCategory("Sports", 80, Colors.orange),
    ];
  }

}

class _Badge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  _Badge({required this.icon, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.8),
      ),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}
