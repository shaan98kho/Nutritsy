import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/utils.dart';

class add_Grocery extends StatefulWidget {
  const add_Grocery({Key? key}) : super(key: key);

  @override
  State<add_Grocery> createState() => _add_GroceryState();
}

class _add_GroceryState extends State<add_Grocery> {
  final groceryController = TextEditingController();
  final groceryAmtController = TextEditingController();
  final _userGroc = FirebaseFirestore.instance.collection('UserGroceries');
  final curUser = FirebaseAuth.instance.currentUser!;

  void _addToGroceries() {
    var grocList = [groceryController.text.trim()];

    _userGroc.where('createdBy', isEqualTo: curUser.uid).get().then((value) {
      if (value.docs.isNotEmpty) {
        _userGroc.doc(curUser.uid).update({
          'groceries': FieldValue.arrayUnion(grocList),
        });
        Utils.showSnackBar('Successfully updated!', Colors.green);
        Navigator.of(context).pop();
      } else {
        _userGroc.doc(curUser.uid).set({
          'groceries': FieldValue.arrayUnion(grocList),
          'createdBy': curUser.uid,
        });
        Utils.showSnackBar('Successfully added!', Colors.green);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.05),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 49,
                ),
                child: TextFormField(
                  controller: groceryController,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    labelText: 'Enter your grocery...',
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
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton(
                onPressed: () => _addToGroceries(),
                child: Text(
                  'Add to list',
                  style: TextStyle(
                    fontFamily: 'Gaegu-Bold',
                    fontSize: 24,
                    color: Color.fromRGBO(27, 27, 27, 1),
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
            ],
          ),
        ),
      ),
    );
  }
}
