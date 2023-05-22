class OnlineReport{
  String ? id;
  bool ? isOnline;
  String ? time;
  String ? date;

  OnlineReport({required this.id,required this.isOnline,required this.time,required this.date});

  OnlineReport.fromJson(Map<String ,dynamic> json){
    id = json["id"];
    isOnline = json["isOnline"];
    time = json["time"];
    date = json["date"];
  }
  Map<String , dynamic> toMap(){
    return {
      "id":id,
      "isOnline":isOnline,
      "time":time,
      "date":date,
    };
  }
}