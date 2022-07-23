import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../widgets/favourite_items.dart';
import '../../../widgets/customAppBar.dart';

class UserFavouritePage extends StatefulWidget {
  const UserFavouritePage({Key? key}) : super(key: key);

  @override
  State<UserFavouritePage> createState() => _UserFavouritePageState();
}

class _UserFavouritePageState extends State<UserFavouritePage> {
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final _allFavourites = FirebaseFirestore.instance.collection('favourites');
  final curUser = FirebaseAuth.instance.currentUser!;
  final searchInputController = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      appBar: //appBar
          AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.26,
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
                      margin: EdgeInsets.only(bottom: 10),
                      child: const Text(
                        'Favourites',
                        style: TextStyle(
                          color: const Color.fromRGBO(113, 219, 119, 1),
                          fontFamily: 'Gaegu-Bold',
                          fontSize: 45,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Container(
                      //   child: Text(
                      //     'What you hearted',
                      //     style: TextStyle(
                      //       color: const Color.fromRGBO(113, 219, 119, 1),
                      //       fontFamily: 'Gaegu-Bold',
                      //       fontSize: 28,
                      //     ),
                      //   ),
                      // ),
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
            );
          }),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _allFavourites
            .where('createdBy', isEqualTo: curUser.uid)
            .snapshots()
            .asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Your favourite list is empty...',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Container();
            } else {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2.5,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                children: [
                  ...snapshot.data!.docs.map((favData) {
                    //print(favData.id);
                    return favItemsList(
                      favData: favData,
                      searchQuery: query,
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
