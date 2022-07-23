import 'package:flutter/material.dart';

class Answers extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  Answers(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200.0,
        height: 50.0,
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        //textColor: Colors.white,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Color.fromRGBO(215, 255, 217, 1);

                return Color.fromRGBO(113, 219, 119, 1);
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          child: FittedBox(
            alignment: Alignment.center,
            child: Text(
              answerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(27, 27, 27, 1),
                fontSize: 20,
              ),
            ),
          ),
          onPressed: selectHandler,
        ),
      ),
    );
  }
}
