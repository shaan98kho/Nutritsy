import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../screens/mainScreens/update/update.dart';
import '../../../widgets/tab_navigator.dart';
import '../../../enums/bottom_nav_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomNavItem selectedItem = BottomNavItem.one;
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final curUser = FirebaseAuth.instance.currentUser!;
  bool isSub = false;

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.one: GlobalKey<NavigatorState>(),
    BottomNavItem.two: GlobalKey<NavigatorState>(),
    //BottomNavItem.three: GlobalKey<NavigatorState>(),
    BottomNavItem.three: GlobalKey<NavigatorState>(),
    BottomNavItem.four: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.one: CupertinoIcons.house_alt_fill,
    BottomNavItem.two: CupertinoIcons.search,
    //BottomNavItem.three: CupertinoIcons.dot_square,
    BottomNavItem.three: CupertinoIcons.heart_fill,
    BottomNavItem.four: CupertinoIcons.person_crop_square_fill,
  };
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   curUserDB
  //       .where('id', isEqualTo: curUser.uid)
  //       .where('tag', isEqualTo: '')
  //       .get()
  //       .then((result) {
  //     if (result.docs.isEmpty) {
  //       setState(() {
  //         isSub = true;
  //       });
  //     } else {
  //       setState(() {
  //         isSub = false;
  //       });
  //     }
  //   });
  // }

  void _updateDetails(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(0),
        context: context,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            child: GestureDetector(
              onTap: () {},
              child: UserUpdate(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //to prevent the floatingactionbutton from moving when keyboard is summoned
      body: WillPopScope(
        onWillPop: () async {
          navigatorKeys[selectedItem]
              ?.currentState
              ?.popUntil((route) => route.isFirst);

          return false;
        },
        child: Stack(children: [
          ...items
              .map(
                (item, _) => MapEntry(
                  item,
                  _buildOffstageNavigator(item, item == selectedItem),
                ),
              )
              .values
              .toList(),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.09),
        child: FloatingActionButton(
          backgroundColor: Color.fromRGBO(113, 219, 119, 1),
          onPressed: () => _updateDetails(context),
          child: Icon(
            Icons.add,
            color: Colors.white,
            //size: 32,
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 68,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromRGBO(39, 39, 39, 1),
          selectedItemColor: Color.fromRGBO(113, 219, 119, 1),
          unselectedItemColor: Color.fromRGBO(102, 102, 102, 1),
          currentIndex: BottomNavItem.values.indexOf(selectedItem),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          /*selectedLabelStyle: const TextStyle(
            fontFamily: 'Gaegu-Bold',
            fontSize: 1,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Gaegu-Bold',
            fontSize: 1,
          ),*/
          onTap: (index) {
            final currentSelectedItem = BottomNavItem.values[index];
            if (selectedItem == currentSelectedItem) {
              navigatorKeys[selectedItem]
                  ?.currentState
                  ?.popUntil((route) => route.isFirst);
            }
            setState(() {
              selectedItem = currentSelectedItem;
            });
          },
          items: items
              .map((item, icon) => MapEntry(
                    item.toString(),
                    BottomNavigationBarItem(
                      label: '',
                      icon: Icon(
                        icon,
                        size: 30.0,
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
