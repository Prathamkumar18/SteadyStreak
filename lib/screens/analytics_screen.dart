import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:steady_streak/utils/colors.dart';
import 'package:steady_streak/utils/config.dart';
import 'package:steady_streak/widgets/box.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/point_data.dart';
import '../utils/utils.dart';

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
  bool activityVsPoints = false;

  @override
  void initState() {
    super.initState();
    _fetchDateWiseData();
  }

  Future<void> _fetchDateWiseData() async {
    try {
      final response = await http
          .get(Uri.parse('$user/${widget.email}/last-7-date-wise-data'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['last7DateWiseData'] is List) {
          final data = jsonResponse['last7DateWiseData']! as List;
          setState(() {
            _dateWiseData = data.map((item) {
              final dateStr = item['date'] as String;
              final date = DateTime.parse(dateStr);
              final formattedDate =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              return PointData(
                date: formattedDate,
                points: item['points'] as int? ?? 0,
                activitiesCount: item['activitiesCount'] as int? ?? 0,
                percent: item['percent'] as int? ?? 0,
              );
            }).toList();
          });
        }
      } else {
        showSnackBar(context, 'Failed to load data');
      }
    } catch (error) {
      showSnackBar(context, 'fdsjflksdjfError: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _fetchDateWiseData();
              });
            },
            child: Text(
              'Analytics',
              style: TextStyle(color: white, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              for (int i = _dateWiseData.length - 1; i >= 0; i--)
                Box(
                  date: _dateWiseData.elementAt(i).date.substring(5),
                  val: _dateWiseData.elementAt(i).percent,
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    line = !line;
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 194, 240, 243))),
                child: (line == true)
                    ? Text(
                        "Curve graph",
                        style: TextStyle(color: black),
                      )
                    : Text(
                        "Line graph",
                        style: TextStyle(color: black),
                      ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bar = !bar;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 194, 240, 243))),
                  child: (bar)
                      ? Text(
                          "Bar graph",
                          style: TextStyle(color: black),
                        )
                      : Text(
                          "Row graph",
                          style: TextStyle(color: black),
                        )),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activityVsPoints = !activityVsPoints;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 194, 240, 243))),
                  child: (activityVsPoints)
                      ? Text(
                          "activity_vs_points bar",
                          style: TextStyle(color: black),
                        )
                      : Text(
                          "activity_vs_points range",
                          style: TextStyle(color: black),
                        )),
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
                              majorGridLines: MajorGridLines(
                                  width: 0.1, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.1, color: Colors.grey),
                            ),
                            series: <RangeAreaSeries<PointData, DateTime>>[
                              RangeAreaSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                highValueMapper: (PointData point, _) =>
                                    point.percent,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 0, 119, 255),
                                    Color.fromARGB(131, 0, 119, 255),
                                    Color.fromARGB(13, 0, 119, 255),
                                  ],
                                ),
                                borderWidth: 1,
                                borderColor: Colors.blue,
                                lowValueMapper: (PointData point, _) => 0,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.1, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.1, color: Colors.grey),
                            ),
                            series: <SplineAreaSeries<PointData, DateTime>>[
                              SplineAreaSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 0, 119, 255),
                                    Color.fromARGB(131, 0, 119, 255),
                                    Color.fromARGB(13, 0, 119, 255),
                                  ],
                                ),
                                borderWidth: 1,
                                borderColor:
                                    const Color.fromARGB(255, 0, 140, 255),
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                              ),
                            ],
                          ),
                        ),
                  (bar)
                      ? SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.2, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.2, color: Colors.grey),
                            ),
                            series: <BarSeries<PointData, DateTime>>[
                              BarSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                gradient: LinearGradient(
                                  begin:
                                      Alignment.topCenter, // Start from the top
                                  end: Alignment
                                      .bottomCenter, // End at the bottom
                                  colors: [
                                    Color.fromARGB(202, 32, 199, 38),
                                    const Color.fromARGB(86, 33, 149, 243)
                                  ],
                                ),
                                borderWidth: 1,
                                borderGradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color.fromARGB(255, 42, 226, 48),
                                    Colors.blue
                                  ],
                                ),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle:
                                      TextStyle(color: white, fontSize: 12),
                                ),
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.2, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Percent',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.2, color: Colors.grey),
                            ),
                            series: <ColumnSeries<PointData, DateTime>>[
                              ColumnSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle:
                                      TextStyle(color: white, fontSize: 12),
                                ),
                                gradient: LinearGradient(
                                  begin:
                                      Alignment.topCenter, // Start from the top
                                  end: Alignment
                                      .bottomCenter, // End at the bottom
                                  colors: [
                                    Color.fromARGB(202, 32, 199, 38),
                                    const Color.fromARGB(86, 33, 149, 243)
                                  ],
                                ),
                                borderWidth: 1,
                                borderGradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color.fromARGB(255, 42, 226, 48),
                                    Colors.blue
                                  ],
                                ),
                                yValueMapper: (PointData point, _) =>
                                    point.percent,
                              ),
                            ],
                          ),
                        ),
                  (activityVsPoints)
                      ? SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.5, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Points',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.5, color: Colors.grey),
                            ),
                            series: <ColumnSeries<PointData, DateTime>>[
                              ColumnSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                color: Colors.blue,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle:
                                      TextStyle(color: white, fontSize: 12),
                                ),
                                borderColor: Colors.red,
                                borderWidth: 0.2,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 241, 39, 39),
                                    Color.fromARGB(37, 255, 255, 3)
                                  ],
                                ),
                                yValueMapper: (PointData point, _) =>
                                    point.activitiesCount,
                              ),
                              ColumnSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                color: white,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle:
                                      TextStyle(color: white, fontSize: 12),
                                ),
                                borderColor: Colors.orange,
                                borderWidth: 0.2,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(196, 255, 234, 3),
                                    Color.fromARGB(64, 143, 241, 39),
                                  ],
                                ),
                                yValueMapper: (PointData point, _) =>
                                    point.points,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: DateTimeAxis(
                              title: AxisTitle(
                                text: 'Date',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.2, color: Colors.grey),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(
                                text: 'Points',
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              majorGridLines: MajorGridLines(
                                  width: 0.2, color: Colors.grey),
                            ),
                            series: <RangeAreaSeries<PointData, DateTime>>[
                              RangeAreaSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                highValueMapper: (PointData point, _) =>
                                    point.activitiesCount,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 241, 39, 39),
                                    Color.fromARGB(37, 255, 255, 3)
                                  ],
                                ),
                                borderColor: Colors.orange,
                                borderWidth: 0.2,
                                lowValueMapper: (PointData point, _) => 0,
                              ),
                              RangeAreaSeries<PointData, DateTime>(
                                dataSource: _dateWiseData,
                                xValueMapper: (PointData point, _) =>
                                    DateTime.parse(point.date),
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.green, fontSize: 12),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(196, 255, 234, 3),
                                    Color.fromARGB(64, 143, 241, 39),
                                  ],
                                ),
                                borderColor: Colors.yellow,
                                borderWidth: 0.2,
                                highValueMapper: (PointData point, _) =>
                                    point.points,
                                lowValueMapper: (PointData point, _) => 0,
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
