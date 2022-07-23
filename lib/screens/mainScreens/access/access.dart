import 'package:flutter/material.dart';

import '../../../login.dart';

class Access extends StatefulWidget {
  @override
  State<Access> createState() => _AccessState();
}

class _AccessState extends State<Access> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(63, 65, 63, 43),
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/authentication/SignUpSnippets.jpg',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.55,
                  alignment: Alignment.center,
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  width: double.infinity,
                  child: const Text(
                    'Plan your meal\nanywhere, anytime!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto-Light',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.045),
                  width: 225,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (_) => false,
                      );
                    },
                    child: const Text(
                      'Start now',
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
                      //MaterialStateProperty.all(
                      //const Color.fromRGBO(113, 219, 119, 1)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      )),
                      //elevation: MaterialStateProperty.all(8),
                    ),
                  ),
                ),
                /*SizedBox(
                  width: 225,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'Gaegu-Regular',
                          fontSize: 32,
                          color: Color.fromRGBO(113, 219, 119, 1)),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
