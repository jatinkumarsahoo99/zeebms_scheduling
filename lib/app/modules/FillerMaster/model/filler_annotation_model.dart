class FillerMasterAnnotationModel {
  String? eventID;
  String? eventName;
  String? tCIn;
  String? tCOut;

  FillerMasterAnnotationModel({this.eventID, this.eventName, this.tCIn, this.tCOut});

  FillerMasterAnnotationModel.fromJson(Map<String, dynamic> json) {
    eventID = json['EventID'];
    eventName = json['EventName'];
    tCIn = json['TCIn'];
    tCOut = json['TCOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventID'] = this.eventID;
    data['EventName'] = this.eventName;
    data['TCIn'] = this.tCIn;
    data['TCOut'] = this.tCOut;
    return data;
  }
}
