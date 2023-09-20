class NonFPCWOModel {
  bool? release;
  String? contentTypeName;
  String? contentFormat;
  String? vendor;
  String? languageName;
  bool? segmented;
  bool? timeCodeRequired;
  bool? requireApproval;
  int? contentTypeId;
  int? contentFormatId;
  int? vendorCode;
  int? languageCode;

  NonFPCWOModel(
      {this.release,
      this.contentTypeName,
      this.contentFormat,
      this.vendor,
      this.languageName,
      this.segmented,
      this.timeCodeRequired,
      this.requireApproval,
      this.contentTypeId,
      this.contentFormatId,
      this.vendorCode,
      this.languageCode});

  NonFPCWOModel.fromJson(Map<String, dynamic> json) {
    release = json['release'];
    contentTypeName = json['contentTypeName'];
    contentFormat = json['contentFormat'];
    vendor = json['vendor'];
    languageName = json['languageName'];
    segmented = json['segmented'];
    timeCodeRequired = json['timeCodeRequired'];
    requireApproval = json['requireApproval'];
    contentTypeId = json['contentTypeId'];
    contentFormatId = json['contentFormatId'];
    vendorCode = json['vendorCode'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    try {
      if (fromSave) {
        data['release'] = release == true ? 0 : 1;
        data['contentTypeId'] = contentTypeId.toString();
        data['contentFormatId'] = contentFormatId.toString();
        data['vendorCode'] = vendorCode.toString();
        data['languageCode'] = languageCode.toString();
        data['segmented'] = segmented == true ? 1.toString() : 0.toString();
        data['timeCodeRequired'] =
            timeCodeRequired == true ? 1.toString() : 0.toString();
        data['requireApproval'] =
            requireApproval == true ? 1.toString() : 0.toString();
      } else {
        data['release'] = release.toString();
        data['contentTypeName'] = contentTypeName;
        data['contentFormat'] = contentFormat;
        data['vendor'] = vendor;
        data['languageName'] = languageName;
        data['segmented'] = segmented.toString();
        data['timeCodeRequired'] = timeCodeRequired.toString();
        data['requireApproval'] = requireApproval.toString();
        data['contentTypeId'] = contentTypeId;
        data['contentFormatId'] = contentFormatId;
        data['vendorCode'] = vendorCode;
        data['languageCode'] = languageCode;
      }
    } catch (e) {
      print(e.toString());
    }
    return data;
  }
}

class ReleaseWoNonFPCMultipleSegmensModel {
  InfoLeaveTelecast? infoLeaveTelecast;

  ReleaseWoNonFPCMultipleSegmensModel({this.infoLeaveTelecast});

  ReleaseWoNonFPCMultipleSegmensModel.fromJson(Map<String, dynamic> json) {
    infoLeaveTelecast = json['infoLeaveTelecast'] != null
        ? InfoLeaveTelecast.fromJson(json['infoLeaveTelecast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (infoLeaveTelecast != null) {
      data['infoLeaveTelecast'] = infoLeaveTelecast!.toJson();
    }
    return data;
  }
}

class InfoLeaveTelecast {
  String? message;
  String? txId;
  bool? bMET;
  List<LstEpisodeDetails>? lstEpisodeDetails;

  InfoLeaveTelecast({this.message, this.txId, this.lstEpisodeDetails});

  InfoLeaveTelecast.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    bMET = json['bMET'];
    txId = json['txId'];
    if (json['lstEpisodeDetails'] != null) {
      lstEpisodeDetails = <LstEpisodeDetails>[];
      json['lstEpisodeDetails'].forEach((v) {
        lstEpisodeDetails!.add(LstEpisodeDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['txId'] = txId;
    if (lstEpisodeDetails != null) {
      data['lstEpisodeDetails'] =
          lstEpisodeDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstEpisodeDetails {
  int? epsNo;
  String? telecastDate;
  String? telecastTime;
  String? exportTapeCode;

  LstEpisodeDetails(
      {this.epsNo, this.telecastDate, this.telecastTime, this.exportTapeCode});

  LstEpisodeDetails.fromJson(Map<String, dynamic> json) {
    epsNo = json['epsNo'];
    telecastDate = json['telecastDate'];
    telecastTime = json['telecastTime'];
    exportTapeCode = json['exportTapeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['epsNo'] = epsNo;
    data['telecastDate'] = telecastDate;
    data['telecastTime'] = telecastTime;
    data['exportTapeCode'] = exportTapeCode;
    return data;
  }
}
