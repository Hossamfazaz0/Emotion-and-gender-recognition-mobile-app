import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataScreen extends StatefulWidget {
  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  DateTime? selectedDate;
  int sumHeureux = 0;
  int sumColere = 0;
  int sumFeminin = 0;
  int sumMasculin = 0;
  int dataCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
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
                        String formattedDate =
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

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
                    'Sélectionner la date',
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
                _buildSummaryItem('Nombre de client', dataCount),
                SizedBox(height: 24.0),
                Text(
                  'émotions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Heureux', sumHeureux),
                    _buildSummaryItem('Colère', sumColere),
                  ],
                ),
                SizedBox(height: 24.0),
                Text(
                  'Sexe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Féminin', sumFeminin),
                    _buildSummaryItem('Masculin', sumMasculin),
                  ],
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

