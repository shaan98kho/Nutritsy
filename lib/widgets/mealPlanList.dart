import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../widgets/recipeDetails.dart';

class mealPlanList extends StatefulWidget {
  final List mpRecipeID;
  DateTime planDate;
  mealPlanList({
    Key? key,
    required this.mpRecipeID,
    required this.planDate,
  }) : super(key: key);

  @override
  State<mealPlanList> createState() => _mealPlanListState();
}

class _mealPlanListState extends State<mealPlanList> {
  final curUser = FirebaseAuth.instance.currentUser!;
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final _allRecipes = FirebaseFirestore.instance.collection('recipes');
  final mealPlan = FirebaseFirestore.instance.collection('userMealPlan');
  bool _isSub = false;
  List allRecipeCal = [];
  String thing = '';

  @override
  void initState() {
    super.initState();
    curUserDB
        .where('id', isEqualTo: curUser.uid)
        .where('tag', isEqualTo: '')
        .get()
        .then((result) {
      if (result.docs.isEmpty) {
        setState(() {
          _isSub = true;
        });
      } else {
        setState(() {
          _isSub = false;
        });
      }
    });

    setState(() {
      allRecipeCal.clear();
    });
    getcaloriesList;
  }

  get getcaloriesList async {
    for (var item in widget.mpRecipeID) {
      await _allRecipes.doc(item).get().then((doc) {
        Map<String, dynamic>? data = doc.data();

        setState(() {
          allRecipeCal.add(data?['calories']);
        });
      });
    }

    return allRecipeCal;
  }

  double get totalRecipeCal {
    return allRecipeCal.fold(0, (sum, element) {
      return sum + element;
    });
  }

  Future<void> pullRefresh() async {
    curUserDB
        .where('id', isEqualTo: curUser.uid)
        .where('tag', isEqualTo: '')
        .get()
        .then((result) {
      if (result.docs.isEmpty) {
        setState(() {
          _isSub = true;
        });
      } else {
        setState(() {
          _isSub = false;
        });
      }
    });
    setState(() {
      allRecipeCal.clear();
    });

    getcaloriesList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _allRecipes
            .where('recipeID', whereIn: widget.mpRecipeID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Container();
            } else {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Today\'s calorie intake: ' +
                          totalRecipeCal.toStringAsFixed(0) +
                          'cal',
                      style: TextStyle(
                        fontFamily: 'Gaegu-Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.58,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: RefreshIndicator(
                      backgroundColor: Color.fromRGBO(39, 39, 39, 1),
                      color: Color.fromRGBO(113, 219, 119, 1),
                      onRefresh: pullRefresh,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2.5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 20,
                        children: [
                          ...snapshot.data!.docs.map((mpRecipeData) {
                            return Column(children: [
                              GestureDetector(
                                onLongPress: () {
                                  _isSub
                                      ? null
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            backgroundColor:
                                                Color.fromRGBO(39, 39, 39, 1),
                                            title: Text(
                                              'Confirm delete?',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Roboto-Bold',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, 'No');
                                                  },
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    //delete the selected recipe from an existing plan
                                                    mealPlan
                                                        .where('createdBy',
                                                            isEqualTo:
                                                                curUser.uid)
                                                        .where('date',
                                                            isEqualTo: DateFormat(
                                                                    'y-MM-d')
                                                                .format(widget
                                                                    .planDate))
                                                        .where('recipeID',
                                                            arrayContains:
                                                                mpRecipeData[
                                                                    'recipeID'])
                                                        .get()
                                                        .then((item) {
                                                      var recipeList = [
                                                        mpRecipeData['recipeID']
                                                      ];

                                                      mealPlan
                                                          .doc(DateFormat(
                                                                      'y-MM-d')
                                                                  .format(widget
                                                                      .planDate) +
                                                              curUser.uid)
                                                          .update({
                                                        'recipeID': FieldValue
                                                            .arrayRemove(
                                                                recipeList)
                                                      });

                                                      //delete the doc if there is no recipe in the mealplan
                                                      mealPlan
                                                          .where('createdBy',
                                                              isEqualTo:
                                                                  curUser.uid)
                                                          .where('date',
                                                              isEqualTo: DateFormat(
                                                                      'y-MM-d')
                                                                  .format(widget
                                                                      .planDate))
                                                          .where('recipeID',
                                                              isEqualTo: [])
                                                          .get()
                                                          .then((emptyPlans) {
                                                            for (var emptyPlan
                                                                in emptyPlans
                                                                    .docs) {
                                                              emptyPlan
                                                                  .reference
                                                                  .delete();
                                                            }
                                                          });
                                                    });
                                                    Navigator.pop(
                                                        context, 'Yes');
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto-Bold',
                                                      color: Colors.red,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        );
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => searchDetailsPage(
                                        data: mpRecipeData,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: 'zoom',
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    width: 150,
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Image.network(
                                        mpRecipeData['Thumbnail'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  mpRecipeData['rName'],
                                  style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]);
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        });
  }
}
