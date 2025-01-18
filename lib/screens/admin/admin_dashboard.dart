import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void navigateToRegistration(BuildContext context) {
    Navigator.pushNamed(context, '/registration');
  }

  void navigateToVotersList(BuildContext context) {
    Navigator.pushNamed(context, '/votersList');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => navigateToRegistration(context),
              child: Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      Icon(Icons.app_registration, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Registration',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => navigateToVotersList(context),
              child: Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      Icon(Icons.list, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Voter\'s List',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
