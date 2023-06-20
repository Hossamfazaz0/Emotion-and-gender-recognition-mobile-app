import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyChartScreen extends StatefulWidget {
  @override
  _MyChartScreenState createState() => _MyChartScreenState();
}

class EmotionData {
  final String emotion;
  final int count;

  EmotionData(this.emotion, this.count);
}

class _MyChartScreenState extends State<MyChartScreen> {
  DateTime? selectedDate;
  DateTime? selectedMonth;
  int sumHeureux = 0;
  int sumColere = 0;
  int sumFeminin = 0;
  int sumMasculin = 0;
  int dataCount = 0;
  List<EmotionData> emotionData = [];
  bool isDaySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphe'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: isDaySelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isDaySelected = value!;
                            });
                          },
                        ),
                        Text('Jour'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: isDaySelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isDaySelected = value!;
                            });
                          },
                        ),
                        Text('Mois'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                if (isDaySelected)
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      ).then((date) {
                        setState(() {
                          selectedDate = date;
                        });

                        if (date != null) {
                          String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

                          FirebaseFirestore.instance
                              .collection('data')
                              .where('Date', isEqualTo: formattedDate)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            if (querySnapshot.docs.isNotEmpty) {
                              setState(() {
                                sumHeureux = 0;
                                sumColere = 0;
                                sumFeminin = 0;
                                sumMasculin = 0;
                                dataCount = querySnapshot.size;
                              });

                              querySnapshot.docs.forEach((DocumentSnapshot document) {
                                Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                                String? emotion = data?['Emotion'] as String?;
                                String? gender = data?['Gender'] as String?;

                                if (emotion == '0 Heureux') {
                                  setState(() {
                                    sumHeureux += 1;
                                  });
                                } else if (emotion == '2 Colere') {
                                  setState(() {
                                    sumColere += 1;
                                  });
                                }

                                if (gender == '0 Feminin') {
                                  setState(() {
                                    sumFeminin += 1;
                                  });
                                } else if (gender == '1 Masculin') {
                                  setState(() {
                                    sumMasculin += 1;
                                  });
                                }
                              });

                              setState(() {
                                emotionData = [
                                  EmotionData('Heureux', sumHeureux),
                                  EmotionData('Colère', sumColere),
                                  EmotionData('Féminin', sumFeminin),
                                  EmotionData('Masculin', sumMasculin),
                                ];
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Aucune data disponible'),
                                    content: Text('Aucune donnée disponible pour la date sélectionnée'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              setState(() {
                                sumHeureux = 0;
                                sumColere = 0;
                                sumFeminin = 0;
                                sumMasculin = 0;
                                dataCount = 0;
                                emotionData = [];
                              });
                              print('Aucune donnée disponible pour la date sélectionnée');
                            }
                          }).catchError((error) {
                            print('Erreur lors de la récupération des données : $error');
                          });
                        }
                      });
                    },
                    child: Text(
                      'Sélectionner le jour',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                if (!isDaySelected)
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDatePickerMode: DatePickerMode.year,
                      ).then((date) {
                        setState(() {
                          selectedMonth = date;
                        });

                        if (date != null) {
                          String formattedMonth = '${date.year}-${date.month.toString().padLeft(2, '0')}';

                          String nextMonth = getNextMonth(formattedMonth);

                          FirebaseFirestore.instance
                              .collection('data')
                              .where('Date', isGreaterThanOrEqualTo: formattedMonth, isLessThan: nextMonth)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            if (querySnapshot.docs.isNotEmpty) {
                              setState(() {
                                sumHeureux = 0;
                                sumColere = 0;
                                sumFeminin = 0;
                                sumMasculin = 0;
                                dataCount = querySnapshot.size;
                              });

                              querySnapshot.docs.forEach((DocumentSnapshot document) {
                                Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                                String? emotion = data?['Emotion'] as String?;
                                String? gender = data?['Gender'] as String?;

                                if (emotion == '0 Heureux') {
                                  setState(() {
                                    sumHeureux += 1;
                                  });
                                } else if (emotion == '2 Colere') {
                                  setState(() {
                                    sumColere += 1;
                                  });
                                }

                                if (gender == '0 Feminin') {
                                  setState(() {
                                    sumFeminin += 1;
                                  });
                                } else if (gender == '1 Masculin') {
                                  setState(() {
                                    sumMasculin += 1;
                                  });
                                }
                              });

                              setState(() {
                                emotionData = [
                                  EmotionData('Heureux', sumHeureux),
                                  EmotionData('Colère', sumColere),
                                  EmotionData('Féminin', sumFeminin),
                                  EmotionData('Masculin', sumMasculin),
                                ];
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Aucune data disponible'),
                                    content: Text('Aucune donnée disponible pour le mois sélectionné'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              setState(() {
                                sumHeureux = 0;
                                sumColere = 0;
                                sumFeminin = 0;
                                sumMasculin = 0;
                                dataCount = 0;
                                emotionData = [];
                              });
                              print('Aucune donnée disponible pour le mois sélectionné');
                            }
                          }).catchError((error) {
                            print('Erreur lors de la récupération des données : $error');
                          });
                        }
                      });
                    },
                    child: Text(
                      'Sélectionner le mois',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                SizedBox(height: 24.0),

                Card(
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(

                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        ColumnSeries<EmotionData, String>(
                          dataSource: emotionData,
                          xValueMapper: (EmotionData data, _) => data.emotion,
                          yValueMapper: (EmotionData data, _) => data.count,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.0),


                Card(
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(

                    child: SfCircularChart(
                      series: <CircularSeries>[
                        PieSeries<EmotionData, String>(
                          dataSource: emotionData,
                          xValueMapper: (EmotionData data, _) => data.emotion,
                          yValueMapper: (EmotionData data, _) => data.count,
                          dataLabelMapper: (EmotionData data, _) => '${data.emotion} ${(data.count / dataCount * 100).toStringAsFixed(2)}%',
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String getNextMonth(String currentMonth) {
    int year = int.parse(currentMonth.split('-')[0]);
    int month = int.parse(currentMonth.split('-')[1]);

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    return '${year.toString()}-${month.toString().padLeft(2, '0')}';
  }
}


