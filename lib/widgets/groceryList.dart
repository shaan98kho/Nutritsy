import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nu_trit_sy/widgets/addGrocery.dart';
import 'package:nu_trit_sy/widgets/glassmorphism.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nu_trit_sy/widgets/utils.dart';

import '../../../widgets/customAppBar.dart';

class Grocery_List extends StatefulWidget {
  const Grocery_List({Key? key}) : super(key: key);

  @override
  State<Grocery_List> createState() => _Grocery_ListState();
}

class _Grocery_ListState extends State<Grocery_List> {
  final _allGroceries = FirebaseFirestore.instance.collection('UserGroceries');
  final curUser = FirebaseAuth.instance.currentUser!;

  void _addGrocery(BuildContext context) {
    showModalBottomSheet(
        //isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(0),
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: GlassMorphism(
              opacity: 0,
              blur: 10,
              child: add_Grocery(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.05),
          //top: 40,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              CupertinoIcons.chevron_back,
              size: 32,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
          ),
        ),
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
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: const Text(
                    'Groceries',
                    style: TextStyle(
                      color: const Color.fromRGBO(113, 219, 119, 1),
                      fontFamily: 'Gaegu-Bold',
                      fontSize: 42,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            IconButton(
              onPressed: () => _addGrocery(context),
              icon: Icon(CupertinoIcons.add_circled_solid),
              color: const Color.fromRGBO(113, 219, 119, 1),
              iconSize: 42,
            ),
            StreamBuilder(
              stream: _allGroceries
                  .where('createdBy', isEqualTo: curUser.uid)
                  .snapshots()
                  .asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      children: [
                        ...snapshot.data!.docs.map((userGroceries) {
                          List grocs = snapshot.data!.docs as List;
                          List<Widget> grocItemWidgets = [];

                          for (var items in userGroceries['groceries']) {
                            Widget itemTile = ListTile(
                              title: Text(
                                items,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Gaegu-Regular',
                                  fontSize: 24,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  _allGroceries
                                      .where('createdBy',
                                          isEqualTo: curUser.uid)
                                      .get()
                                      .then((grocItems) {
                                    if (grocItems.docs.isNotEmpty) {
                                      List del = [items];
                                      _allGroceries.doc(curUser.uid).update({
                                        'groceries':
                                            FieldValue.arrayRemove(del),
                                      });
                                      Utils.showSnackBar(
                                          'Successfully deleted!', Colors.red);
                                    } else {
                                      return;
                                    }
                                  });
                                },
                                icon: Icon(CupertinoIcons.trash),
                                color: Colors.red,
                              ),
                            );
                            grocItemWidgets.add(itemTile);
                          }

                          return Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: ListView(
                              children: [...grocItemWidgets],
                            ),
                          );
                        })
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
