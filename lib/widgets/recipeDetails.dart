import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_share/social_share.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/dom.dart' as dom;
// import 'package:html/parser.dart' as parser;

import './addUserMealPlan.dart';
import './utils.dart';

class searchDetailsPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;

  searchDetailsPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<searchDetailsPage> createState() => _searchDetailsPageState();
}

class _searchDetailsPageState extends State<searchDetailsPage> {
  final curUser = FirebaseAuth.instance.currentUser!;
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final userFavourite = FirebaseFirestore.instance.collection('favourites');
  bool _isInFavourite = false;
  bool _isSub = false;
  List ingredientsList = [];
  var url = Uri.parse('https://myfcd.moh.gov.my/myfcd97/');

  @override
  void initState() {
    super.initState();

    // check if item is already in favourite list on load
    // if it is in list then button=>color green
    userFavourite
        .where('recipeID', isEqualTo: widget.data!.id)
        .where('createdBy', isEqualTo: curUser.uid)
        .get()
        .then((item) {
      if (item.docs.isNotEmpty) {
        setState(() {
          _isInFavourite = true;
        });
      } else {
        setState(() {
          _isInFavourite = false;
        });
      }
    });

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
  }

//  void scrapWeb() async {
  // var response = await http.get(url);

  // dom.Document html = parser.parse(response.body);

  // final ingredients = html
  //     .querySelectorAll('a')
  //     .map((element) => element.innerHtml.trim())
  //     .toList();

  // print('count ${ingredients.length}');

  // for (final ingredient in ingredients) {
  //   debugPrint(ingredient);
  // }
  // }

  void _addToMealPlan(BuildContext context) {
    showModalBottomSheet(
        //isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(0),
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: addUserMealPlan(data: widget.data!),
          );
        });
  }

  void _addToFavourite() {
    userFavourite
        .where('recipeID', isEqualTo: widget.data!.id)
        .where('createdBy', isEqualTo: curUser.uid)
        .get()
        .then((fav) {
      if (fav.docs.isNotEmpty) {
        setState(() {
          _isInFavourite = false;
        });

        for (var item in fav.docs) {
          item.reference.delete();
        }

        return Utils.showSnackBar(
            'Recipe has been removed from your favourite.', Colors.red);
      } else {
        userFavourite.add({
          'recipeID': widget.data!.id,
          'createdBy': curUser.uid,
        });

        Utils.showSnackBar(
            'Recipe has been added to your favourite.', Colors.green);

        setState(() {
          _isInFavourite = true;
        });
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
    });
  }

  void _share(BuildContext context, String shareRecipeName) {
    showModalBottomSheet(
        backgroundColor: Colors.black.withOpacity(0),
        context: context,
        builder: (_) {
          return Container(
            // color: Color.fromRGBO(39, 39, 39, 1).withOpacity(0.9),
            height: MediaQuery.of(context).size.height * 0.28,
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Color.fromRGBO(39, 39, 39, 1).withOpacity(0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await SocialShare.shareTwitter(
                        shareRecipeName,
                        hashtags: [
                          "Nutritsy",
                          shareRecipeName,
                          "Recipe",
                        ],
                      );
                    },
                    child: Card(
                      elevation: 18,
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 60,
                            maxWidth: 60,
                          ),
                          child: Image.asset(
                            'assets/images/icons/twitter_icon.png',
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SocialShare.copyToClipboard(shareRecipeName).then((_) {
                        Utils.showSnackBar('Copied to clipboard', Colors.green);
                      });
                    },
                    child: Card(
                      elevation: 18,
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 60,
                          maxWidth: 60,
                        ),
                        child: Icon(
                          Icons.copy,
                          color: Color.fromRGBO(102, 102, 102, 1),
                          size: 50,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              CupertinoIcons.chevron_back,
              size: 32,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
          ),
          backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        backgroundColor: Color.fromRGBO(39, 39, 39, 1),
        color: Color.fromRGBO(113, 219, 119, 1),
        child: ListView(
          children: [
            //Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //children: [
            Container(
              //margin:
              //  EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.network(
                widget.data!.get('Thumbnail'),
                //width: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        widget.data!.get('rName'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Gaegu-Bold',
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: IconButton(
                        onPressed: () =>
                            _share(context, widget.data!.get('rName')),
                        icon: Icon(
                          CupertinoIcons.share,
                          size: 32,
                          color: Color.fromRGBO(113, 219, 119, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: IconButton(
                        onPressed: () => _addToFavourite(),
                        icon: Icon(
                          CupertinoIcons.heart_fill,
                          size: 35,
                          color: _isInFavourite
                              ? Color.fromRGBO(113, 219, 119, 1)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'Calories: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.data!.get('calories').toString() + 'cal',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto-Regular',
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'Ingredients:',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 18,
                    ),
                  ),
                ),
                ...widget.data!.get('Ingredients').map((values) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      values,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto-Regular',
                        fontSize: 16,
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'Steps:',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 18,
                    ),
                  ),
                ),
                ...widget.data!.get('Steps').map((values) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      values,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto-Regular',
                        fontSize: 16,
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'Nutritional Facts:',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FAT:' + widget.data!.get('fat').toString() + 'g',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Regular',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'PROTEIN:' +
                            widget.data!.get('protein').toString() +
                            'g',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Regular',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'CARBS:' + widget.data!.get('carb').toString() + 'g',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Regular',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isSub
                ? SizedBox()
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      height: MediaQuery.of(context).size.height * 0.085,
                      child: IconButton(
                        onPressed: () => _addToMealPlan(context),
                        color: Color.fromRGBO(113, 219, 119, 1),
                        //iconSize: 60,
                        icon: Icon(
                          CupertinoIcons.add_circled_solid,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
            // ElevatedButton(
            //   onPressed: scrapWeb,
            //   child: Text('beep'),
            // ),
          ],
        ),
      ),
    );
  }
}
