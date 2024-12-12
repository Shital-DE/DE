import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<MachinewiseenergyData> machinewiseenergyData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        SizedBox(
            height: 350,
            width: 350,
            child: SfCircularChart(
              title: const ChartTitle(
                  text: 'Machine Wise Energy Consumption',
                  borderWidth: 2,
                  // Aligns the chart title to left
                  alignment: ChartAlignment.center,
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Times',
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                  )),
              series: <CircularSeries>[
                DoughnutSeries<MachinewiseenergyData, String>(
                    dataSource: machinewiseenergyData,
                    xValueMapper: (MachinewiseenergyData data, _) =>
                        data.x.trim(),
                    yValueMapper: (MachinewiseenergyData data, _) =>
                        double.parse(data.y.toString()),
                    explode: true,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true)),
                RadialBarSeries<MachinewiseenergyData, String>(
                    dataSource: machinewiseenergyData,
                    xValueMapper: (MachinewiseenergyData data, _) => data.x,
                    yValueMapper: (MachinewiseenergyData data, _) => data.y)
              ],
              legend: const Legend(
                  isVisible: true,
                  // Overflowing legend content will be wraped
                  // overflowMode: LegendItemOverflowMode.scroll
                  position: LegendPosition.bottom),
            ))
      ]),
    );
  }
}

class MachinewiseenergyData {
  String x;
  double y;
  MachinewiseenergyData(this.x, this.y);
}
