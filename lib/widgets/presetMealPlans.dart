import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../widgets/mealPlanList.dart';

class presetMealPlans extends StatefulWidget {
  final String pathName;
  final DateTime presetDay;
  const presetMealPlans({
    Key? key,
    required this.pathName,
    required this.presetDay,
  }) : super(key: key);

  @override
  State<presetMealPlans> createState() => _presetMealPlansState();
}

class _presetMealPlansState extends State<presetMealPlans> {
  final curUserDB = FirebaseFirestore.instance.collection('users');
  final suggestedMealPlan =
      FirebaseFirestore.instance.collection('suggestedMealPlan');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: suggestedMealPlan
          .doc(widget.pathName)
          .collection('presetMealPlans')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              ...snapshot.data!.docs.map((planData) {
                List planDataItems = planData['recipeID'] as List;
                String date = planData['day'];
                if (DateFormat('EEEE').format(widget.presetDay) == date) {
                  return mealPlanList(
                      mpRecipeID: planDataItems, planDate: widget.presetDay);
                } else {
                  return SizedBox(
                    width: 0,
                    height: 0,
                  );
                }
              }),
            ],
          );
        }
      },
    );
  }
}
