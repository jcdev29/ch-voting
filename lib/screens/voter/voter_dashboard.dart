import 'package:flutter/material.dart';

class VoterDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voter Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Voter Dashboard!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

