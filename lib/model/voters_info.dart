class VotersInformation {
  final String firstName;
  final String middleName;
  final String lastName;
  final String sex;
  final String birthdate;
  final String address;
  final String contactNumber;
  final String emailAddress;

  VotersInformation({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.sex,
    required this.birthdate,
    required this.address,
    required this.contactNumber,
    required this.emailAddress,
  });

  // Convert a VotersInformation object into a JSON map
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
    };
  }

  // Create a VotersInformation object from a JSON map
  factory VotersInformation.fromJson(Map<String, dynamic> json) {
    return VotersInformation(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      sex: json['sex'],
      birthdate: json['birthdate'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      emailAddress: json['emailAddress'],
    );
  }
}
