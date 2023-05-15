class SalesAuditNotTelecastModel {
  int? mediaClipId;
  String? locationCode;
  String? channelCode;
  String? clipType;
  int? programCode;
  String? lookupName;
  String? clipId;
  String? locationName;
  String? channelName;

  SalesAuditNotTelecastModel(
      {this.mediaClipId,
        this.locationCode,
        this.channelCode,
        this.clipType,
        this.programCode,
        this.lookupName,
        this.clipId,
        this.locationName,
        this.channelName});

  SalesAuditNotTelecastModel.fromJson(Map<String, dynamic> json) {
    mediaClipId = json['mediaClipId'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    clipType = json['clipType'];
    programCode = json['programCode'];
    lookupName = json['lookupName'];
    clipId = json['clipId'];
    locationName = json['locationName'];
    channelName = json['channelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaClipId'] = this.mediaClipId;
    data['locationCode'] = this.locationCode;
    data['channelCode'] = this.channelCode;
    data['clipType'] = this.clipType;
    data['programCode'] = this.programCode;
    data['lookupName'] = this.lookupName;
    data['clipId'] = this.clipId;
    data['locationName'] = this.locationName;
    data['channelName'] = this.channelName;
    return data;
  }
  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['mediaClipId'] = this.mediaClipId;
    // data['locationCode'] = this.locationCode;
    // data['channelCode'] = this.channelCode;
    // data['clipType'] = this.clipType;
    // data['programCode'] = this.programCode;
    data['Lookup Name'] = this.lookupName;
    data['Clip Id'] = this.clipId;
    data['Location Name'] = this.locationName;
    data['Channel Name'] = this.channelName;
    return data;
  }
}
