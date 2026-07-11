import 'package:flutter/material.dart';

class ListViewBuilderWidet extends StatefulWidget {
  const ListViewBuilderWidet({super.key});

  @override
  State<ListViewBuilderWidet> createState() => _ListViewBuilderWidetState();
}

class _ListViewBuilderWidetState extends State<ListViewBuilderWidet> {
  bool showExpand = false;
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: ListView(
            children: [
              TextField(
                onChanged: (value) {
                },
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefix: Icon(Icons.lock),
                  hintText: "Password",
                  label: Text("Password"),
                ),
              ),
              SizedBox(height: 20),

              Form(
                key: _formKey,
                child: TextFormField(
                  onChanged: (value) {
                  },
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pleae enter password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefix: Icon(Icons.lock),
                    hintText: "Password",
                    label: Text("Password"),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  }
                },
                child: Text("Submit"),
              ),
              SizedBox(height: 20),
              Checkbox(
                value: isCheck,
                fillColor: WidgetStatePropertyAll(Colors.red),
                checkColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    isCheck = !isCheck;
                  });
                },
              ),
            ],
          ),
          // ExpansionTile(
          //   onExpansionChanged: (value) {
          //     setState(() {
          //       showExpand = !showExpand;
          //     });
          //   },
          //   trailing: showExpand
          //       ? Icon(Icons.keyboard_arrow_up_outlined)
          //       : Icon(Icons.keyboard_arrow_down_outlined),
          //   title: Text("Title of Expan"),
          //   subtitle: Text("Description of title"),
          //   children: [Text("Long text....")],
          // ),
          //  GridView.builder(
          //   padding: EdgeInsets.all(8),
          //   itemCount: 20,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 8,
          //     mainAxisSpacing: 8,
          //   ),
          //   itemBuilder: (context, index) {
          //     return Container(width: 100, height: 100, color: Colors.amber);
          //   },
          // ),
          // ListView.separated(
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       leading: Icon(Icons.person, size: 30),
          //       title: Text("Example"),
          //       subtitle: Text("Description"),
          //     );
          //   },
          //   separatorBuilder: (context, index2) {
          //     return Divider(color: Colors.grey);
          //   },
          //   itemCount: 20,
          // ),
          // ListView.builder(
          //   padding: EdgeInsets.all(16),
          //   itemCount: 20,
          //   itemBuilder: (context, index) {
          //     return Card(
          //       child: ListTile(
          //         leading: Icon(Icons.person, size: 30),
          //         title: Text("Example"),
          //         subtitle: Text("Description"),
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
