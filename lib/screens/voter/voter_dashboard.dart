import 'package:ch_vote/model/hive_voters_info.dart';
import 'package:ch_vote/screens/drawer.dart';
import 'package:ch_vote/screens/login.dart';
import 'package:ch_vote/screens/voter/voting_screen.dart';
import 'package:flutter/material.dart';

class VoterDashboard extends StatelessWidget {
  final HiveVotersInfo voter;
  final String user;

  const VoterDashboard({super.key, required this.voter, required this.user});

  void navigateToVotingScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VotingScreen(
                voter: voter,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLoggedVoter = user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      drawer: DrawerScreen(
        loggedInUser: currentLoggedVoter,
        onLogout: () {
          _handleLogout(context);
        },
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => navigateToVotingScreen(context),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 6,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.how_to_vote,
                          size: 64,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Go to Voting Screen',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
