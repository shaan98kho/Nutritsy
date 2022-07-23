import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';
import '../../widgets/quiz/displayQuestions.dart';
import '../../widgets/customAppBar.dart';

class quizPage extends StatefulWidget {
  const quizPage({Key? key}) : super(key: key);

  @override
  State<quizPage> createState() => _quizPageState();
}

class _quizPageState extends State<quizPage> {
  final List<Map<String, Object>> questions = [];
  var _questionIndex = 0;
  var _totalScore = 0;

  final _questions = const [
    {
      'questionText': 'What are you trying to achieve with Nutritsy?',
      'answers': [
        {'text': 'Lose weight', 'score': 10},
        {'text': 'Gain weight', 'score': 5},
        {'text': 'Get healthier', 'score': 3},
        {'text': 'Go vegan', 'score': 2},
      ],
    },
    {
      'questionText': 'What\'s your current BMI?',
      'answers': [
        {'text': 'Underweight', 'score': 8},
        {'text': 'Healthy', 'score': 7},
        {'text': 'Overweight', 'score': 5},
        {'text': 'Obese', 'score': 2},
      ],
    },
  ];

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex += 1;
    });

    if (_questionIndex > _questions.length) {
      setState(() {
        _questionIndex = 0;
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 27, 27, 1),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.3,
        automaticallyImplyLeading: false,
        leading: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
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
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        'Nutritsy',
                        style: TextStyle(
                          color: const Color.fromRGBO(113, 219, 119, 1),
                          fontFamily: 'Gaegu-Bold',
                          fontSize: 45,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.025),
                        child: _questionIndex < _questions.length
                            ? displayQuestions(
                                questions: _questions,
                                questionIndex: _questionIndex,
                              )
                            : FittedBox(
                                child: Text(
                                  'We matched you\nwith the following:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontFamily: 'Gaegu-Bold',
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      body: Column(
        children: [
          _questionIndex < _questions.length
              ? Quiz(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: _questions,
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.625,
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Result(
                      resultScore: _totalScore, resetHandler: _resetQuiz),
                ),
        ],
      ),
    );
  }
}
