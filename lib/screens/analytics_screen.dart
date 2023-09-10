import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MaterialApp(
    home: AnalyticsScreen(),
  ));
}

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Line Chart
          Container(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <LineSeries<PointData, DateTime>>[
                LineSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),

          // Bar Chart
          Container(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <BarSeries<PointData, DateTime>>[
                BarSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),

          // Pie Chart
          Container(
            height: 300,
            child: SfCircularChart(
              series: <PieSeries<PointData, DateTime>>[
                PieSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),

          Container(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <StackedColumnSeries<PointData, DateTime>>[
                StackedColumnSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            child: SfCircularChart(
              series: <DoughnutSeries<PointData, DateTime>>[
                DoughnutSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),
          // Inside the ListView children, add this Container for the Step Line Chart
          Container(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <StepLineSeries<PointData, DateTime>>[
                StepLineSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),
// Inside the ListView children, add this Container for the Range Area Chart
          Container(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <RangeAreaSeries<PointData, DateTime>>[
                RangeAreaSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  highValueMapper: (PointData point, _) => point.points,
                  lowValueMapper: (PointData point, _) =>
                      0, // Customize the low value
                ),
              ],
            ),
          ),
          // Inside the ListView children, add this Container for the Spline Chart
          Container(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              series: <SplineSeries<PointData, DateTime>>[
                SplineSeries<PointData, DateTime>(
                  dataSource: dataPoints,
                  xValueMapper: (PointData point, _) => point.date,
                  yValueMapper: (PointData point, _) => point.points,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PointData {
  final DateTime date;
  final double points;

  PointData(this.date, this.points);
}

final List<PointData> dataPoints = [
  PointData(DateTime(2023, 9, 1), 5),
  PointData(DateTime(2023, 9, 2), 8),
  PointData(DateTime(2023, 9, 3), 4),
  PointData(DateTime(2023, 9, 4), 7),
  PointData(DateTime(2023, 9, 5), 2),
  // Add more data points here.
];
