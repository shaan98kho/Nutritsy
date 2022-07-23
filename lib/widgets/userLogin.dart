import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../screens/subScreens/profile/forgotPw.dart';
import '../main.dart';
import './utils.dart';

class UserLogin extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const UserLogin({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      UserCredential result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final registeredUser = result.user!;
      await registeredUser.reload();
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "The password is invalid or the user does not have a password.":
          navigatorKey.currentState!.popUntil((route) => route.isFirst);
          return Utils.showSnackBar('Invalid password, try again!', Colors.red);

        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          navigatorKey.currentState!.popUntil((route) => route.isFirst);
          return Utils.showSnackBar(
              'There is no user registered to that email, try again!',
              Colors.red);

        case "The email address is badly formatted.":
          navigatorKey.currentState!.popUntil((route) => route.isFirst);
          return Utils.showSnackBar(
              'Invalid email format, try again!', Colors.red);
      }
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              key: formKey,
              child: Column(
                children: [
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
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        style: TextStyle(
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                        controller: passwordController,
                        obscureText: _passwordVisible,
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
                        text: 'Don\'t have an account yet?    ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'Sign Up',
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
                    margin: EdgeInsets.only(top: 15),
                    width: 225,
                    height: 51,
                    child: ElevatedButton(
                      onPressed: signIn,
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff272727),
                          fontFamily: 'Gaegu-Bold',
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                        //(_) => false,
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(215, 255, 217, 1),
                        fontFamily: 'Gaegu-Bold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
