class SocialUser {
  late String uId;
  late String name;
  late String email;
  late String phone;
  SocialUser({
    required this.uId,
    required this.name,
    required this.email,
    required this.phone,
  });
  SocialUser.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
