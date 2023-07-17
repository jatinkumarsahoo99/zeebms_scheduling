class ManageChannelInventory {
  ManageChannelInventory({
    this.telecastDate,
    this.telecastTime,
    this.programName,
    this.programTypeName,
    this.originalRepeatName,
    this.episodeDuration,
    this.commDuration,
    this.locationCode,
    this.channelCode,
    this.programCode,
  });
  String? telecastDate;
  String? telecastTime;
  String? programName;
  String? programTypeName;
  String? originalRepeatName;
  num? episodeDuration;
  num? commDuration;
  String? locationCode;
  String? channelCode;
  String? programCode;

  ManageChannelInventory.fromJson(Map<String, dynamic> json) {
    telecastDate = json['telecastDate'];
    telecastTime = json['telecastTime'];
    programName = json['programName'];
    programTypeName = json['programTypeName'];
    originalRepeatName = json['originalRepeatName'];
    episodeDuration = json['episodeDuration'];
    commDuration = json['commDuration'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    programCode = json['programCode'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final _data = <String, dynamic>{};
    if (fromSave) {
      _data['telecastDate'] = telecastDate;
      _data['telecastTime'] = telecastTime;
      _data['commDuration'] = commDuration;
      _data['locationCode'] = locationCode;
      _data['channelCode'] = channelCode;
      _data['programName'] = programName;
      _data['programCode'] = programCode;
      // _data['programTypeName'] = programTypeName;
      // _data['originalRepeatName'] = originalRepeatName;
      // _data['episodeDuration'] = episodeDuration;
    } else {
      _data['telecastDate'] = telecastDate;
      _data['telecastTime'] = telecastTime;
      _data['programName'] = programName;
      _data['programTypeName'] = programTypeName;
      _data['originalRepeatName'] = originalRepeatName;
      _data['episodeDuration'] = episodeDuration;
      _data['commDuration'] = commDuration;
      _data['locationCode'] = locationCode;
      _data['channelCode'] = channelCode;
      _data['programCode'] = programCode;
    }
    return _data;
  }
}
