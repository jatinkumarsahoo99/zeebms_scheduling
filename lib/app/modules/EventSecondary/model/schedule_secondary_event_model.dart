class ScheduleSecondaryEventModel {
  List<DetailResponse>? detailResponse;
  List<SegementsResponse>? segementsResponse;

  ScheduleSecondaryEventModel({this.detailResponse, this.segementsResponse});

  ScheduleSecondaryEventModel.fromJson(Map<String, dynamic> json) {
    if (json['detailResponse'] != null) {
      detailResponse = <DetailResponse>[];
      json['detailResponse'].forEach((v) {
        detailResponse!.add(new DetailResponse.fromJson(v));
      });
    }
    if (json['segementsResponse'] != null) {
      segementsResponse = <SegementsResponse>[];
      json['segementsResponse'].forEach((v) {
        segementsResponse!.add(new SegementsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (detailResponse != null) {
      data['detailResponse'] = detailResponse!.map((v) => v.toJson()).toList();
    }
    if (segementsResponse != null) {
      data['segementsResponse'] = segementsResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DetailResponse {
  String? startTime;
  String? programName;
  int? episodeNumber;
  String? tapeId;
  String? programCode;
  int? promoCap;
  int? episodeDuration;

  DetailResponse({this.startTime, this.programName, this.episodeNumber, this.tapeId, this.programCode, this.promoCap, this.episodeDuration});

  DetailResponse.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    programName = json['programName'];
    episodeNumber = json['episodeNumber'];
    tapeId = json['tapeId'];
    programCode = json['programCode'];
    promoCap = json['promoCap'];
    episodeDuration = json['episodeDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = startTime;
    data['programName'] = programName;
    data['episodeNumber'] = episodeNumber;
    data['tapeId'] = tapeId;
    data['programCode'] = programCode;
    data['promoCap'] = promoCap;
    data['episodeDuration'] = episodeDuration;
    return data;
  }
}

class SegementsResponse {
  String? eventCaption;
  int? breakNo;
  String? eventDuration;
  String? houseId;
  String? telecastTime;
  int? eventCode;
  int? eventSchedulingCode;
  int? rowNo;

  SegementsResponse(
      {this.eventCaption, this.breakNo, this.eventDuration, this.houseId, this.telecastTime, this.eventCode, this.eventSchedulingCode, this.rowNo});

  SegementsResponse.fromJson(Map<String, dynamic> json) {
    eventCaption = json['eventCaption'];
    breakNo = json['breakNo'];
    eventDuration = json['eventDuration'];
    houseId = json['houseId'];
    telecastTime = json['telecastTime'];
    eventCode = json['eventCode'];
    eventSchedulingCode = json['eventSchedulingCode'];
    rowNo = json['rowNo'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (fromSave) {
      data['breakNo'] = breakNo;
      data['eventCaption'] = "";
      data['telecastTime'] = telecastTime;
      data['eventCode'] = (eventCode == null || eventCode == 0) ? "" : eventCode.toString();
      data['rowNo'] = rowNo == null ? "" : rowNo.toString();
      // data['eventDuration'] = eventDuration;
      // data['houseId'] = houseId;
      // data['eventSchedulingCode'] = eventSchedulingCode;
    } else {
      data['eventCaption'] = eventCaption;
      data['breakNo'] = breakNo;
      data['eventDuration'] = eventDuration;
      data['houseId'] = houseId;
      data['telecastTime'] = telecastTime;
      data['eventCode'] = eventCode;
      data['eventSchedulingCode'] = eventSchedulingCode;
      // data['rowNo'] = rowNo;
    }
    return data;
  }
}
