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
    if (fromSave) {
      data['release'] = release == true ? 0 : 1;
      data['contentTypeId'] = contentTypeId.toString();
      data['contentFormatId'] = contentFormatId.toString();
      data['vendorCode'] = vendorCode.toString();
      data['languageCode'] = languageCode.toString();
      data['segmented'] = segmented == true ? 1.toString() : 0.toString();
      data['timeCodeRequired'] = timeCodeRequired == true ? 1.toString() : 0.toString();
      data['requireApproval'] = requireApproval == true ? 1.toString() : 0.toString();
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
    return data;
  }
}
