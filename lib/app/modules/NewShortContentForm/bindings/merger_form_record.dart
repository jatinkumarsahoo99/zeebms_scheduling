class NewMergeFormRecord {
  Null? stillCode;
  Null? stillCaption;
  Null? programCode;
  String? exportTapeCaption;
  String? exportTapeCode;
  int? segmentNumber;
  Null? stillDuration;
  String? houseId;
  String? som;
  String? tapeTypeCode;
  String? dated;
  String? killDate;
  String? modifiedBy;
  String? locationcode;
  String? channelcode;
  Null? eom;
  int? stillType;
  int? slideCode;
  String? slideCaption;
  Null? segmentNumberSL;
  String? slideType;
  int? exportTapeDuration;
  Null? vignetteCode;
  Null? vignetteCaption;
  Null? vignetteDuration;
  Null? exportTapeCodeVG;
  Null? originalRepeatCode;
  Null? segmentNumberVG;
  Null? startDate;
  Null? remarks;
  Null? billflag;
  String? companycode;

  NewMergeFormRecord(
      {this.stillCode,
      this.stillCaption,
      this.programCode,
      this.exportTapeCaption,
      this.exportTapeCode,
      this.segmentNumber,
      this.stillDuration,
      this.houseId,
      this.som,
      this.tapeTypeCode,
      this.dated,
      this.killDate,
      this.modifiedBy,
      this.locationcode,
      this.channelcode,
      this.eom,
      this.stillType,
      this.slideCode,
      this.slideCaption,
      this.segmentNumberSL,
      this.slideType,
      this.exportTapeDuration,
      this.vignetteCode,
      this.vignetteCaption,
      this.vignetteDuration,
      this.exportTapeCodeVG,
      this.originalRepeatCode,
      this.segmentNumberVG,
      this.startDate,
      this.remarks,
      this.billflag,
      this.companycode});

  NewMergeFormRecord.fromJson(Map<String, dynamic> json) {
    stillCode = json['stillCode'];
    stillCaption = json['stillCaption'];
    programCode = json['programCode'];
    exportTapeCaption = json['exportTapeCaption'];
    exportTapeCode = json['exportTapeCode'];
    segmentNumber = json['segmentNumber'];
    stillDuration = json['stillDuration'];
    houseId = json['houseId'];
    som = json['som'];
    tapeTypeCode = json['tapeTypeCode'];
    dated = json['dated'];
    killDate = json['killDate'];
    modifiedBy = json['modifiedBy'];
    locationcode = json['locationcode'];
    channelcode = json['channelcode'];
    eom = json['eom'];
    stillType = json['stillType'];
    slideCode = json['slideCode'];
    slideCaption = json['slideCaption'];
    segmentNumberSL = json['segmentNumber_SL'];
    slideType = json['slideType'];
    exportTapeDuration = json['exportTapeDuration'];
    vignetteCode = json['vignetteCode'];
    vignetteCaption = json['vignetteCaption'];
    vignetteDuration = json['vignetteDuration'];
    exportTapeCodeVG = json['exportTapeCode_VG'];
    originalRepeatCode = json['originalRepeatCode'];
    segmentNumberVG = json['segmentNumber_VG'];
    startDate = json['startDate'];
    remarks = json['remarks'];
    billflag = json['billflag'];
    companycode = json['companycode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stillCode'] = this.stillCode;
    data['stillCaption'] = this.stillCaption;
    data['programCode'] = this.programCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['exportTapeCode'] = this.exportTapeCode;
    data['segmentNumber'] = this.segmentNumber;
    data['stillDuration'] = this.stillDuration;
    data['houseId'] = this.houseId;
    data['som'] = this.som;
    data['tapeTypeCode'] = this.tapeTypeCode;
    data['dated'] = this.dated;
    data['killDate'] = this.killDate;
    data['modifiedBy'] = this.modifiedBy;
    data['locationcode'] = this.locationcode;
    data['channelcode'] = this.channelcode;
    data['eom'] = this.eom;
    data['stillType'] = this.stillType;
    data['slideCode'] = this.slideCode;
    data['slideCaption'] = this.slideCaption;
    data['segmentNumber_SL'] = this.segmentNumberSL;
    data['slideType'] = this.slideType;
    data['exportTapeDuration'] = this.exportTapeDuration;
    data['vignetteCode'] = this.vignetteCode;
    data['vignetteCaption'] = this.vignetteCaption;
    data['vignetteDuration'] = this.vignetteDuration;
    data['exportTapeCode_VG'] = this.exportTapeCodeVG;
    data['originalRepeatCode'] = this.originalRepeatCode;
    data['segmentNumber_VG'] = this.segmentNumberVG;
    data['startDate'] = this.startDate;
    data['remarks'] = this.remarks;
    data['billflag'] = this.billflag;
    data['companycode'] = this.companycode;
    return data;
  }
}
