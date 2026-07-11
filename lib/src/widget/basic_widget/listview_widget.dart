import 'package:flutter/material.dart';

class ListviewWidget extends StatelessWidget {
  const ListviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(width: 60, color: Colors.amber, height: 50),
          SizedBox(height: 10),
          Container(width: 60, color: Colors.amber, height: 50),
          SizedBox(height: 40),
          Container(width: 60, color: Colors.amber, height: 50),
          SizedBox(height: 20),
          Container(width: 60, color: Colors.red, height: 50),
          SizedBox(height: 50),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(10, (int index) {
                return ElevatedButton(onPressed: () {}, child: Text("Button"));
              }),
            ),
          ),

          // Expanded(child: child)
          Row(
            children: [
              Container(width: 100, color: Colors.red, height: 60),
              Container(width: 50, color: Colors.amber, height: 40),
              Expanded(child: Container(color: Colors.blue, height: 20)),
            ],
          ),

          SizedBox(
            height: 300,
            child: Column(
              children: [
                Container(width: 100, color: Colors.red, height: 60),
                Container(width: 50, color: Colors.amber, height: 40),
                Expanded(child: Container(color: Colors.blue)),
              ],
            ),
          ),
          SizedBox(height: 30),
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

          SizedBox(height: 30),
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
    );
  }
}
