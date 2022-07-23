import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../widgets/utils.dart';
import '../../../widgets/customAppBar.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final userProfile = FirebaseFirestore.instance.collection('users');
  final curUser = FirebaseAuth.instance.currentUser!;
  final newUsernameController = TextEditingController();
  final newEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var name = '';
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curUser.reload();
    _getData();
  }

  Future signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    newEmailController.dispose();
    newUsernameController.dispose();

    super.dispose();
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

  Future updateProfile() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      curUser.updateEmail(newEmailController.text.trim());
      curUser.updateDisplayName(newUsernameController.text.trim());

      userProfile.doc(curUser.uid).update({
        'name': newUsernameController.text,
        'email': newEmailController.text,
      }).then((_) {
        Utils.showSnackBar('Updated successfully', Colors.green);
      });

      curUser.reload();
    } on FirebaseAuthException catch (e) {
      return Utils.showSnackBar(e.message, Colors.red);
    }
  }

  Widget nonEditableTextformfields() {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
          radius: 80,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 280,
            maxHeight: 49,
          ),
          child: TextFormField(
            readOnly: true,
            style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            decoration: InputDecoration(
              //focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              hintText: name,
              hintStyle: TextStyle(
                fontFamily: 'Roboto-Bold',
                fontSize: 16,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              labelStyle: TextStyle(
                fontFamily: 'Roboto-Bold',
                fontSize: 15,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              filled: true,
              fillColor: Color.fromRGBO(39, 39, 39, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 280,
            maxHeight: 49,
          ),
          child: TextFormField(
            readOnly: true,
            style: TextStyle(
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              hintText: curUser.email,
              hintStyle: TextStyle(
                fontFamily: 'Roboto-Bold',
                fontSize: 16,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              labelStyle: TextStyle(
                fontFamily: 'Roboto-Bold',
                fontSize: 15,
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              filled: true,
              fillColor: Color.fromRGBO(39, 39, 39, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Container(
          width: 200,
          height: MediaQuery.of(context).size.height * 0.075,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isEdit = true;
              });
            },
            child: Text(
              'Edit profile',
              style: TextStyle(
                fontSize: 32,
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
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              )),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 300),
          height: MediaQuery.of(context).size.height * 0.075,
          child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Color.fromRGBO(39, 39, 39, 1),
                  title: Text(
                    'Confirm logout?',
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
                          Navigator.pop(context, 'Yes');
                          signOut();
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
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(113, 219, 119, 1),
                  fontFamily: 'Gaegu-Bold',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget editableTextformfield() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 280,
              maxHeight: MediaQuery.of(context).size.height * 0.25,
            ),
            child: TextFormField(
              controller: newUsernameController,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                labelText: 'New username',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 15,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                filled: true,
                fillColor: Color.fromRGBO(39, 39, 39, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) => value!.isEmpty
                  ? 'This field must not be empty'
                  : RegExp(r'[!#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value)
                      ? 'Enter a valid name'
                      : null,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 280,
              maxHeight: MediaQuery.of(context).size.height * 0.25,
            ),
            child: TextFormField(
              controller: newEmailController,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                color: Color.fromRGBO(102, 102, 102, 1),
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                labelText: 'New email address',
                labelStyle: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 15,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                filled: true,
                fillColor: Color.fromRGBO(39, 39, 39, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email) ||
                          email == null
                      ? 'Enter a valid email'
                      : null,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
            width: 200,
            height: MediaQuery.of(context).size.height * 0.075,
            child: ElevatedButton(
              onPressed: () => updateProfile(),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 32,
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
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                )),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            //padding: EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.075,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isEdit = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(113, 219, 119, 1),
                    fontFamily: 'Gaegu-Bold',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: //appBar
          AppBar(
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
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: const Color.fromRGBO(113, 219, 119, 1),
                          fontFamily: 'Gaegu-Bold',
                          fontSize: 45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      body: SingleChildScrollView(
        child: Center(
          child: isEdit ? editableTextformfield() : nonEditableTextformfields(),
        ),
      ),
    );
  }
}
