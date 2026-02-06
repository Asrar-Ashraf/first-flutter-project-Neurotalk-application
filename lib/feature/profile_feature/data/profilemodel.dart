// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Profilemodel {
  String? userName;
  String? userEmail;
  Profilemodel({this.userName, this.userEmail});

  Profilemodel copyWith({String? userName, String? userEmail}) {
    return Profilemodel(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'userName': userName, 'userEmail': userEmail};
  }

  factory Profilemodel.fromMap(Map<String, dynamic> map) {
    return Profilemodel(
      userName: map['userName'] != null ? map['userName'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profilemodel.fromJson(String source) =>
      Profilemodel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Profilemodel(userName: $userName, userEmail: $userEmail)';

  @override
  bool operator ==(covariant Profilemodel other) {
    if (identical(this, other)) return true;

    return other.userName == userName && other.userEmail == userEmail;
  }

  @override
  int get hashCode => userName.hashCode ^ userEmail.hashCode;
}
