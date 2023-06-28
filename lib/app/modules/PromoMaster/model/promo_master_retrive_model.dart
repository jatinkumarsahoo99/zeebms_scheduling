class PromoMasterRetriveModel {
  List<RetrieveRecord>? retrieveRecord;

  PromoMasterRetriveModel({this.retrieveRecord});

  PromoMasterRetriveModel.fromJson(Map<String, dynamic> json) {
    if (json['retrieveRecord'] != null) {
      retrieveRecord = <RetrieveRecord>[];
      json['retrieveRecord'].forEach((v) {
        retrieveRecord!.add(new RetrieveRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.retrieveRecord != null) {
      data['retrieveRecord'] = this.retrieveRecord!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RetrieveRecord {
  String? promoCode;
  String? promoCaption;
  int? promoDuration;
  String? promoTypeCode;
  String? promoTypeName;
  String? promoCategoryCode;
  String? promoCategoryName;
  String? exportTapeCode;
  String? exportTapeCaption;
  String? tapeTypeCode;
  String? tapeTypeName;
  String? channelCode;
  String? programCode;
  String? programName;
  String? originalRepeatCode;
  String? originalRepeatName;
  String? houseId;
  int? segmentNumber;
  String? som;
  String? dated;
  String? killDate;
  int? autoPriority;
  String? highPriority;
  String? startDate;
  String? locationCode1;
  String? ptype;
  String? remarks;
  String? blanktapeid;
  String? locationcode;
  String? locationName;
  int? branchcode;
  int? billflag;
  String? companycode;
  String? companyName;
  String? eom;
  List<LstAnnotationLoadDatas>? lstAnnotationLoadDatas;

  RetrieveRecord(
      {this.promoCode,
      this.promoCaption,
      this.promoDuration,
      this.promoTypeCode,
      this.promoTypeName,
      this.promoCategoryCode,
      this.promoCategoryName,
      this.exportTapeCode,
      this.exportTapeCaption,
      this.tapeTypeCode,
      this.tapeTypeName,
      this.channelCode,
      this.programCode,
      this.programName,
      this.originalRepeatCode,
      this.originalRepeatName,
      this.houseId,
      this.segmentNumber,
      this.som,
      this.dated,
      this.killDate,
      this.autoPriority,
      this.highPriority,
      this.startDate,
      this.locationCode1,
      this.ptype,
      this.remarks,
      this.blanktapeid,
      this.locationcode,
      this.locationName,
      this.branchcode,
      this.billflag,
      this.companycode,
      this.companyName,
      this.eom,
      this.lstAnnotationLoadDatas});

  RetrieveRecord.fromJson(Map<String, dynamic> json) {
    promoCode = json['promoCode'];
    promoCaption = json['promoCaption'];
    promoDuration = json['promoDuration'];
    promoTypeCode = json['promoTypeCode'];
    promoTypeName = json['promoTypeName'];
    promoCategoryCode = json['promoCategoryCode'];
    promoCategoryName = json['promoCategoryName'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    tapeTypeCode = json['tapeTypeCode'];
    tapeTypeName = json['tapeTypeName'];
    channelCode = json['channelCode'];
    programCode = json['programCode'];
    programName = json['programName'];
    originalRepeatCode = json['originalRepeatCode'];
    originalRepeatName = json['originalRepeatName'];
    houseId = json['houseId'];
    segmentNumber = json['segmentNumber'];
    som = json['som'];
    dated = json['dated'];
    killDate = json['killDate'];
    autoPriority = json['autoPriority'];
    highPriority = json['highPriority'];
    startDate = json['startDate'];
    locationCode1 = json['locationCode1'];
    ptype = json['ptype'];
    remarks = json['remarks'];
    blanktapeid = json['blanktapeid'];
    locationcode = json['locationcode'];
    locationName = json['locationName'];
    branchcode = json['branchcode'];
    billflag = json['billflag'];
    companycode = json['companycode'];
    companyName = json['companyName'];
    eom = json['eom'];
    if (json['lstAnnotationLoadDatas'] != null) {
      lstAnnotationLoadDatas = <LstAnnotationLoadDatas>[];
      json['lstAnnotationLoadDatas'].forEach((v) {
        lstAnnotationLoadDatas!.add(new LstAnnotationLoadDatas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promoCode'] = this.promoCode;
    data['promoCaption'] = this.promoCaption;
    data['promoDuration'] = this.promoDuration;
    data['promoTypeCode'] = this.promoTypeCode;
    data['promoTypeName'] = this.promoTypeName;
    data['promoCategoryCode'] = this.promoCategoryCode;
    data['promoCategoryName'] = this.promoCategoryName;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['tapeTypeCode'] = this.tapeTypeCode;
    data['tapeTypeName'] = this.tapeTypeName;
    data['channelCode'] = this.channelCode;
    data['programCode'] = this.programCode;
    data['programName'] = this.programName;
    data['originalRepeatCode'] = this.originalRepeatCode;
    data['originalRepeatName'] = this.originalRepeatName;
    data['houseId'] = this.houseId;
    data['segmentNumber'] = this.segmentNumber;
    data['som'] = this.som;
    data['dated'] = this.dated;
    data['killDate'] = this.killDate;
    data['autoPriority'] = this.autoPriority;
    data['highPriority'] = this.highPriority;
    data['startDate'] = this.startDate;
    data['locationCode1'] = this.locationCode1;
    data['ptype'] = this.ptype;
    data['remarks'] = this.remarks;
    data['blanktapeid'] = this.blanktapeid;
    data['locationcode'] = this.locationcode;
    data['locationName'] = this.locationName;
    data['branchcode'] = this.branchcode;
    data['billflag'] = this.billflag;
    data['companycode'] = this.companycode;
    data['companyName'] = this.companyName;
    data['eom'] = this.eom;
    if (this.lstAnnotationLoadDatas != null) {
      data['lstAnnotationLoadDatas'] = this.lstAnnotationLoadDatas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstAnnotationLoadDatas {
  int? rowno;
  int? eventId;
  String? eventname;
  String? tCin;
  String? tCout;

  LstAnnotationLoadDatas({this.rowno, this.eventId, this.eventname, this.tCin, this.tCout});

  LstAnnotationLoadDatas.fromJson(Map<String, dynamic> json) {
    rowno = json['rowno'];
    eventId = json['eventId'];
    eventname = json['eventname'];
    tCin = json['tCin'];
    tCout = json['tCout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['rowno'] = this.rowno;
    // data['eventId'] = this.eventId;
    data['eventname'] = this.eventname;
    data['tCin'] = this.tCin;
    data['tCout'] = this.tCout;
    return data;
  }
}
