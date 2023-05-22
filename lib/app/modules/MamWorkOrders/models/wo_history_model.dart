class WOHistoryModel {
  String? woStatus;
  String? locationName;
  String? channelName;
  String? programName;
  int? episodeNumber;
  String? oRiginalRepeatName;
  String? telecastId;
  String? telecastDate;
  String? telecastTime;
  String? vendorName;
  String? contentTypeName;
  String? languageName;
  int? segmentCount;
  String? releaseDate;
  String? releaseTime;
  String? releaseBy;

  WOHistoryModel(
      {this.woStatus,
      this.locationName,
      this.channelName,
      this.programName,
      this.episodeNumber,
      this.oRiginalRepeatName,
      this.telecastId,
      this.telecastDate,
      this.telecastTime,
      this.vendorName,
      this.contentTypeName,
      this.languageName,
      this.segmentCount,
      this.releaseDate,
      this.releaseTime,
      this.releaseBy});

  WOHistoryModel.fromJson(Map<String, dynamic> json) {
    woStatus = json['woStatus'];
    locationName = json['locationName'];
    channelName = json['channelName'];
    programName = json['programName'];
    episodeNumber = json['episodeNumber'];
    oRiginalRepeatName = json['oRiginalRepeatName'];
    telecastId = json['telecastId'];
    telecastDate = json['telecastDate'];
    telecastTime = json['telecastTime'];
    vendorName = json['vendorName'];
    contentTypeName = json['contentTypeName'];
    languageName = json['languageName'];
    segmentCount = json['segmentCount'];
    releaseDate = json['releaseDate'];
    releaseTime = json['releaseTime'];
    releaseBy = json['releaseBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['woStatus'] = woStatus;
    data['locationName'] = locationName;
    data['channelName'] = channelName;
    data['programName'] = programName;
    data['episodeNumber'] = episodeNumber;
    data['oRiginalRepeatName'] = oRiginalRepeatName;
    data['telecastId'] = telecastId;
    data['telecastDate'] = telecastDate;
    data['telecastTime'] = telecastTime;
    data['vendorName'] = vendorName;
    data['contentTypeName'] = contentTypeName;
    data['languageName'] = languageName;
    data['segmentCount'] = segmentCount;
    data['releaseDate'] = releaseDate;
    data['releaseTime'] = releaseTime;
    data['releaseBy'] = releaseBy;
    return data;
  }
}
