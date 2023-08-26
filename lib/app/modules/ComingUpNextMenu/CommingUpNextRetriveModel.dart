class CommingUpNextRetriveModel {
  String? cunCode;
  String? channelCode;
  String? houseID;
  String? exportTapeCode;
  String? programCode;
  String? programTypeCode;
  String? originalRepeatCode;
  String? exportTapeCaption;
  int? segmentNumber;
  int? slideDuration;
  String? som;
  String? activeNonActive;
  String? dated;
  String? killDate;
  String? modifiedBy;
  String? locationCode;
  String? eom;

  CommingUpNextRetriveModel(
      {this.cunCode,
        this.channelCode,
        this.houseID,
        this.exportTapeCode,
        this.programCode,
        this.programTypeCode,
        this.originalRepeatCode,
        this.exportTapeCaption,
        this.segmentNumber,
        this.slideDuration,
        this.som,
        this.activeNonActive,
        this.dated,
        this.killDate,
        this.modifiedBy,
        this.locationCode,
        this.eom});

  CommingUpNextRetriveModel.fromJson(Map<String, dynamic> json) {
    cunCode = (json['cunCode']??json['cutCode']??"").toString();
    channelCode = json['channelCode'];
    houseID = json['houseID'];
    exportTapeCode = json['exportTapeCode'];
    programCode = json['programCode'];
    programTypeCode = json['programTypeCode'];
    originalRepeatCode = json['originalRepeatCode'];
    exportTapeCaption = json['exportTapeCaption'];
    segmentNumber = json['segmentNumber'];
    slideDuration = json['slideDuration'];
    som = json['som'];
    activeNonActive = json['activeNonActive'];
    dated = json['dated'];
    killDate = json['killDate'];
    modifiedBy = json['modifiedBy'];
    locationCode = json['locationCode'];
    eom = json['eom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cunCode'] = this.cunCode;
    data['channelCode'] = this.channelCode;
    data['houseID'] = this.houseID;
    data['exportTapeCode'] = this.exportTapeCode;
    data['programCode'] = this.programCode;
    data['programTypeCode'] = this.programTypeCode;
    data['originalRepeatCode'] = this.originalRepeatCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['segmentNumber'] = this.segmentNumber;
    data['slideDuration'] = this.slideDuration;
    data['som'] = this.som;
    data['activeNonActive'] = this.activeNonActive;
    data['dated'] = this.dated;
    data['killDate'] = this.killDate;
    data['modifiedBy'] = this.modifiedBy;
    data['locationCode'] = this.locationCode;
    data['eom'] = this.eom;
    return data;
  }
}