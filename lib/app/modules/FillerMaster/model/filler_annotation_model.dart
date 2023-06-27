class FillerMasterAnnotationModel {
  int? rowno;
  int? eventId;
  String? eventname;
  String? tCin;
  String? tCout;

  FillerMasterAnnotationModel({this.rowno, this.eventId, this.eventname, this.tCin, this.tCout});

  FillerMasterAnnotationModel.fromJson(Map<String, dynamic> json) {
    rowno = json['rowno'];
    eventId = json['eventId'];
    eventname = json['eventname'];
    tCin = json['tCin'];
    tCout = json['tCout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['rowno'] = this.rowno;
    // data['eventId'] = this.eventId;
    // data['eventname'] = this.eventname;
    // data['tCin'] = this.tCin;
    // data['tCout'] = this.tCout;
    data['eventName'] = eventname;
    data['tcIn'] = tCin;
    data['tcOut'] = tCout;
    return data;
  }
}
