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
  final List<String> genders = ['Male', 'Female', 'Other'];
  final userController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  String? selectedGender;
  File? _imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void initData() {
    if (widget.user == null) return;
    userController.text = widget.user?.name ?? "";
    ageController.text = widget.user?.dateOfBirth ?? "";
    addressController.text = widget.user?.address ?? "";
    selectedGender = genders.contains(widget.user?.gender) 
        ? widget.user?.gender 
        : 'Male';
    
    if (widget.user?.photoUrl != null && widget.user!.photoUrl.isNotEmpty) {
      final file = File(widget.user!.photoUrl);
      if (file.existsSync()) {
        _imageFile = file;
      }
    }
    setState(() {});
  }

  Future<void> _pickImg() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
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
        "dateOfBirth": ageController.text,
        "address": addressController.text,
        "gender": selectedGender ?? "",
        "photoUrl": _imageFile?.path ?? "",
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
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> alertDeleteUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Delete"),
          content: const Text("Do you want to delete this user?"),
          actions: [
            CupertinoButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child:  TextWidget("Confirm"),
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
    setState(() {
      isLoading = true;
    });
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
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                  buttonName: isLoading 
                      ? 'Processing...' 
                      : ((widget.user?.id ?? "").isEmpty ? 'Save' : "Update"),
                  bgColor: (widget.user?.id ?? "").isEmpty
                      ? mainColor
                      : greenColor,
                  onPressed: isLoading ? null : () => saveUser(),
                ),
              ),
              if (widget.user != null)
                Expanded(
                  child: ButtonCus(
                    bgColor: pink100Color,
                    buttonName: 'Delete user',
                    onPressed: isLoading ? null : () => alertDeleteUser(),
                  ),
                ),
            ],
          ),
        ),
      ],
      appBar: AppBar(title: const Text("Add & Edit USER")),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: isLoading ? null : () => _pickImg(),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _imageFile != null && _imageFile!.existsSync()
                          ? FileImage(_imageFile!)
                          : null,
                      child: (_imageFile == null || !_imageFile!.existsSync())
                          ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormCus(
                  hintText: "User name",
                  controller: userController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormCus(
                  hintText: "Age",
                  controller: ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormCus(
                  hintText: "Address",
                  controller: addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedGender,
                  decoration: InputDecoration(
                    hintText: 'Select gender',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    filled: true,
                    fillColor: grey30Color,
                  ),
                  items: genders.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: isLoading ? null : (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
