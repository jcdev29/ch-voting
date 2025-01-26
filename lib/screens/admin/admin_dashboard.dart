import 'package:ch_vote/screens/drawer.dart';
import 'package:ch_vote/screens/login.dart';
import 'package:flutter/material.dart';
import 'admin_registration.dart';
import 'admin_voter_list.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void navigateToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminRegistration()),
    );
  }

  void navigateToVotersList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminVotersList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      drawer: DrawerScreen(
        loggedInUser: 'Admin User', 
        onLogout: () {
          _handleLogout(context);
        },
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDashboardCard(
                context,
                icon: Icons.app_registration,
                title: 'Registration',
                onTap: () => navigateToRegistration(context),
              ),
              const SizedBox(height: 16),
              _buildDashboardCard(
                context,
                icon: Icons.list,
                title: 'Voter\'s List',
                onTap: () => navigateToVotersList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.deepPurple.shade50,
          ),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Colors.deepPurple),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Navigate to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false, // Remove all previous routes
    );
  }
}
