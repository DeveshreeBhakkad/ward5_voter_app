import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVoterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  void addVoter(BuildContext context) async {
    String name = nameController.text.trim();
    String surname = surnameController.text.trim();

    if (name.isEmpty || surname.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter name and surname")));
      return;
    }

    await FirebaseFirestore.instance.collection('voters').add({
      'name': name,
      'surname': surname,
      'phone_number': ""
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Voter Added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Voter")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: surnameController, decoration: InputDecoration(labelText: "Surname")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => addVoter(context), child: Text("Add Voter"))
          ],
        ),
      ),
    );
  }
}
