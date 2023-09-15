// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  final String email;
  const AnalyticsScreen({
    Key? key,
    required this.email,
  }) : super(key: key);
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<PointData> _dateWiseData = [];
  bool line = true;
  bool bar = true;
  bool activity_vs_points = false;

  @override
  void initState() {
    super.initState();
    _fetchDateWiseData();
  }

  Future<void> _fetchDateWiseData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8082/user/${widget.email}/last-7-date-wise-data'));
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['last7DateWiseData'] is List) {
          final data = jsonResponse['last7DateWiseData'] as List;
          setState(() {
            _dateWiseData = data.map((item) {
              final dateStr = item['date'] as String;
              final date = DateTime.parse(dateStr);
              final formattedDate =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              return PointData(
                  date: formattedDate,
                  points: item['points'] as int,
                  activitiesCount: item['activitiesCount'] as int,
                  percent: item['percent'] as int);
            }).toList();
          });
        } else {
          print('Invalid data format');
        }
      } else {
        print('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: InkWell(
          onTap: () {
            setState(() {
              _fetchDateWiseData();
            });
          },
          child: Text(
            'Analytics',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    line = !line;
                  });
                },
                child: (line == true)
                    ? Text(
                        "Curve graph",
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        "Line graph",
                        style: TextStyle(color: Colors.black),
                      ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 233, 246, 247))),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bar = !bar;
                    });
                  },
                  child: (bar)
                      ? Text(
                          "Bar graph",
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          "Row graph",
                          style: TextStyle(color: Colors.black),
                        ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 233, 246, 247)))),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activity_vs_points = !activity_vs_points;
                    });
                  },
                  child: (activity_vs_points)
                      ? Text(
                          "activity_vs_points bar",
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          "activity_vs_points range",
                          style: TextStyle(color: Colors.black),
                        ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 233, 246, 247)))),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  (line == true)
                      ? SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.red),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.red),
                            ),
                            series: <ChartSeries<PointData, DateTime>>[
                              LineSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                color: Colors.green,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                                name: 'percent',
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.red),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.red),
                            ),
                            series: <SplineSeries<PointData, DateTime>>[
                              SplineSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                color: Colors.green,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                              ),
                            ],
                          ),
                        ),
                  (bar)
                      ? Container(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.green),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.green),
                            ),
                            series: <BarSeries<PointData, DateTime>>[
                              BarSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 1, 56, 101),
                                  Color.fromARGB(255, 16, 91, 152),
                                  Color.fromARGB(255, 110, 169, 251)
                                ]),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.green),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.green),
                            ),
                            series: <StackedColumnSeries<PointData, DateTime>>[
                              StackedColumnSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 1, 56, 101),
                                  Color.fromARGB(255, 16, 91, 152),
                                  Color.fromARGB(255, 110, 169, 251)
                                ]),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                              ),
                            ],
                          ),
                        ),
                  (activity_vs_points)
                      ? Container(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Points',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.grey),
                            ),
                            series: <StackedColumnSeries<PointData, DateTime>>[
                              StackedColumnSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                color: Colors.blue,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 0, 12, 21),
                                  Color.fromARGB(255, 18, 96, 159),
                                  Color.fromARGB(255, 158, 198, 254)
                                ]),
                                yValueMapper: (PointData point, _) =>
                                    point.activitiesCount,
                              ),
                              StackedColumnSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                color: Colors.white,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 0, 34, 9),
                                  Color.fromARGB(255, 0, 255, 47),
                                  Color.fromARGB(255, 110, 251, 115)
                                ]),
                                yValueMapper: (PointData point, _) =>
                                    point.points,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Points',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines:
                                  MajorGridLines(width: 1, color: Colors.grey),
                            ),
                            series: <RangeAreaSeries<PointData, DateTime>>[
                              RangeAreaSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                highValueMapper: (PointData point, _) =>
                                    point.activitiesCount,
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 20, 20, 20),
                                  Color.fromARGB(255, 6, 83, 145),
                                  Color.fromARGB(255, 107, 161, 236)
                                ]),
                                lowValueMapper: (PointData point, _) =>
                                    0, // Customize the low value
                              ),
                              RangeAreaSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 29, 29, 29),
                                  Color.fromARGB(255, 7, 96, 24),
                                  Color.fromARGB(255, 50, 212, 56)
                                ]),
                                highValueMapper: (PointData point, _) =>
                                    point.points,
                                lowValueMapper: (PointData point, _) =>
                                    0, // Customize the low value
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PointData {
  final String date;
  final int points;
  final int activitiesCount;
  final int percent;

  PointData({
    required this.date,
    required this.points,
    required this.percent,
    required this.activitiesCount,
  });
}
