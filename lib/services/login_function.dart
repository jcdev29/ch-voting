
enum UserType { admin, voter, unknown }

class LoginService {
  // Dummy credentials for demonstration purposes
  final String adminUsername = 'admin';
  final String adminPassword = 'admin123';
  final String voterUsername = 'voter';
  final String voterPassword = 'voter123';

  UserType login(String username, String password) {
    if (username == adminUsername && password == adminPassword) {
      return UserType.admin;
    } else if (username == voterUsername && password == voterPassword) {
      return UserType.voter;
    } else {
      return UserType.unknown;
    }
  }
}