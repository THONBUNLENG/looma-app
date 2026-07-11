import 'package:flutter/material.dart';

class PaddingSizedboxExpanded extends StatelessWidget {
  const PaddingSizedboxExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Container(width: 60, color: Colors.amber, height: 50),
            // SizedBox(height: 10),
            // Container(width: 60, color: Colors.amber, height: 50),
            // SizedBox(height: 40),
            // Container(width: 60, color: Colors.amber, height: 50),
            // SizedBox(height: 20),
            // Container(width: 60, color: Colors.red, height: 50),
            // SizedBox(height: 50),
            // SizedBox(
            //   width: 200,
            //   height: 50,
            //   child: ElevatedButton(onPressed: () {}, child: Text("Button")),
            // ),

            // // Expanded(child: child)
            // Row(
            //   children: [
            //     Container(width: 100, color: Colors.red, height: 60),
            //     Container(width: 50, color: Colors.amber, height: 40),
            //     Expanded(child: Container(color: Colors.blue, height: 20)),
            //   ],
            // ),

            // SizedBox(
            //   height: 300,
            //   child: Column(
            //     children: [
            //       Container(width: 100, color: Colors.red, height: 60),
            //       Container(width: 50, color: Colors.amber, height: 40),
            //       Expanded(child: Container(color: Colors.blue)),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 30),
            Center(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.red,
                alignment: Alignment.center,
                child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  color: Colors.blue,
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),

        // Row(

        //   children: [
        //     Container(width: 60, color: Colors.amber, height: 50),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 20),
        //       child: Container(width: 60, color: Colors.red, height: 50),
        //     ),
        //   ],
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 25),
        //   child: Text(
        //     "Hello,padding",
        //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        //   ),
        // ),
      ),
    );
  }
}
