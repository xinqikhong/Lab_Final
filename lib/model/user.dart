class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? datereg;
  /*String? phone;
  String? address;
  String? otp;*/
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.datereg,});
      /*required this.phone,
      required this.address,
      required this.otp});*/
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    datereg = json['datereg'];
    /*phone = json['phone'];
    address = json['address'];
    otp = json['otp'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['datereg'] = datereg;
    return data;
  }
}