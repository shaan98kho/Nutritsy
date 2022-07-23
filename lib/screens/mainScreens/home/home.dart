import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nu_trit_sy/widgets/utils.dart';

import '../../../widgets/presetMealPlans.dart';
import '../../../widgets/mealPlanList.dart';
import '../../../widgets/customAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final curUser = FirebaseAuth.instance.currentUser!;
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final mealPlan = FirebaseFirestore.instance.collection('userMealPlan');
  final suggestedMealPlan =
      FirebaseFirestore.instance.collection('suggestedMealPlan');
  DateTime _displayDate = DateTime.now();
  bool _isSub = true;
  int currentIndex = 0;
  String yesterday =
      DateFormat('y-MM-d').format(DateTime.now().subtract(Duration(days: 1)));

  bool _isToday = true;

  @override
  void initState() {
    super.initState();
    curUserDB
        .where('id', isEqualTo: curUser.uid)
        .where('tag', isEqualTo: "")
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
    //delete yesterday's mealplan
    mealPlan.where('date', isEqualTo: yesterday).get().then((items) {
      if (items.docs.isNotEmpty) {
        for (var item in items.docs) {
          item.reference.delete();
        }
      } else {
        return;
      }
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
      _displayDate = DateTime.now();
      _isToday = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      appBar: //appBar
          AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.260,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: CustomShape(),
          child: LayoutBuilder(builder: (context, constrains) {
            return Container(
              color: Color.fromRGBO(39, 39, 39, 1),
              height: constrains.maxHeight,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 35),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        'Nutritsy',
                        style: TextStyle(
                          color: const Color.fromRGBO(113, 219, 119, 1),
                          fontFamily: 'Gaegu-Bold',
                          fontSize: 45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              if (_displayDate.isAfter(DateTime.now())) {
                                setState(() {
                                  _displayDate =
                                      _displayDate.subtract(Duration(days: 1));
                                });
                              }
                              if (DateFormat.yMMMd().format(_displayDate) ==
                                  DateFormat.yMMMd().format(DateTime.now())) {
                                setState(() {
                                  _isToday = true;
                                });
                                return;
                              } else {
                                return;
                              }
                            },
                            icon: _isToday
                                ? Icon(null)
                                : Icon(
                                    CupertinoIcons.chevron_left,
                                    size: 32,
                                    color: Color.fromRGBO(102, 102, 102, 1),
                                  ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          //padding: EdgeInsets.only(top: 5),
                          height: 80,
                          child: Column(children: [
                            Text(
                              DateFormat.yMMMd().format(_displayDate),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Gaegu-Regular',
                                fontSize: 16,
                                color: Color.fromRGBO(215, 255, 217, 1),
                              ),
                            ),
                            Text(
                              DateFormat('EEEE').format(_displayDate),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Gaegu-Regular',
                                fontSize: 30,
                                color: Color.fromRGBO(215, 255, 217, 1),
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isToday = false;
                                if (_displayDate == DateTime.now()) {
                                  _displayDate =
                                      DateTime.now().add(Duration(days: 1));
                                } else {
                                  _displayDate =
                                      _displayDate.add(Duration(days: 1));
                                }
                              });
                            },
                            icon: Icon(
                              CupertinoIcons.chevron_right,
                              size: 32,
                              color: Color.fromRGBO(102, 102, 102, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      body: RefreshIndicator(
          backgroundColor: Color.fromRGBO(39, 39, 39, 1),
          color: Color.fromRGBO(113, 219, 119, 1),
          onRefresh: pullRefresh,
          child: StreamBuilder(
            stream: _isSub
                ? suggestedMealPlan
                    .where('subbedBy', arrayContains: curUser.uid)
                    .snapshots()
                : mealPlan
                    .where('createdBy', isEqualTo: curUser.uid)
                    .where('date',
                        isEqualTo: DateFormat('y-MM-d').format(_displayDate))
                    .snapshots(),
            builder: _isSub
                ? (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView(children: [
                        ...snapshot.data!.docs.map((e) {
                          return presetMealPlans(
                            pathName: e['tag'],
                            presetDay: _displayDate,
                          );
                        }),
                      ]);
                      // }
                    }
                  }
                : (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'There is no meal planned \nfor ' +
                                DateFormat.yMMMd().format(_displayDate) +
                                ' yet...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Gaegu-Regular',
                              fontSize: 20,
                              color: Color.fromRGBO(102, 102, 102, 1),
                            ),
                          ),
                        );
                      } else {
                        return ListView(
                          children: [
                            ...snapshot.data!.docs.map((recipePlans) {
                              List recipeItems =
                                  recipePlans['recipeID'] as List;

                              if (recipeItems.isEmpty) {
                                return Container();
                              } else {
                                return mealPlanList(
                                  mpRecipeID: recipeItems,
                                  planDate: _displayDate,
                                );
                              }
                            })
                          ],
                        );
                      }
                    }
                  },
          )),
    );
  }
}
