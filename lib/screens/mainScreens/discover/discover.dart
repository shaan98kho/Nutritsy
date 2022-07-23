import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/customAppBar.dart';
import '../../../widgets/recipeDetails.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final _allRecipes = FirebaseFirestore.instance.collection('recipes');
  final searchInputController = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.26,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: CustomShape(),
          child: Container(
            color: Color.fromRGBO(39, 39, 39, 1),
            height: 250,
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
                      'Discover',
                      style: TextStyle(
                        color: const Color.fromRGBO(113, 219, 119, 1),
                        fontFamily: 'Gaegu-Bold',
                        fontSize: 45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 339,
                      maxHeight: 42,
                    ),
                    child: TextFormField(
                        controller: searchInputController,
                        style: TextStyle(
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto-Bold',
                            fontSize: 16,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              searchInputController.clear();
                              setState(() {
                                query = '';
                              });
                            },
                            child: Icon(
                              CupertinoIcons.clear_thick_circled,
                              color: Color.fromRGBO(102, 102, 102, 1),
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(27, 27, 27, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          //focusedBorder: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              //borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            query = val;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _allRecipes.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['rName']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    element['tag']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return Center(
                child: Text(
                  'No such recipe found...',
                  style: TextStyle(
                    fontFamily: 'Gaegu-Regular',
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              );
            } else {
              //fetch data here
              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['rName']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()) ||
                          element['tag']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .map((QueryDocumentSnapshot<Object?> data) {
                    final String rName = data['rName'];
                    final String rThumbnail = data['Thumbnail'];

                    //display fetched data here
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(23, 5, 10, 10),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => searchDetailsPage(
                                data: data,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          rName,
                          style: TextStyle(
                            fontFamily: 'Gaegu-Regular',
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(rThumbnail),
                        ),
                      ),
                    );
                  })
                ],
              );
            }
          }
        },
      ),
    );
  }
}
