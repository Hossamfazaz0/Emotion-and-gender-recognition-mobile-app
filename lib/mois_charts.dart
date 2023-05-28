import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class mois_charts extends StatefulWidget {
  const mois_charts({Key? key}) : super(key: key);

  @override
  State<mois_charts> createState() => _mois_chartsState();
}

class _mois_chartsState extends State<mois_charts> {
  @override
  Widget build(BuildContext context) {
    return Container(

        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login.png'), fit: BoxFit.cover)
        ),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: ImageIcon(
                AssetImage('assets/logo.png'),
                size: 60,

              ),
            ),
            backgroundColor: Colors.transparent,
            body:  SingleChildScrollView(
              child:Column(children: [Container(

                padding: const EdgeInsets.only(left: 35, top: 30, right: 35),
                child: const Text('Mois',
                    style: TextStyle(color: Colors.white, fontSize: 50)),
              ),
                SizedBox(
                  height: 100,
                ),

                Card(
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Column(
                      children: [
                        Text('Sex',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            LineSeries<ChartData, String>(
                              dataSource: getLineData(),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
                Card(
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Column(
                      children: [
                        Text('Emontion',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            LineSeries<ChartData, String>(
                              dataSource: getLineData(),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                            ),
                          ],
                        ),
                      ]
                  ),
                )


              ]
              ),

            )
        )
    );



  }
}


class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

List<ChartData> getLineData() {
  List<ChartData> lineData = <ChartData>[
    ChartData('Jan', 25),
    ChartData('Feb', 50),
    ChartData('Mar', 75),
    ChartData('Apr', 40),
    ChartData('May', 60),
    ChartData('Jun', 35),
  ];
  return lineData;
}