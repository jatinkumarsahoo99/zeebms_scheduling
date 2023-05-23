class WOAPDFPCModel {
  ProgramResponse? programResponse;

  WOAPDFPCModel({this.programResponse});

  WOAPDFPCModel.fromJson(Map<String, dynamic> json) {
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
  String? strMessage;
  List<String>? allowColumnsEditing;
  List<String>? columnNotVisiable;
  List<DailyFpc>? dailyFpc;

  ProgramResponse({this.strMessage, this.allowColumnsEditing, this.columnNotVisiable, this.dailyFpc});

  ProgramResponse.fromJson(Map<String, dynamic> json) {
    if (json['dailyFpc'] != null) {
      dailyFpc = <DailyFpc>[];
      json['dailyFpc'].forEach((v) {
        dailyFpc!.add(DailyFpc.fromJson(v));
      });
    }
    if (json['strMessage'] != null) {
      strMessage = json['strMessage'];
    }
    if (json['allowColumnsEditing'] != null) {
      allowColumnsEditing = (json['allowColumnsEditing'] as List<dynamic>).cast<String>();
    }
    if (json['columnNotVisiable'] != null) {
      columnNotVisiable = (json['columnNotVisiable'] as List<dynamic>).cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['strMessage'] = strMessage;
    data['allowColumnsEditing'] = allowColumnsEditing;
    data['columnNotVisiable'] = columnNotVisiable;
    if (dailyFpc != null) {
      data['dailyFpc'] = dailyFpc!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyFpc {
  bool? release;
  String? program;
  num? episode;
  String? originalRepeatName;
  String? telecastTime;
  String? tapeId;
  int? totalSegments;
  int? programCode;
  String? bmsProgramCode;
  String? rmsProgramName;
  String? originalRepeatCode;
  String? quality;

  DailyFpc(
      {this.release,
      this.program,
      this.episode,
      this.originalRepeatName,
      this.telecastTime,
      this.tapeId,
      this.totalSegments,
      this.programCode,
      this.bmsProgramCode,
      this.rmsProgramName,
      this.originalRepeatCode,
      this.quality});

  DailyFpc.fromJson(Map<String, dynamic> json) {
    release = json['release'];
    program = json['program'];
    episode = json['episode'];
    originalRepeatName = json['originalRepeatName'];
    telecastTime = json['telecastTime'];
    tapeId = json['tapeId'];
    totalSegments = json['totalSegments'];
    programCode = json['programCode'];
    bmsProgramCode = json['bmsProgramCode'];
    rmsProgramName = json['rmsProgramName'];
    originalRepeatCode = json['originalRepeatCode'];
    quality = json['quality'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['release'] = (release ?? false);
      data['program'] = program;
      data['episode'] = episode;
      data['originalRepeatName'] = originalRepeatName;
      data['telecastTime'] = telecastTime;
      data['tapeId'] = tapeId;
      data['totalSegments'] = totalSegments;
      data['programCode'] = programCode;
      data['bmsProgramCode'] = bmsProgramCode;
      data['rmsProgramName'] = rmsProgramName;
      data['originalRepeatCode'] = originalRepeatCode;
      data['quality'] = quality;
    } else {
      data['release'] = release.toString();
      data['program'] = program;
      data['episode'] = episode ?? '';
      data['originalRepeatName'] = originalRepeatName;
      data['telecastTime'] = telecastTime;
      data['tapeId'] = tapeId;
      data['totalSegments'] = totalSegments;
      data['programCode'] = programCode;
      data['bmsProgramCode'] = bmsProgramCode;
      data['rmsProgramName'] = rmsProgramName;
      data['originalRepeatCode'] = originalRepeatCode;
      data['quality'] = quality;
    }
    return data;
  }
}
