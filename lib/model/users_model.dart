import '../shared/helper/mangers/constants.dart';

class UserModel {
  String? id;
  String? username;
  String? searchName;
  String? email;
  String? password;
  String? phone;
  String? info;
  bool? isOnline;
  bool? isMocking;
  dynamic? lat;
  dynamic? lon;
  String? image;
  String? token;
  bool? isActive;
  dynamic ? ver;

  UserModel(
      {this.id = ConstantsManger.DEFULT,
      this.image = ConstantsManger.DEFULT,
      this.username,
      this.token,
      this.email,
        required this.searchName,
      this.password,
      this.phone,
        this.info,
      this.isOnline = false,
      this.isMocking = false,
      this.isActive = true,
      this.lat,
        this.ver,
      this.lon});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    username = json['username'];
    token = json['token'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    isOnline = json['isOnline'];
    ver = json['ver'];
    info = json['info'];
    isMocking = json['isMocking'];
    searchName = json['searchName'];
    lat = json['lat'];
    lon = json['lon'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "image": image,
      "token": token,
      "username": username,
      "email": email,
      "password": password,
      "phone": phone,
      "isOnline": isOnline,
      "isMocking": isMocking,
      "lat": lat,
      "lon": lon,
      "info": info,
      "isActive": isActive,
      "searchName": searchName,
      "ver": ver,
    };
  }
}
