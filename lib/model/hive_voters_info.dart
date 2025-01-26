import 'package:hive/hive.dart';

part 'hive_voters_info.g.dart';

@HiveType(typeId: 1)
class HiveVotersInfo {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String middleName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String sex;

  @HiveField(4)
  String birthdate;

  @HiveField(5)
  String address;

  @HiveField(6)
  String contactNumber;

  @HiveField(7)
  String emailAddress;

  @HiveField(8)
  String? chosenPresident;

  @HiveField(9)
  String? chosenVicePresident;

  @HiveField(10)
  List<String>? chosenSenators;


  HiveVotersInfo({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.sex,
    required this.birthdate,
    required this.address,
    required this.contactNumber,
    required this.emailAddress,
    this.chosenPresident,
    this.chosenVicePresident,
    this.chosenSenators,
  });

  // Convert a VoterInformation object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'sex': sex,
      'birthdate': birthdate,
      'address': address,
      'contactNumber': contactNumber,
      'emailAddress': emailAddress,
      'chosenPresident': chosenPresident,
      'chosenVicePresident': chosenVicePresident,
      'chosenSenators': chosenSenators,
    };
  }

  // Create a VoterInformation object from a JSON map
  factory HiveVotersInfo.fromJson(Map<String, dynamic> json) {
    return HiveVotersInfo(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      sex: json['sex'],
      birthdate: json['birthdate'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      emailAddress: json['emailAddress'],
      chosenPresident: json['chosenPresident'],
      chosenVicePresident: json['chosenVicePresident'],
      chosenSenators: json['chosenSenators'],
    );
  }
}
