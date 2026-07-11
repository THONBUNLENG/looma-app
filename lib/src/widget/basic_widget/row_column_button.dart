import 'package:flutter/material.dart';

class RowColumnButton extends StatelessWidget {
  const RowColumnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button1(),
            TextButton(onPressed: () {}, child: Text("Click Button")),
            OutlinedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Click me"),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.red),
            ),
            DropdownButton(
              items: [
                DropdownMenuItem(value: "One", child: Text("One")),
                DropdownMenuItem(value: "Two", child: Text("Two")),
                DropdownMenuItem(value: "Three", child: Text("Three")),
                DropdownMenuItem(value: "Four", child: Text("Four")),
              ],
              onChanged: (value) {},
            ),

            PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (context) => [
                PopupMenuItem(child: Text("Edit")),
                PopupMenuItem(child: Text("Delete")),
              ],
            ),
            customeButton(),
            fovoriteCus(),
          ],
        ),
        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: [
        //       Icon(Icons.archive),
        //       Text("Hello"),
        //       Icon(Icons.archive),
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 8),
        //         width: 150,
        //         height: 60,
        //         decoration: BoxDecoration(
        //           color: Colors.red,
        //           borderRadius: BorderRadius.circular(16),
        //         ),
        //         child: Row(
        //           spacing: 8,
        //           children: [
        //             Icon(Icons.arrow_back, size: 30, color: Colors.white),
        //             Text(
        //               "Back Button",
        //               style: TextStyle(color: Colors.white, fontSize: 16),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Text("Hello"),
        //     ],
        //   ),
        // ),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Icon(Icons.access_alarm),
        //     Text("Hello flutter"),
        //     Container(width: 50, height: 50, color: Colors.amber),
        //     Container(width: 50, height: 50, color: Colors.red),
        //     Text("Hello flutter"),
        //   ],
        // ),
      ),
    );
  }

  Widget button1() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        side: BorderSide(width: 5, color: Colors.green),
      ),
      child: Text("Elevated Button", style: TextStyle(color: Colors.white)),
    );
  }

  Widget fovoriteCus() {
    return InkWell(
      onTap: () {
      },

      child: Material(
        borderRadius: BorderRadius.circular(24),
        child: Icon(Icons.favorite, color: Colors.red),
      ),
    );
  }

  Widget customeButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.red,
        ),
        child: Text("Click Me!", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
