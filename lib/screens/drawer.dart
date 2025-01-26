import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  final String loggedInUser; // Pass the user's name or ID here
  final VoidCallback onLogout; // Callback for handling logout

  const DrawerScreen({
    super.key,
    required this.loggedInUser,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              loggedInUser,
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: const Text('Logged in'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.deepPurple),
            title: const Text('Logout'),
            onTap: () {
              // Show confirmation dialog before logout
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text(
                        'Are you sure you want to log out? This will end your current session.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Close dialog
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple),
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          onLogout(); // Call the logout handler
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
