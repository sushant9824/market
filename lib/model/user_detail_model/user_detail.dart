class UserDetail {
  int id;
  String firstName;
  String lastName;
  String fullName;
  String mobileNumber;
  String email;
  String profilePictureUrl;

  UserDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.profilePictureUrl
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] ?? 'n/a',
      firstName: json['firstName'] ?? 'n/a',
      lastName: json['lastName'] ?? 'n/a',
      fullName: json['fullName'] ?? 'n/a',
      mobileNumber: json['mobileNumber'] ?? 'n/a',
      email: json['email'] ?? 'n/a',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
    );
  }
}
