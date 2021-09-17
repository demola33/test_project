class CustomUser {
  CustomUser({
    required this.uid,
    required this.photoUrl,
    required this.displayName,
    required this.email,
  });

  final String uid;
  final String photoUrl;
  final String displayName;
  final String email;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'email': email,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      uid: map['uid'],
      photoUrl: map['photoUrl'],
      displayName: map['displayName'],
      email: map['email'],
    );
  }

  @override
  String toString() {
    return 'CustomUser(uid: $uid, photoUrl: $photoUrl, displayName: $displayName, email: $email)';
  }
}
