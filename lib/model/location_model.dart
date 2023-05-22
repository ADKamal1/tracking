class LocationModel {
  double? lat;
  double? lon;
  String? time;
  String? description;
  String? id;
  String? userId;
  String? date;
  String? note;
  String? image;
  String? userName;
  bool? isMocking;
  String ? address;
  dynamic version;

  LocationModel(
      {required this.lat,
      required this.lon,
      required this.note,
      required this.time,
      required this.id,
      required this.userName,
        required this.address,
      required this.userId,
      required this.description,
      required this.image,
      this.version = 2,
      required this.isMocking,
      required this.date});

  LocationModel.fromJson(Map<String, dynamic> json) {
    note = json["note"];
    lat = json["lat"];
    lon = json["lon"];
    time = json["time"];
    id = json["id"];
    userId = json["userId"];
    description = json["description"];
    date = json["date"];
    image = json["image"];
    isMocking = json["isMocking"];
    version = json['version'];
    userName = json["userName"];
    address = json["address"];
  }

  Map<String, dynamic> toMap() {
    return {
      "note": note,
      "lat": lat,
      "lon": lon,
      "time": time,
      "id": id,
      "userId": userId,
      "date": date,
      "description": description,
      "image": image,
      "isMocking": isMocking,
      "userName": userName,
      "version": version,
      "address": address,
    };
  }
}
