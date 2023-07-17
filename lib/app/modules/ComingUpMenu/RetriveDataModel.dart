class RetriveDataModel {
  String? menuCode;
  String? locationCode;
  String? channelCode;
  String? exportTapeCode;
  int? segmentNumber;
  String? houseId;
  String? exportTapeCaption;
  String? menuDuration;
  String? som;
  String? eom;
  String? menuStartTime;
  String? menuEndTime;
  String? killdate;
  String? menuDate;

  RetriveDataModel(
      {this.menuCode,
        this.locationCode,
        this.channelCode,
        this.exportTapeCode,
        this.segmentNumber,
        this.houseId,
        this.exportTapeCaption,
        this.menuDuration,
        this.som,
        this.eom,
        this.menuStartTime,
        this.menuEndTime,
        this.killdate,
        this.menuDate});

  RetriveDataModel.fromJson(Map<String, dynamic> json) {
    menuCode = json['menuCode'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    exportTapeCode = json['exportTapeCode'];
    segmentNumber = json['segmentNumber'];
    houseId = json['houseId'];
    exportTapeCaption = json['exportTapeCaption'];
    menuDuration = json['menuDuration'];
    som = json['som'];
    eom = json['eom'];
    menuStartTime = json['menuStartTime'];
    menuEndTime = json['menuEndTime'];
    killdate = json['killdate'];
    menuDate = json['menuDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuCode'] = this.menuCode;
    data['locationCode'] = this.locationCode;
    data['channelCode'] = this.channelCode;
    data['exportTapeCode'] = this.exportTapeCode;
    data['segmentNumber'] = this.segmentNumber;
    data['houseId'] = this.houseId;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['menuDuration'] = this.menuDuration;
    data['som'] = this.som;
    data['eom'] = this.eom;
    data['menuStartTime'] = this.menuStartTime;
    data['menuEndTime'] = this.menuEndTime;
    data['killdate'] = this.killdate;
    data['menuDate'] = this.menuDate;
    return data;
  }
}
