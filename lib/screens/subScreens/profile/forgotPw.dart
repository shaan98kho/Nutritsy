import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nu_trit_sy/widgets/utils.dart';

import '../../../widgets/customAppBar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password reset email sent!', Colors.green);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          Navigator.of(context).pop();
          return Utils.showSnackBar(
              'There is no user registered to that email, try again!',
              Colors.red);
      }

      // Utils.showSnackBar(e.message, Colors.red);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      appBar: AppBar(
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
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: const Color.fromRGBO(113, 219, 119, 1),
                      fontFamily: 'Gaegu-Bold',
                      fontSize: 42,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                'Receive an email to reset your password:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.25,
                maxWidth: 280,
              ),
              child: TextFormField(
                controller: emailController,
                style: TextStyle(
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  labelText: 'Email address',
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
              height: 20,
            ),
            Container(
              width: 250,
              height: 51,
              child: ElevatedButton.icon(
                onPressed: resetPassword,
                icon: Icon(
                  Icons.email,
                  color: Color(0xff272727),
                ),
                label: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 25,
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
          ],
        ),
      ),
    );
  }
}
