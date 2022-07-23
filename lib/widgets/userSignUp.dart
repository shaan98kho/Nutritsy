import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

import './utils.dart';
import '../main.dart';
import '../models/user.dart' as u;

class UserSignUp extends StatefulWidget {
  final Function() onClickedSignIn;
  const UserSignUp({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _passwordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    final docUser = FirebaseFirestore.instance.collection('users');

    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User registeredUser = result.user!;

      final user = u.User(
        uId: registeredUser.uid,
        uName: userNameController.text,
        uEmail: emailController.text.trim(),
        uTag: '',
      );

      final json = user.toJson();
      await docUser.doc(registeredUser.uid).set(json);
      await registeredUser.reload();
      await registeredUser.updateDisplayName(userNameController.text);

      //await FirebaseAuth.instance.currentUser!
      //.updateDisplayName(userNameController.text);

    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, Colors.red);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 200,
                bottom: 50,
              ),
              child: Text(
                'Nutritsy',
                style: TextStyle(
                  color: const Color.fromRGBO(113, 219, 119, 1),
                  fontFamily: 'Gaegu-Bold',
                  fontSize: 85,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Form(
                child: Column(
                  children: [
                    Container(
                      //height: 58,
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 280,
                          maxHeight: MediaQuery.of(context).size.height * 0.25,
                        ),
                        child: TextFormField(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            //counterText: '',
                            labelText: 'Email Address',
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
                                //borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) => email != null &&
                                      !EmailValidator.validate(email) ||
                                  email == null
                              ? 'Enter a valid email'
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      //height: 58,
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 280,
                          maxHeight: MediaQuery.of(context).size.height * 0.25,
                        ),
                        child: TextFormField(
                          controller: userNameController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            //counterText: '',
                            labelText: 'Username',
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
                                //borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) => value!.isEmpty
                              ? 'This field must not be empty'
                              : RegExp(r'[!#<>?":_`~;[\]\\|=+)(*&^%\s-]')
                                      .hasMatch(value)
                                  ? 'Enter a valid name'
                                  : null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 280,
                          maxHeight: MediaQuery.of(context).size.height * 0.25,
                        ),
                        child: TextFormField(
                          obscureText: _passwordVisible,
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            labelText: 'Password',
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
                                //borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? CupertinoIcons.eye_fill
                                    : CupertinoIcons.eye_slash_fill,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Enter min. 6 characters'
                                  : null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.25,
                          maxWidth: 280,
                        ),
                        child: TextFormField(
                          obscureText: _passwordVisible,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            labelText: 'Confirm password',
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
                                //borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? CupertinoIcons.eye_fill
                                    : CupertinoIcons.eye_slash_fill,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field must not be empty!';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords are not matched!';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto-Bold',
                            fontSize: 12,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          ),
                          text: 'Already have an account?    ',
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignIn,
                              text: 'Sign in',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(215, 255, 217, 1),
                                fontFamily: 'Gaegu-Bold',
                              ),
                            )
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 225,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: signUp,
                        child: Text(
                          'Sign Up',
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
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
