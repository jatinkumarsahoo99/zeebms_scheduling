class ReschedulngInitData {
  String? timeFormat;
  String? today;
  String? tdate;
  String? nextday;
  bool? txtReference;
  String? bookingMonth;
  List<LstlocationMaters>? lstlocationMaters;
  List<LstspotPositionTypeMasters>? lstspotPositionTypeMasters;
  List<LstPositionMaster>? lstPositionMaster;

  ReschedulngInitData(
      {this.timeFormat,
      this.today,
      this.tdate,
      this.nextday,
      this.txtReference,
      this.bookingMonth,
      this.lstlocationMaters,
      this.lstspotPositionTypeMasters,
      this.lstPositionMaster});

  ReschedulngInitData.fromJson(Map<String, dynamic> json) {
    timeFormat = json['timeFormat'];
    today = json['today'];
    tdate = json['tdate'];
    nextday = json['nextday'];
    txtReference = json['txtReference'];
    bookingMonth = json['bookingMonth'];
    if (json['lstlocationMaters'] != null) {
      lstlocationMaters = <LstlocationMaters>[];
      json['lstlocationMaters'].forEach((v) {
        lstlocationMaters!.add(LstlocationMaters.fromJson(v));
      });
    }
    if (json['lstspotPositionTypeMasters'] != null) {
      lstspotPositionTypeMasters = <LstspotPositionTypeMasters>[];
      json['lstspotPositionTypeMasters'].forEach((v) {
        lstspotPositionTypeMasters!.add(LstspotPositionTypeMasters.fromJson(v));
      });
    }
    if (json['lstPositionMaster'] != null) {
      lstPositionMaster = <LstPositionMaster>[];
      json['lstPositionMaster'].forEach((v) {
        lstPositionMaster!.add(LstPositionMaster.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeFormat'] = timeFormat;
    data['today'] = today;
    data['tdate'] = tdate;
    data['nextday'] = nextday;
    data['txtReference'] = txtReference;
    data['bookingMonth'] = bookingMonth;
    if (lstlocationMaters != null) {
      data['lstlocationMaters'] = lstlocationMaters!.map((v) => v.toJson()).toList();
    }
    if (lstspotPositionTypeMasters != null) {
      data['lstspotPositionTypeMasters'] = lstspotPositionTypeMasters!.map((v) => v.toJson()).toList();
    }
    if (lstPositionMaster != null) {
      data['lstPositionMaster'] = lstPositionMaster!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstlocationMaters {
  String? locationCode;
  String? locationName;

  LstlocationMaters({this.locationCode, this.locationName});

  LstlocationMaters.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    locationName = json['locationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationCode'] = locationCode;
    data['locationName'] = locationName;
    return data;
  }
}

class LstspotPositionTypeMasters {
  String? spotPositionTypeCode;
  String? spotPositionTypeName;

  LstspotPositionTypeMasters({this.spotPositionTypeCode, this.spotPositionTypeName});

  LstspotPositionTypeMasters.fromJson(Map<String, dynamic> json) {
    spotPositionTypeCode = json['spotPositionTypeCode'];
    spotPositionTypeName = json['spotPositionTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['spotPositionTypeCode'] = spotPositionTypeCode;
    data['spotPositionTypeName'] = spotPositionTypeName;
    return data;
  }
}

class LstPositionMaster {
  String? positionCode;
  String? positionName;

  LstPositionMaster({this.positionCode, this.positionName});

  LstPositionMaster.fromJson(Map<String, dynamic> json) {
    positionCode = json['positionCode'];
    positionName = json['positionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['positionCode'] = positionCode;
    data['positionName'] = positionName;
    return data;
  }
}
