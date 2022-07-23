import 'package:flutter/material.dart';

import './question.dart';

class displayQuestions extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  const displayQuestions({
    Key? key,
    required this.questions,
    required this.questionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Question(
      questions[questionIndex]['questionText'] as String,
    );
  }
}
