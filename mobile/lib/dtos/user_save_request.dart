import 'package:firebase_auth/firebase_auth.dart';

class UserSaveRequest {
  String firebaseUid;
  String email;

  UserSaveRequest({required this.firebaseUid, required this.email});

  factory UserSaveRequest.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'firebaseUid': String firebaseUid,
        'email': String email,
      } =>
        UserSaveRequest(
          firebaseUid: firebaseUid,
          email: email,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }

  factory UserSaveRequest.fromFirebaseUser(User user) {
    return UserSaveRequest(firebaseUid: user.uid, email: user.email!);
  }

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': firebaseUid,
      'email': email,
    };
  }
}
