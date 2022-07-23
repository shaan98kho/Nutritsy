import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/recipeDetails.dart';

class favItemsList extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? favData;
  final String searchQuery;

  const favItemsList({
    Key? key,
    required this.favData,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<favItemsList> createState() => _favItemsListState();
}

class _favItemsListState extends State<favItemsList> {
  final _allRecipes = FirebaseFirestore.instance.collection('recipes');
  Map allFavItemsData = {};
  // String query = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _allRecipes
            .where('recipeID', isEqualTo: widget.favData!['recipeID'])
            .snapshots()
            .asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['rName']
                              .toString()
                              .toLowerCase()
                              .contains(widget.searchQuery.toLowerCase()) ||
                          element['tag']
                              .toString()
                              .toLowerCase()
                              .contains(widget.searchQuery.toLowerCase()))
                      .map(
                    (favRData) {
                      return Column(children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => searchDetailsPage(
                                  data: favRData,
                                ),
                              ),
                            );
                          },
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
                                favRData['Thumbnail'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          favRData['rName'],
                          style: TextStyle(
                            fontFamily: 'Roboto-Regular',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ]);
                    },
                  )
                ],
              ),
            );
            /*List favItems = snapshot.data?.docs as List;
            List<Widget> favItemsWidgets = [];

            for (var favItem in favItems) {
              Widget favRecipeTile = Card(
                color: Color.fromRGBO(27, 27, 27, 1),
                margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        snapshot.data!.docs.map((rData) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => searchDetailsPage(
                                data: rData,
                              ),
                            ),
                          );
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: 150,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.network(
                            favItem['Thumbnail'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      favItem['rName'],
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );

              favItemsWidgets.add(favRecipeTile);
            }
            return Column(
              children: favItemsWidgets,
            );*/
          } else {
            return Text(
              'You don\'t have any favourite recipes yet...',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          }
        });
  }
}
