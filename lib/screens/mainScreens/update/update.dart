import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nu_trit_sy/widgets/groceryList.dart';

import '../../../widgets/glassmorphism.dart';
import '../../../widgets/quiz/quizPage.dart';

class UserUpdate extends StatefulWidget {
  const UserUpdate({Key? key}) : super(key: key);

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final suggestedMP =
      FirebaseFirestore.instance.collection('suggestedMealPlan');
  final curUser = FirebaseAuth.instance.currentUser!;
  bool _isSub = false;
  String currentPlan = '';
  List tags = [];
  var tag = '';

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
        _getData();
      } else {
        setState(() {
          _isSub = false;
        });
      }
    });
  }

  Future<void> _getData() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((doc) {
      if (doc["id"] == curUser.uid) {
        setState(() {
          tag = doc['tag'];
        });
        // print(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: Center(
        child: Stack(
          children: [
            GlassMorphism(
              blur: 5,
              opacity: 0.0,
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.12),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.all(10),
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'View Progress',
                    //       style: TextStyle(
                    //         fontFamily: 'Gaegu-Bold',
                    //         fontSize: 32,
                    //         color: Colors.white,
                    //         letterSpacing: -1,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Grocery_List()),
                          );
                        },
                        child: Text(
                          'Grocery basket',
                          style: TextStyle(
                            fontFamily: 'Gaegu-Bold',
                            fontSize: 32,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ),
                    _isSub
                        ? Container(
                            margin: EdgeInsets.all(10),
                            child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      backgroundColor:
                                          Color.fromRGBO(39, 39, 39, 1),
                                      title: Text(
                                        'Are you sure you want to unfollow?',
                                        //textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto-Bold',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'No');
                                            },
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontFamily: 'Roboto-Regular',
                                                color: Colors.white,
                                              ),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              var users = [curUser.uid];
                                              curUserDB
                                                  .doc(curUser.uid)
                                                  .update({
                                                'tag': '',
                                              });

                                              suggestedMP
                                                  .where('subbedBy',
                                                      arrayContains:
                                                          curUser.uid)
                                                  .get()
                                                  .then((foundMp) {
                                                for (var items
                                                    in foundMp.docs) {
                                                  items.reference.update({
                                                    'subbedBy':
                                                        FieldValue.arrayRemove(
                                                            users),
                                                  });
                                                }
                                              });

                                              setState(() {
                                                _isSub = false;
                                              });
                                              Navigator.pop(context, 'Yes');
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
                                child: Text(
                                  'Unfollow meal plan: ' + tag,
                                  style: TextStyle(
                                    fontFamily: 'Gaegu-Bold',
                                    fontSize: 32,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                )),
                          )
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => quizPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Follow meal plan',
                                  style: TextStyle(
                                    fontFamily: 'Gaegu-Bold',
                                    fontSize: 32,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
