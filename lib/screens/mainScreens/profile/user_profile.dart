import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_share/social_share.dart';

import '../../subScreens/profile/aboutus.dart';
import '../../subScreens/profile/forgotPw.dart';
import '../../../widgets/utils.dart';
import '../../subScreens/profile/user_details.dart';
import '../../../widgets/customAppBar.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final curUser = FirebaseAuth.instance.currentUser!;
  var name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curUser.reload();
    _getData();
  }

  Future<void> _getData() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((doc) {
      if (doc["id"] == curUser.uid) {
        setState(() {
          name = doc['name'];
        });
      }
    });
  }

  void _share(BuildContext context) {
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
                          "Plan your meal anywhere, anytime with Nutritsy",
                          hashtags: [
                            "Nutritsy",
                            "MealPlan",
                            "Recipe",
                          ]);
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
                      SocialShare.copyToClipboard(
                              'Nutritsy - Plan your meal anywhere, anytime! ')
                          .then((_) {
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
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.3,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: CustomShape(),
          child: Container(
            color: Color.fromRGBO(39, 39, 39, 1),
            height: 225,
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
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(226, 220, 205, 1),
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://www.woolha.com/media/2020/03/eevee.png'),
                      //minRadius: 45,
                      /*child: Icon(
                        CupertinoIcons.person_alt_circle,
                        size: 45,
                        color: Colors.white,
                      ),*/
                    ),
                    title: Container(
                      /*padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04),*/
                      child: Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Gaegu-Bold',
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    trailing: Container(
                      //margin: EdgeInsets.only(top: 30),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailsPage(),
                            ),
                            //(_) => false,
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.chevron_right,
                          size: 36,
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(39, 39, 39, 1),
                    border: Border.all(
                      color: Color.fromRGBO(39, 39, 39, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(28),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.pencil_ellipsis_rectangle,
                      size: 35,
                      color: Color.fromRGBO(113, 219, 119, 1),
                    ),
                    title: Text(
                      'Reset password',
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                          //(_) => false,
                        );
                      },
                      //margin: EdgeInsets.only(top: 30),
                      icon: Icon(
                        CupertinoIcons.chevron_right,
                        size: 28,
                        color: Color.fromRGBO(102, 102, 102, 1),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(39, 39, 39, 1),
                    border: Border.all(
                      color: Color.fromRGBO(39, 39, 39, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(28),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.info_circle_fill,
                      size: 35,
                      color: Color.fromRGBO(113, 219, 119, 1),
                    ),
                    title: Text(
                      'About Nutritsy',
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => About_Us(),
                          ),
                          //(_) => false,
                        );
                      },
                      //margin: EdgeInsets.only(top: 30),
                      icon: Icon(
                        CupertinoIcons.chevron_right,
                        size: 28,
                        color: Color.fromRGBO(102, 102, 102, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    color: Color.fromRGBO(39, 39, 39, 1),
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Tell your friends about Nutritsy !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto-Bold',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 51,
                        child: ElevatedButton(
                          onPressed: () => _share(context),
                          child: Text(
                            'SHARE',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff272727),
                              fontFamily: 'Gaegu-Bold',
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> States) {
                              if (States.contains(MaterialState.pressed)) {
                                return Color.fromRGBO(215, 255, 217, 1);
                              } else {
                                return Color.fromRGBO(113, 219, 119, 1);
                              }
                            }),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            )),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
