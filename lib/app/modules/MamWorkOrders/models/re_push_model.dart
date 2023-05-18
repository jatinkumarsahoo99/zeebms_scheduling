class REPushModel {
  ProgramResponse? programResponse;

  REPushModel({this.programResponse});

  REPushModel.fromJson(Map<String, dynamic> json) {
    programResponse = json['program_Response'] != null ? ProgramResponse.fromJson(json['program_Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (programResponse != null) {
      data['program_Response'] = programResponse!.toJson();
    }
    return data;
  }
}

class ProgramResponse {
  List<String>? allowColumnsEditing;
  List<String>? dataGridViewContentAlignment;
  List<LstResendWorkOrders>? lstResendWorkOrders;

  ProgramResponse({this.allowColumnsEditing, this.dataGridViewContentAlignment, this.lstResendWorkOrders});

  ProgramResponse.fromJson(Map<String, dynamic> json) {
    if (json['allowColumnsEditing'] != null) {
      allowColumnsEditing = (json['allowColumnsEditing'] as List<dynamic>).cast<String>();
    }
    if (json['dataGridViewContentAlignment'] != null) {
      dataGridViewContentAlignment = (json['dataGridViewContentAlignment'] as List<dynamic>).cast<String>();
    }
    if (json['lstResendWorkOrders'] != null) {
      lstResendWorkOrders = <LstResendWorkOrders>[];
      json['lstResendWorkOrders'].forEach((v) {
        lstResendWorkOrders!.add(LstResendWorkOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowColumnsEditing'] = allowColumnsEditing;
    data['dataGridViewContentAlignment'] = dataGridViewContentAlignment;
    if (lstResendWorkOrders != null) {
      data['lstResendWorkOrders'] = lstResendWorkOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstResendWorkOrders {
  bool? resend;
  String? woStatus;
  String? location;
  String? channel;
  int? woId;
  String? program;
  int? episodeNo;
  String? telecastType;
  String? tapeId;
  String? telecastDate;
  String? telecastTime;
  String? vendor;
  String? contentType;
  String? language;
  int? segmentCount;
  String? jason;

  LstResendWorkOrders(
      {this.resend,
      this.woStatus,
      this.location,
      this.channel,
      this.woId,
      this.program,
      this.episodeNo,
      this.telecastType,
      this.tapeId,
      this.telecastDate,
      this.telecastTime,
      this.vendor,
      this.contentType,
      this.language,
      this.segmentCount,
      this.jason});

  LstResendWorkOrders.fromJson(Map<String, dynamic> json) {
    resend = json['resend'];
    woStatus = json['woStatus'];
    location = json['location'];
    channel = json['channel'];
    woId = json['woId'];
    program = json['program'];
    episodeNo = json['episodeNo'];
    telecastType = json['telecastType'];
    tapeId = json['tapeId'];
    telecastDate = json['telecastDate'];
    telecastTime = json['telecastTime'];
    vendor = json['vendor'];
    contentType = json['contentType'];
    language = json['language'];
    segmentCount = json['segmentCount'];
    jason = json['jason'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
    } else {
      data['resend'] = resend.toString();
      data['woStatus'] = woStatus;
      data['location'] = location;
      data['channel'] = channel;
      data['woId'] = woId;
      data['program'] = program;
      data['episodeNo'] = episodeNo;
      data['telecastType'] = telecastType;
      data['tapeId'] = tapeId;
      data['telecastDate'] = telecastDate;
      data['telecastTime'] = telecastTime;
      data['vendor'] = vendor;
      data['contentType'] = contentType;
      data['language'] = language;
      data['segmentCount'] = segmentCount;
      data['jason'] = jason;
    }
    return data;
  }
}
