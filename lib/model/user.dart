class User {
  String? id;
  String? name;
  String? email;
  String? password;
  /*String? phone;
  String? address;
  String? regdate;
  String? otp;*/
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});
      /*required this.phone,
      required this.address,
      required this.regdate,
      required this.otp});*/
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    /*phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    otp = json['otp'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    return data;
  }
}