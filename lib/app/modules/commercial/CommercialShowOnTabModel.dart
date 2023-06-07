class CommercialShowOnTabModel {
  String? fpcTime;
  int? breakNumber;
  String? eventType;
  String? exportTapeCode;
  String? segmentCaption;
  String? client;
  String? brand;
  String? duration;
  String? product;
  String? bookingNumber;
  double? bookingDetailcode;
  String? rostimeBand;
  double? randid;
  String? programName;
  int? rownumber;
  String? bStatus;
  String? pDailyFPC;
  String? pProgramMaster;
  String? foreColor;
  String? backColor;

  CommercialShowOnTabModel(
      {this.fpcTime,
      this.breakNumber,
      this.eventType,
      this.exportTapeCode,
      this.segmentCaption,
      this.client,
      this.brand,
      this.duration,
      this.product,
      this.bookingNumber,
      this.bookingDetailcode,
      this.rostimeBand,
      this.randid,
      this.programName,
      this.rownumber,
      this.bStatus,
      this.pDailyFPC,
      this.pProgramMaster});

  CommercialShowOnTabModel.fromJson(Map<String, dynamic> json, int index) {
    fpcTime = json['fpCtime'];
    breakNumber = json['breakNumber'];
    bookingDetailcode = json['bookingDetailcode'];
    randid = json['randid'];
    rownumber = index;
    eventType = (json['eventType'] ?? "").toString();
    exportTapeCode = json['exportTapeCode'];
    segmentCaption = json['segmentCaption'];
    client = (json['client'] ?? '').toString();
    brand = json['brand'];
    duration = json['duration'];
    product = (json['product'] ?? "").toString();
    bookingNumber = json['bookingNumber'];
    rostimeBand = json['rostimeBand'];
    programName = json['programName'];
    bStatus = json['bStatus'];
    pDailyFPC = json['pDailyFPC'];
    pProgramMaster = json['pProgramMaster'];
    foreColor = json['foreColor'];
    backColor = json['backColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fpcTime'] = this.fpcTime;
    data['breakNumber'] = this.breakNumber;
    data['bookingDetailcode'] = this.bookingDetailcode;
    data['randid'] = this.randid;
    data['rownumber'] = this.rownumber;
    data['eventType'] = this.eventType;
    data['exportTapeCode'] = this.exportTapeCode;
    data['segmentCaption'] = this.segmentCaption;
    data['client'] = this.client;
    data['brand'] = this.brand;
    data['duration'] = this.duration;
    data['product'] = this.product;
    data['bookingNumber'] = this.bookingNumber;
    data['rostimeBand'] = this.rostimeBand;
    data['programName'] = this.programName;
    data['bStatus'] = this.bStatus;
    data['pDailyFPC'] = this.pDailyFPC;
    data['pProgramMaster'] = this.pProgramMaster;
    data['foreColor'] = this.foreColor;
    data['backColor'] = this.backColor;

    return data;
  }

}
