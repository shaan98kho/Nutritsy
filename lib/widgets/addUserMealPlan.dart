import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../widgets/utils.dart';

class addUserMealPlan extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? data;

  addUserMealPlan({Key? key, required this.data}) : super(key: key);

  @override
  State<addUserMealPlan> createState() => _addUserMealPlanState();
}

class _addUserMealPlanState extends State<addUserMealPlan> {
  DateTime? _selectedDate;
  String? _formattedDate;
  //bool _isInMealPlan = false;

  final curUser = FirebaseAuth.instance.currentUser!;
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final mealPlan = FirebaseFirestore.instance.collection('userMealPlan');

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(27, 27, 27, 1),
                background: Color.fromRGBO(27, 27, 27, 1),
                onPrimary: Color.fromRGBO(113, 219, 119, 1),
              ),
            ),
            child: child!);
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _formattedDate = DateFormat('y-MM-d').format(_selectedDate!);
      });
    });
  }

  void _addToMealPlan() {
    var recipeList = [widget.data!.id];
    try {
      mealPlan
          .where('createdBy', isEqualTo: curUser.uid)
          .where('date', isEqualTo: _formattedDate)
          .get()
          .then((mp) {
        if (mp.docs.isNotEmpty) {
          mealPlan
              .where('recipeID', arrayContains: widget.data!.id)
              .where('createdBy', isEqualTo: curUser.uid)
              .where('date', isEqualTo: _formattedDate)
              .get()
              .then((rID) {
            if (rID.docs.isNotEmpty) {
              return Utils.showSnackBar(
                  'You have already planned this recipe for ${DateFormat('EEEE').format(_selectedDate!)}!',
                  Colors.red);
            } else {
              mealPlan.doc(_formattedDate! + curUser.uid).update({
                'recipeID': FieldValue.arrayUnion(recipeList),
              });
              Utils.showSnackBar('Successfully updated!', Colors.green);
            }
          });
        } else {
          mealPlan.doc(_formattedDate! + curUser.uid).set({
            'mealPlanID': _formattedDate! + curUser.uid,
            'createdBy': curUser.uid,
            'recipeID': FieldValue.arrayUnion(recipeList),
            'date': _formattedDate,
          });
          Utils.showSnackBar(
              'Successfully added to your meal plan!', Colors.green);
        }
      });
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Color.fromRGBO(39, 39, 39, 1).withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please select the date:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Gaegu-Regular',
                color: Color.fromRGBO(113, 219, 119, 1),
                fontSize: 32,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date chosen!'
                      : 'Picked date: $_formattedDate',
                  style: TextStyle(
                    fontFamily: 'Gaegu-Regular',
                    fontSize: 18,
                    color: Color.fromRGBO(215, 255, 217, 1),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _presentDatePicker();
                  },
                  child: Text(
                    'Choose date',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: 'Gaegu-Regular',
                      fontSize: 18,
                      color: Color.fromRGBO(215, 255, 217, 1),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _addToMealPlan(),
              child: Text(
                'Add to meal plan',
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
    );
  }
}
