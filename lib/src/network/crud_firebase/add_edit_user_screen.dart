import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../constants/color.dart';
import '../../model/user.dart';
import '../../widget/button_cus.dart';
import '../../widget/text_form_cus.dart';

class AddEditUserScreen extends StatefulWidget {
  const AddEditUserScreen({super.key, this.user});
  final UserModel? user;

  @override
  State<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  final List<String> geners = ['Male', 'Femal', 'Other'];
  final userController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  String? selectedGender;
  File? _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> _pickImg() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void initData() {
    if (widget.user == null) return;
    userController.text = widget.user?.name ?? "";
    ageController.text = widget.user?.age ?? "";
    addressController.text = widget.user?.address ?? "";
    selectedGender = widget.user?.gender ?? "Male";
    _imageFile = File(widget.user?.picture ?? "");
    setState(() {});
  }

  Future<void> saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final data = {
        "name": userController.text,
        "age": ageController.text,
        "address": addressController.text,
        "gender": selectedGender ?? "",
        "picture": _imageFile?.path ?? "",
      };

      if ((widget.user?.id ?? "").isEmpty) {
        await FirebaseFirestore.instance.collection("user").add(data);
      } else {
        await FirebaseFirestore.instance
            .collection("user")
            .doc(widget.user?.id ?? "")
            .update(data);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: pink100Color),
      );
    }
  }

  Future<void> alertDeleteUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text("Delete"),
          content: Text("Do you want to delete?"),
          actions: [
            CupertinoButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child: TextWidget("Confirm"),
              onPressed: () {
                Navigator.pop(context);
                deleteUser();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser() async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(widget.user?.id ?? "")
          .delete();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: pink100Color),
      );
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: ButtonCus(
                  buttonName: (widget.user?.id ?? "").isEmpty
                      ? 'Save'
                      : "Update",
                  bgColor: (widget.user?.id ?? "").isEmpty
                      ? mainColor
                      : greenColor,
                  onPressed: () => saveUser(),
                ),
              ),
              if (widget.user != null)
                Expanded(
                  child: ButtonCus(
                    bgColor: pink100Color,
                    buttonName: 'Delete user',
                    onPressed: () => alertDeleteUser(),
                  ),
                ),
            ],
          ),
        ),
      ],
      appBar: AppBar(title: Text("Add & Edit USER")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: () => _pickImg(),
              child: CircleAvatar(
                radius: 45,
                backgroundImage:
                    FileImage(File(_imageFile?.path ?? "")) as ImageProvider,
              ),
            ),
            SizedBox(height: 24),
            TextFormCus(
              hintText: "User name",
              controller: userController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name user'; // Error message
                }
                return null; // Input is valid
              },
            ),
            SizedBox(height: 16),
            TextFormCus(
              hintText: "Age",
              controller: ageController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter age'; // Error message
                }
                return null; // Input is valid
              },
            ),
            SizedBox(height: 16),
            TextFormCus(
              hintText: "Address",
              controller: addressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address'; // Error message
                }
                return null; // Input is valid
              },
            ),
            SizedBox(height: 16),
            // DropdownFlutter<String>(
            //   decoration: CustomDropdownDecoration(
            //     closedFillColor: grey30Color,
            //     closedBorderRadius: BorderRadius.circular(32),
            //   ),
            //   hintText: 'Select gender',
            //   items: geners,
            //   initialItem: selectedGender,
            //   onChanged: (value) => setState(() {
            //     selectedGender = value ?? "Male";
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}

