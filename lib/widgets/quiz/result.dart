import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/mainScreens/main/main_page.dart';
import '../../widgets/utils.dart';

class Result extends StatefulWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  const Result({
    Key? key,
    required this.resultScore,
    required this.resetHandler,
  }) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final curUser = FirebaseAuth.instance.currentUser!;

  final curUserDB = FirebaseFirestore.instance.collection('users');

  final suggestedMealPlan =
      FirebaseFirestore.instance.collection('suggestedMealPlan');

  var displayResultText = '';

  String get resultPhrase {
    var resultText = '';
    var formalText = '';

    var userList = [curUser.uid];
    if (widget.resultScore <= 8) {
      resultText = 'vegan';
      formalText = 'Vegan';
    } else if (widget.resultScore <= 12) {
      resultText = 'loseweight';
      formalText = 'Lose weight';
    } else if (widget.resultScore <= 16) {
      resultText = 'gainweight';
      formalText = 'Gain weight';
    } else {
      resultText = 'health';
      formalText = 'Health';
    }
    setState(() {
      displayResultText = formalText;
    });

    return resultText;
  }

  void _subToMealPlan() {
    var userList = [curUser.uid];

    curUserDB.where('id', isEqualTo: curUser.uid).get().then((userTag) {
      curUserDB.doc(curUser.uid).update({
        'tag': resultPhrase,
      });
    });

    suggestedMealPlan
        .where('subbedBy', arrayContains: curUser.uid)
        .get()
        .then((presetMPDoc) {
      if (presetMPDoc.docs.isNotEmpty) {
        //clean previous mealplan subcribed list in case user selected try again
        for (var item in presetMPDoc.docs) {
          item.reference.update({
            'subbedBy': FieldValue.arrayRemove(userList),
          }).then((_) {
            suggestedMealPlan
                .where('tag', isEqualTo: resultPhrase)
                .get()
                .then((presetMPDoc) {
              if (presetMPDoc.docs.isNotEmpty) {
                for (var item in presetMPDoc.docs) {
                  item.reference.update({
                    'subbedBy': FieldValue.arrayUnion(userList),
                  }).then((_) {
                    Utils.showSnackBar('Subscribed successfully', Colors.green);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  });
                }
              }
            });
          });
        }
      } else {
        //if user selects follow
        suggestedMealPlan
            .where('tag', isEqualTo: resultPhrase)
            .get()
            .then((presetMPDoc) {
          if (presetMPDoc.docs.isNotEmpty) {
            for (var item in presetMPDoc.docs) {
              item.reference.update({
                'subbedBy': FieldValue.arrayUnion(userList),
              }).then((_) {
                Utils.showSnackBar('Subscribed successfully', Colors.green);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              });
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            suggestedMealPlan.where('tag', isEqualTo: resultPhrase).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                //display mealplan poster
                // ...snapshot.data!.docs.map(
                //   (suggestedMP) {
                //     return Image.network(suggestedMP['thumbnail']);
                //   },
                // ),

                //margin: EdgeInsets.fromLTRB(15, 250, 15, 90),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  child: Text(
                    displayResultText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(113, 219, 119, 1),
                      fontSize: 28,
                    ),
                  ),
                ),

                Container(
                  child: Text(
                    'Not satisfied with your results?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Gaegu-Regular',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _subToMealPlan
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HomePage(),
                  //   ),
                  // );
                  ,
                  child: Text(
                    'Follow',
                    style: TextStyle(
                      color: Color.fromRGBO(27, 27, 27, 1),
                      fontSize: 24,
                      fontFamily: 'Gaegu-Bold',
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Color.fromRGBO(215, 255, 217, 1);
                      } else {
                        return Color.fromRGBO(113, 219, 119, 1);
                      }
                    }),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    )),
                  ),
                ),

                TextButton(
                  onPressed: widget.resetHandler,
                  child: Text(
                    'TRY AGAIN',
                    style: TextStyle(
                      color: Color.fromRGBO(113, 219, 119, 1),
                      fontSize: 24,
                      fontFamily: 'Gaegu-Bold',
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
