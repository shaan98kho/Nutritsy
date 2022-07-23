import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About_Us extends StatefulWidget {
  const About_Us({Key? key}) : super(key: key);

  @override
  State<About_Us> createState() => _About_UsState();
}

class _About_UsState extends State<About_Us> {
  String _blockOfText =
      '      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dui sapien eget mi proin. Velit sed ullamcorper morbi tincidunt ornare massa eget. Ullamcorper velit sed ullamcorper morbi tincidunt ornare. Nulla aliquet porttitor lacus luctus accumsan tortor posuere ac. Condimentum lacinia quis vel eros. Gravida dictum fusce ut placerat orci nulla. Fermentum leo vel orci porta non pulvinar neque laoreet suspendisse. Tempor nec feugiat nisl pretium fusce id velit ut. Ut tortor pretium viverra suspendisse potenti. Feugiat in fermentum posuere urna nec tincidunt. Tellus mauris a diam maecenas sed enim. Et molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit.\n';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
      body: ListView(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 250,
              maxHeight: 150,
            ),
            child: Image.asset(
              'assets/images/welcome/logo.jpg',
              //width: MediaQuery.of(context).size.width - 54,
              //either use ^, or use constrainedbox()
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              children: [
                Text(
                  'About Nutritsy',
                  style: TextStyle(
                    fontFamily: 'Gaegu-Bold',
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                RichText(
                  text: TextSpan(
                    text: _blockOfText + '\n' + _blockOfText,
                    style: TextStyle(
                      fontFamily: 'Roboto-Light',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  textAlign: TextAlign.justify,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    CupertinoIcons.chevron_left_circle_fill,
                    size: 45,
                  ),
                  color: Color.fromRGBO(113, 219, 119, 1),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
