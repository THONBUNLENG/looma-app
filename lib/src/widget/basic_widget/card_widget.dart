import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            imageExample(),
            SizedBox(height: 20),
            chipExample(),
            SizedBox(height: 20),
            wrapExample(),
            SizedBox(height: 20),
            cardExample(),
            SizedBox(height: 20),
            giftCard(),
          ],
        ),
      ),
    );
  }

  Widget imageExample() {
    return Card(
      color: Colors.amber,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/images.jpeg", width: 300, height: 200),
          Text("Welcome, flutter"),
        ],
      ),
    );
  }

  Widget chipExample() {
    return Chip(
      avatar: Icon(Icons.history, color: Colors.white, size: 26),
      elevation: 1,
      labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      label: Text(
        "Processing",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      color: WidgetStatePropertyAll(Colors.red),
    );
  }

  Widget wrapExample() {
    return Wrap(
      children: [
        Chip(
          avatar: Icon(Icons.history, color: Colors.white, size: 26),
          elevation: 1,
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          label: Text(
            "Processing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: WidgetStatePropertyAll(Colors.red),
        ),
        Chip(
          avatar: Icon(Icons.history, color: Colors.white, size: 26),
          elevation: 1,
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          label: Text(
            "Processing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: WidgetStatePropertyAll(Colors.red),
        ),
        Chip(
          avatar: Icon(Icons.history, color: Colors.white, size: 26),
          elevation: 1,
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          label: Text(
            "Processing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: WidgetStatePropertyAll(Colors.red),
        ),
        Chip(
          avatar: Icon(Icons.history, color: Colors.white, size: 26),
          elevation: 1,
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          label: Text(
            "Processing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: WidgetStatePropertyAll(Colors.red),
        ),
        Wrap(
          runSpacing: 16,
          runAlignment: WrapAlignment.start,
          children: List.generate(5, (index) {
            return Chip(
              avatar: Icon(Icons.history, color: Colors.white, size: 26),
              elevation: 1,
              labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              label: Text(
                "Processing",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: WidgetStatePropertyAll(Colors.red),
            );
          }),
        ),
      ],
    );
  }

  Widget cardExample() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: ListTile(
          iconColor: Colors.amber,
          textColor: Colors.red,
          leading: Image.asset("assets/images/images.jpeg"),
          title: Text("ListTile"),
          subtitle: Text("Subtitle of  ListTile"),
          trailing: Icon(Icons.more_horiz_sharp),
        ),
      ),
    );
  }

  Widget giftCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.asset(
                "assets/images/photo_2026-01-12_21-44-05.jpg",
              ),
              title: Text(
                "You have 2 Genius rewards",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "10% discount and so much more!",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 0.5, color: Colors.grey.shade200),
            ),
            Text("You're 5 bookings away from Genius Level2"),
          ],
        ),
      ),
    );
  }
}
