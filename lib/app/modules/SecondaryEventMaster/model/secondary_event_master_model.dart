class SecondaryEventModel {
  List<Display>? display;

  SecondaryEventModel({this.display});

  SecondaryEventModel.fromJson(Map<String, dynamic> json) {
    if (json['display'] != null) {
      display = <Display>[];
      json['display'].forEach((v) {
        display!.add(Display.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (display != null) {
      data['display'] = display!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Display {
  int? eventCode;
  String? eventCaption;
  String? tXcaption;
  String? locationCode;
  String? channelCode;
  String? houseID;
  String? som;
  int? duration;
  String? startDate;
  String? killDate;
  String? killTime;
  String? modifiedby;
  String? modifiedon;

  Display(
      {this.eventCode,
      this.eventCaption,
      this.tXcaption,
      this.locationCode,
      this.channelCode,
      this.houseID,
      this.som,
      this.duration,
      this.startDate,
      this.killDate,
      this.killTime,
      this.modifiedby,
      this.modifiedon});

  Display.fromJson(Map<String, dynamic> json) {
    eventCode = json['eventCode'];
    eventCaption = json['eventCaption'];
    tXcaption = json['tXcaption'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    houseID = json['houseID'];
    som = json['som'];
    duration = json['duration'];
    startDate = json['startDate'];
    killDate = json['killDate'];
    killTime = json['killTime'];
    modifiedby = json['modifiedby'];
    modifiedon = json['modifiedon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventCode'] = eventCode;
    data['eventCaption'] = eventCaption;
    data['tXcaption'] = tXcaption;
    data['locationCode'] = locationCode;
    data['channelCode'] = channelCode;
    data['houseID'] = houseID;
    data['som'] = som;
    data['duration'] = duration;
    data['startDate'] = startDate;
    data['killDate'] = killDate;
    data['killTime'] = killTime;
    data['modifiedby'] = modifiedby;
    data['modifiedon'] = modifiedon;
    return data;
  }
}
