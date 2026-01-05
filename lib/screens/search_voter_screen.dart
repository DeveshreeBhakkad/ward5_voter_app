import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchVoterScreen extends StatefulWidget {
  final String userName;
  final String userPhone;

  SearchVoterScreen({required this.userName, required this.userPhone});

  @override
  _SearchVoterScreenState createState() => _SearchVoterScreenState();
}

class _SearchVoterScreenState extends State<SearchVoterScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> results = [];

  void searchVoter() async {
    String query = searchController.text.trim();
    if (query.isEmpty) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('voters')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      results = snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
    });

    await FirebaseFirestore.instance.collection('access_logs').add({
      'user_name': widget.userName,
      'user_phone': widget.userPhone,
      'timestamp': DateTime.now(),
      'action': 'Searched: $query'
    });
  }

  void addPhoneNumber(String voterId, String number) async {
    await FirebaseFirestore.instance
        .collection('voters')
        .doc(voterId)
        .update({'phone_number': number});
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Phone added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Voter")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: searchController, decoration: InputDecoration(labelText: "Enter name or surname")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: searchVoter, child: Text("Search")),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var voter = results[index];
                  TextEditingController phoneController = TextEditingController();
                  return ListTile(
                    title: Text(voter['name']),
                    subtitle: Text(voter['phone_number'] ?? "No number"),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          Expanded(child: TextField(controller: phoneController, decoration: InputDecoration(hintText: "Add phone"))),
                          IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              addPhoneNumber(voter['id'], phoneController.text.trim());
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
