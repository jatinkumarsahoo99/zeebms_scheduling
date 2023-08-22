class CommercialShowOnTabModel {
  String? fpcTime, fpcTime2;
  bool canChangeFpc = false;
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
    fpcTime2 = json['fpCtime'];
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

  Map<String, dynamic> toJson({bool fromSave = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['fpcTime'] = fpcTime;
      data['breakNumber'] = breakNumber;
      data['bookingDetailcode'] = bookingDetailcode;
      data['randid'] = randid;
      data['rownumber'] = rownumber;
      data['eventType'] = eventType;
      data['exportTapeCode'] = exportTapeCode;
      data['segmentCaption'] = segmentCaption;
      data['client'] = client;
      data['brand'] = brand;
      data['duration'] = duration;
      data['product'] = product;
      data['bookingNumber'] = bookingNumber;
      data['rostimeBand'] = rostimeBand;
      data['programName'] = programName;
      data['bStatus'] = bStatus;
      data['PDailyFPC'] = pDailyFPC??'';
      data['pProgramMaster'] = pProgramMaster;
      data['foreColor'] = foreColor;
      data['backColor'] = backColor;
    } else {
      data['fpcTime'] = fpcTime;
      data['fpcTime '] = fpcTime2;
      data['breakNumber'] = breakNumber;
      data['bookingDetailcode'] = bookingDetailcode;
      data['randid'] = randid;
      data['rownumber'] = rownumber;
      data['eventType'] = eventType;
      data['exportTapeCode'] = exportTapeCode;
      data['segmentCaption'] = segmentCaption;
      data['client'] = client;
      data['brand'] = brand;
      data['duration'] = duration;
      data['product'] = product;
      data['bookingNumber'] = bookingNumber;
      data['rostimeBand'] = rostimeBand;
      data['programName'] = programName;
      data['bStatus'] = bStatus;
      data['pDailyFPC'] = pDailyFPC;
      data['pProgramMaster'] = pProgramMaster;
      data['foreColor'] = foreColor;
      data['backColor'] = backColor;
    }
    return data;
  }
}
