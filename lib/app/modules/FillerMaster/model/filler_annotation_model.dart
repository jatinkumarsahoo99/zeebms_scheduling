class FillerMasterAnnotationModel {
  String? eventID;
  String? eventName;
  String? tCIn;
  String? tCOut;

  FillerMasterAnnotationModel({this.eventID, this.eventName, this.tCIn, this.tCOut});

  FillerMasterAnnotationModel.fromJson(Map<String, dynamic> json) {
    eventID = json['EventID'];
    eventName = json['eventName'];
    tCIn = json['TCin'];
    tCOut = json['TCout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['EventID'] = this.eventID;
    data['eventName'] = this.eventName;
    data['tcIn'] = this.tCIn;
    data['tcOut'] = this.tCOut;
    return data;
  }
}
