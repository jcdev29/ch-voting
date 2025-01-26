import 'package:hive/hive.dart';

import '../model/hive_voters_info.dart';


enum UserType { admin, voter, unknown }

class LoginService {
  // Dummy credentials for admin
  final String adminUsername = 'admin';
  final String adminPassword = 'admin123';

  HiveVotersInfo? currentVoter; // Keeps track of the logged-in voter

  Future<UserType> login(String username, String password) async {
    // Check if admin credentials
    if (username == adminUsername && password == adminPassword) {
      return UserType.admin;
    }

    // Check Hive for voter credentials
    final box = await Hive.openBox<HiveVotersInfo>('votersBox');
    for (var voter in box.values) {
      String voterUsername =
          '${voter.firstName}${voter.middleName}${voter.lastName}'
              .toLowerCase();
      if (voterUsername == username.toLowerCase() && password == 'voter123') {
        currentVoter = voter; // Save the current voter
        return UserType.voter;
      }
    }

    // If no match, return unknown
    return UserType.unknown;
  }
}
