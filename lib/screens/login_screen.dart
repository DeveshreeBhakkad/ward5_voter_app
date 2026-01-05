import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void loginUser(BuildContext context) async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter name and phone number")));
      return;
    }

    await FirebaseFirestore.instance.collection('access_logs').add({
      'user_name': name,
      'user_phone': phone,
      'timestamp': DateTime.now(),
      'action': 'Login'
    });

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => HomeScreen(userName: name, userPhone: phone)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ward 5 Voter App")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => loginUser(context), child: Text("Login"))
          ],
        ),
      ),
    );
  }
}
