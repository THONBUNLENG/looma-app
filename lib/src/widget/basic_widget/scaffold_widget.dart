import 'package:flutter/material.dart';

class ScaffoldWidget extends StatefulWidget {
  const ScaffoldWidget({super.key});

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

bool isTrue = false;
String _selectRadio = "";
int _selectitem = 0;
final List<String> mydata = ["Radio 1", "Radio 2", "Radio 3"];

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.grid_goldenratio, color: Colors.white),
            );
          },
        ),
        flexibleSpace: Container(height: 200, color: Colors.blue),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(height: 20, color: Colors.red),
        ),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(100),
          //   child: Image.asset(
          //     "assets/images/photo_2026-01-12_21-44-05.jpg",
          //     width: 30,
          //     fit: BoxFit.fill,
          //     height: 30,
          //   ),
          // ),
        ],
        centerTitle: false,
        title: Text(
          "Welcom flutter ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text("Tasks"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text("Tasks"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text("Tasks"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text("Tasks"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 20),
            Stack(
              children: [
                Container(width: 200, height: 200, color: Colors.amber),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(width: 100, height: 100, color: Colors.red),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(width: 50, height: 50, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelText: "Gender",
              ),
              items: [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
              onChanged: (value) {},
            ),
            ListTile(
              // ignore: deprecated_member_use
              leading: Radio(value: 1, groupValue: 1, onChanged: (value) {}),
              title: Text("Number-1"),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: isTrue,
                onChanged: (value) {
                  setState(() {
                    isTrue = !isTrue;
                  });
                },
              ),
            ),

            // RadioListTile(value: value)
            SizedBox(height: 20),
            RadioGroup<String>(
              groupValue: _selectRadio,
              onChanged: (value) {
                setState(() {
                  _selectRadio = value!;
                });
              },
              child: Column(
                children: List.generate(mydata.length, (index) {
                  return RadioListTile(
                    value: mydata[index],
                    title: Text(mydata[index].toUpperCase()),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.amberAccent,
        onPressed: () {},
        child: Icon(Icons.save, color: Colors.white),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.amberAccent,
      //   onPressed: () {},
      //   icon: Icon(Icons.save),
      //   label: Text("Save"),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        selectedLabelStyle: TextStyle(color: Colors.white),
        // selectedIconTheme: IconThemeData(color: Colors.white),
        onTap: (value) {
          setState(() {
            _selectitem = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        currentIndex: _selectitem,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_outlined),
            label: "History",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
