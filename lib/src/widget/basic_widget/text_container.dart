import 'package:flutter/material.dart';

class BasicWidget extends StatelessWidget {
  const BasicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 13),
              BoxShadow(color: Colors.black, blurRadius: 13),
            ],
            // border: Border(top: BorderSide(color: Colors.black, width: 5)),
          ),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          padding: EdgeInsets.all(16),
          child: Text(
            "Hello, Flutter",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Text(
        //   "Hello,world",
        //   style: TextStyle(
        //     fontSize: 32,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.red,
        //     backgroundColor: Colors.deepPurple,
        //     letterSpacing: 2,
        //   ),
        // ),
      ),
    );
  }
}
