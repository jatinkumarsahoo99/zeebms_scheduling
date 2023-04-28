class FillerModel {

  bool? selectItem=false;
  String? fpcTime;
  String? breakNumber;
  String? eventType;
  String? exportTapeCode;
  String? segmentCaption;
  String? client;
  String? brand;
  int? duration;
  String? product;
  String? bookingNumber;
  String? bookingDetailcode;
  String? rostimeBand;
  String? randid;
  String? programName;
  String? rownumber;
  String? bStatus;
  String? pDailyFPC;
  String? pProgramMaster;

  FillerModel({ this.fpcTime, this.breakNumber,
    this.eventType, this.exportTapeCode, this.segmentCaption, this.client,
    this.brand, this.duration, this.product, this.bookingNumber,
    this.bookingDetailcode, this.rostimeBand, this.randid, this.programName,
    this.rownumber, this.bStatus, this.pDailyFPC, this.pProgramMaster});

  FillerModel.fromJson(Map<String, dynamic> json) {
    // startTime = json['startTime'];
    // programName = json['programName'];
    // episodeNumber = (json['episodeNumber']??"").toString();
    // tapeId = json['tapeId'];
    // programCode = json['programCode'];
    // promoCap = (json['promoCap']??'').toString();
    // episodeDuration = json['episodeDuration'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['startTime'] = this.startTime;
    // data['programName'] = this.programName;
    // data['episodeNumber'] = this.episodeNumber;
    // data['tapeId'] = this.tapeId;
    // data['programCode'] = this.programCode;
    // data['promoCap'] = this.promoCap;
    // data['episodeDuration'] = this.episodeDuration;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fpcTime'] = this.fpcTime;
    data['breakNumber'] = this.breakNumber;
    data['eventType'] = this.eventType;
    data['exportTapeCode'] = this.exportTapeCode;
    data['segmentCaption'] = this.segmentCaption;
    data['client'] = this.client;
    data['brand'] = this.brand;
    data['duration'] = this.duration;
    data['product'] = this.product;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailcode'] = this.bookingDetailcode;
    data['rostimeBand'] = this.rostimeBand;
    data['randid'] = this.randid;
    data['programName'] = this.programName;
    data['rownumber'] = this.rownumber;
    data['bStatus'] = this.bStatus;
    data['pDailyFPC'] = this.pDailyFPC;
    data['pProgramMaster'] = this.pProgramMaster;

    return data;
  }
}
