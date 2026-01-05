import 'package:flutter/material.dart';
import 'add_voter_screen.dart';
import 'search_voter_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userPhone;

  HomeScreen({required this.userName, required this.userPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ward 5 Voters")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AddVoterScreen()));
                },
                child: Text("Add Voter")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SearchVoterScreen(userName: userName, userPhone: userPhone)));
                },
                child: Text("Search Voter")),
          ],
        ),
      ),
    );
  }
}
