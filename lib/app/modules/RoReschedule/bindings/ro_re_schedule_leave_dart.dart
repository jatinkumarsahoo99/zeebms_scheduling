class RORescheduleOnLeaveData {
  String? agencyname;
  String? clientname;
  String? brandname;
  String? dealno;
  String? payRouteName;
  String? zoneName;
  String? bookingEffectiveDate;
  String? zoneCode;
  String? bookingNumber;
  String? bookingMonth;
  List<LstcmbTapeID>? lstcmbTapeID;
  List<LstcmbBulkTape>? lstcmbBulkTape;
  List<LstdgvUpdated>? lstdgvUpdated;
  List<LstDgvRO>? lstDgvRO;
  List<LstTable>? lstTable;
  List<LstTapeDetails>? lstTapeDetails;
  List<LstUpdateTable>? lstUpdateTable;

  RORescheduleOnLeaveData(
      {this.agencyname,
      this.clientname,
      this.brandname,
      this.dealno,
      this.payRouteName,
      this.zoneName,
      this.bookingEffectiveDate,
      this.zoneCode,
      this.bookingNumber,
      this.bookingMonth,
      this.lstcmbTapeID,
      this.lstcmbBulkTape,
      this.lstdgvUpdated,
      this.lstDgvRO,
      this.lstTable,
      this.lstTapeDetails,
      this.lstUpdateTable});

  RORescheduleOnLeaveData.fromJson(Map<String, dynamic> json) {
    agencyname = json['agencyname'];
    clientname = json['clientname'];
    brandname = json['brandname'];
    dealno = json['dealno'];
    payRouteName = json['payRouteName'];
    zoneName = json['zoneName'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    zoneCode = json['zoneCode'];
    bookingNumber = json['bookingNumber'];
    bookingMonth = json['bookingMonth'];
    if (json['lstcmbTapeID'] != null) {
      lstcmbTapeID = <LstcmbTapeID>[];
      json['lstcmbTapeID'].forEach((v) {
        lstcmbTapeID!.add(new LstcmbTapeID.fromJson(v));
      });
    }
    if (json['lstcmbBulkTape'] != null) {
      lstcmbBulkTape = <LstcmbBulkTape>[];
      json['lstcmbBulkTape'].forEach((v) {
        lstcmbBulkTape!.add(new LstcmbBulkTape.fromJson(v));
      });
    }
    if (json['lstdgvUpdated'] != null) {
      lstdgvUpdated = <LstdgvUpdated>[];
      json['lstdgvUpdated'].forEach((v) {
        lstdgvUpdated!.add(new LstdgvUpdated.fromJson(v));
      });
    }
    if (json['lstDgvRO'] != null) {
      lstDgvRO = <LstDgvRO>[];
      json['lstDgvRO'].forEach((v) {
        lstDgvRO!.add(new LstDgvRO.fromJson(v));
      });
    }
    if (json['lstTable'] != null) {
      lstTable = <LstTable>[];
      json['lstTable'].forEach((v) {
        lstTable!.add(new LstTable.fromJson(v));
      });
    }
    if (json['lstTapeDetails'] != null) {
      lstTapeDetails = <LstTapeDetails>[];
      json['lstTapeDetails'].forEach((v) {
        lstTapeDetails!.add(new LstTapeDetails.fromJson(v));
      });
    }
    if (json['lstUpdateTable'] != null) {
      lstUpdateTable = <LstUpdateTable>[];
      json['lstUpdateTable'].forEach((v) {
        lstUpdateTable!.add(new LstUpdateTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agencyname'] = this.agencyname;
    data['clientname'] = this.clientname;
    data['brandname'] = this.brandname;
    data['dealno'] = this.dealno;
    data['payRouteName'] = this.payRouteName;
    data['zoneName'] = this.zoneName;
    data['bookingEffectiveDate'] = this.bookingEffectiveDate;
    data['zoneCode'] = this.zoneCode;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingMonth'] = this.bookingMonth;
    if (this.lstcmbTapeID != null) {
      data['lstcmbTapeID'] = this.lstcmbTapeID!.map((v) => v.toJson()).toList();
    }
    if (this.lstcmbBulkTape != null) {
      data['lstcmbBulkTape'] =
          this.lstcmbBulkTape!.map((v) => v.toJson()).toList();
    }
    if (this.lstdgvUpdated != null) {
      data['lstdgvUpdated'] =
          this.lstdgvUpdated!.map((v) => v.toJson()).toList();
    }
    if (this.lstDgvRO != null) {
      data['lstDgvRO'] = this.lstDgvRO!.map((v) => v.toJson()).toList();
    }
    if (this.lstTable != null) {
      data['lstTable'] = this.lstTable!.map((v) => v.toJson()).toList();
    }
    if (this.lstTapeDetails != null) {
      data['lstTapeDetails'] =
          this.lstTapeDetails!.map((v) => v.toJson()).toList();
    }
    if (this.lstUpdateTable != null) {
      data['lstUpdateTable'] =
          this.lstUpdateTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstcmbTapeID {
  String? commercialCaption;
  String? exporttapecode;

  LstcmbTapeID({this.commercialCaption, this.exporttapecode});

  LstcmbTapeID.fromJson(Map<String, dynamic> json) {
    commercialCaption = json['commercialCaption'];
    exporttapecode = json['exporttapecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commercialCaption'] = this.commercialCaption;
    data['exporttapecode'] = this.exporttapecode;
    return data;
  }
}

class LstdgvUpdated {
  int? rowNo;
  Null? programCode;
  String? midPre;
  String? positionCode;
  Null? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? exportTapeCode;
  String? commercialCaption;
  int? tapeDuration;
  int? spotAmount;
  int? bookingDetailCode;
  int? recordnumber;
  int? segmentNumber;
  int? breaknumber;
  String? spotPositionTypeName;
  String? positionName;
  int? edit;
  String? rescheduleno;
  bool? audited;

  LstdgvUpdated(
      {this.rowNo,
      this.programCode,
      this.midPre,
      this.positionCode,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.exportTapeCode,
      this.commercialCaption,
      this.tapeDuration,
      this.spotAmount,
      this.bookingDetailCode,
      this.recordnumber,
      this.segmentNumber,
      this.breaknumber,
      this.spotPositionTypeName,
      this.positionName,
      this.edit,
      this.rescheduleno,
      this.audited});

  LstdgvUpdated.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    programCode = json['programCode'];
    midPre = json['midPre'];
    positionCode = json['positionCode'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    bookingDetailCode = json['bookingDetailCode'];
    recordnumber = json['recordnumber'];
    segmentNumber = json['segmentNumber'];
    breaknumber = json['breaknumber'];
    spotPositionTypeName = json['spotPositionTypeName'];
    positionName = json['positionName'];
    edit = json['edit'];
    rescheduleno = json['rescheduleno'];
    audited = json['audited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNo'] = this.rowNo;
    data['programCode'] = this.programCode;
    data['midPre'] = this.midPre;
    data['positionCode'] = this.positionCode;
    data['programName'] = this.programName;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['exportTapeCode'] = this.exportTapeCode;
    data['commercialCaption'] = this.commercialCaption;
    data['tapeDuration'] = this.tapeDuration;
    data['spotAmount'] = this.spotAmount;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['recordnumber'] = this.recordnumber;
    data['segmentNumber'] = this.segmentNumber;
    data['breaknumber'] = this.breaknumber;
    data['spotPositionTypeName'] = this.spotPositionTypeName;
    data['positionName'] = this.positionName;
    data['edit'] = this.edit;
    data['rescheduleno'] = this.rescheduleno;
    data['audited'] = this.audited;
    return data;
  }
}

class LstUpdateTable {
  int? rowNo;
  Null? programCode;
  String? midPre;
  String? positionCode;
  Null? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? exportTapeCode;
  String? commercialCaption;
  int? tapeDuration;
  int? spotAmount;
  int? bookingDetailCode;
  int? recordnumber;
  int? segmentNumber;
  int? breaknumber;
  String? spotPositionTypeName;
  String? positionName;
  int? edit;
  String? rescheduleno;
  bool? audited;

  LstUpdateTable(
      {this.rowNo,
      this.programCode,
      this.midPre,
      this.positionCode,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.exportTapeCode,
      this.commercialCaption,
      this.tapeDuration,
      this.spotAmount,
      this.bookingDetailCode,
      this.recordnumber,
      this.segmentNumber,
      this.breaknumber,
      this.spotPositionTypeName,
      this.positionName,
      this.edit,
      this.rescheduleno,
      this.audited});

  LstUpdateTable.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    programCode = json['programCode'];
    midPre = json['midPre'];
    positionCode = json['positionCode'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    bookingDetailCode = json['bookingDetailCode'];
    recordnumber = json['recordnumber'];
    segmentNumber = json['segmentNumber'];
    breaknumber = json['breaknumber'];
    spotPositionTypeName = json['spotPositionTypeName'];
    positionName = json['positionName'];
    edit = json['edit'];
    rescheduleno = json['rescheduleno'];
    audited = json['audited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNo'] = this.rowNo;
    data['programCode'] = this.programCode;
    data['midPre'] = this.midPre;
    data['positionCode'] = this.positionCode;
    data['programName'] = this.programName;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['exportTapeCode'] = this.exportTapeCode;
    data['commercialCaption'] = this.commercialCaption;
    data['tapeDuration'] = this.tapeDuration;
    data['spotAmount'] = this.spotAmount;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['recordnumber'] = this.recordnumber;
    data['segmentNumber'] = this.segmentNumber;
    data['breaknumber'] = this.breaknumber;
    data['spotPositionTypeName'] = this.spotPositionTypeName;
    data['positionName'] = this.positionName;
    data['edit'] = this.edit;
    data['rescheduleno'] = this.rescheduleno;
    data['audited'] = this.audited;
    return data;
  }
}

class LstDgvRO {
  String? programCode;
  String? revType;
  String? tapeLanguage;
  String? midPre;
  String? positionCode;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? exportTapeCode;
  String? commercialCaption;
  int? tapeDuration;
  int? spotAmount;
  int? bookingDetailCode;
  int? recordnumber;
  int? segmentNumber;
  int? breaknumber;
  String? spotPositionTypeName;
  String? positionName;
  int? edit;
  String? bookingstatus;
  String? killDate;
  String? campaignStartDate;
  String? campaignEndDate;
  Null? colorName;

  LstDgvRO(
      {this.programCode,
      this.revType,
      this.tapeLanguage,
      this.midPre,
      this.positionCode,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.exportTapeCode,
      this.commercialCaption,
      this.tapeDuration,
      this.spotAmount,
      this.bookingDetailCode,
      this.recordnumber,
      this.segmentNumber,
      this.breaknumber,
      this.spotPositionTypeName,
      this.positionName,
      this.edit,
      this.bookingstatus,
      this.killDate,
      this.campaignStartDate,
      this.campaignEndDate,
      this.colorName});

  LstDgvRO.fromJson(Map<String, dynamic> json) {
    programCode = json['programCode'];
    revType = json['revType'];
    tapeLanguage = json['tapeLanguage'];
    midPre = json['midPre'];
    positionCode = json['positionCode'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    bookingDetailCode = json['bookingDetailCode'];
    recordnumber = json['recordnumber'];
    segmentNumber = json['segmentNumber'];
    breaknumber = json['breaknumber'];
    spotPositionTypeName = json['spotPositionTypeName'];
    positionName = json['positionName'];
    edit = json['edit'];
    bookingstatus = json['bookingstatus'];
    killDate = json['killDate'];
    campaignStartDate = json['campaignStartDate'];
    campaignEndDate = json['campaignEndDate'];
    colorName = json['colorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programCode'] = this.programCode;
    data['revType'] = this.revType;
    data['tapeLanguage'] = this.tapeLanguage;
    data['midPre'] = this.midPre;
    data['positionCode'] = this.positionCode;
    data['programName'] = this.programName;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['exportTapeCode'] = this.exportTapeCode;
    data['commercialCaption'] = this.commercialCaption;
    data['tapeDuration'] = this.tapeDuration;
    data['spotAmount'] = this.spotAmount;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['recordnumber'] = this.recordnumber;
    data['segmentNumber'] = this.segmentNumber;
    data['breaknumber'] = this.breaknumber;
    data['spotPositionTypeName'] = this.spotPositionTypeName;
    data['positionName'] = this.positionName;
    data['edit'] = this.edit;
    data['bookingstatus'] = this.bookingstatus;
    data['killDate'] = this.killDate;
    data['campaignStartDate'] = this.campaignStartDate;
    data['campaignEndDate'] = this.campaignEndDate;
    data['colorName'] = this.colorName;
    return data;
  }
}

class LstcmbBulkTape {
  String? commercialCaption;
  String? exporttapecode;

  LstcmbBulkTape({this.commercialCaption, this.exporttapecode});

  LstcmbBulkTape.fromJson(Map<String, dynamic> json) {
    commercialCaption = json['commercialCaption'];
    exporttapecode = json['exporttapecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commercialCaption'] = this.commercialCaption;
    data['exporttapecode'] = this.exporttapecode;
    return data;
  }
}

class LstTable {
  String? programCode;
  String? revType;
  String? tapeLanguage;
  String? midPre;
  String? positionCode;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? exportTapeCode;
  String? commercialCaption;
  int? tapeDuration;
  int? spotAmount;
  int? bookingDetailCode;
  int? recordnumber;
  int? segmentNumber;
  int? breaknumber;
  String? spotPositionTypeName;
  String? positionName;
  int? edit;
  String? bookingstatus;
  String? killDate;
  String? campaignStartDate;
  String? campaignEndDate;
  String? backColor;

  LstTable(
      {this.programCode,
      this.revType,
      this.tapeLanguage,
      this.midPre,
      this.positionCode,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.exportTapeCode,
      this.commercialCaption,
      this.tapeDuration,
      this.spotAmount,
      this.bookingDetailCode,
      this.recordnumber,
      this.segmentNumber,
      this.breaknumber,
      this.spotPositionTypeName,
      this.positionName,
      this.edit,
      this.bookingstatus,
      this.killDate,
      this.campaignStartDate,
      this.campaignEndDate,
      this.backColor});

  LstTable.fromJson(Map<String, dynamic> json) {
    programCode = json['programCode'];
    revType = json['revType'];
    tapeLanguage = json['tapeLanguage'];
    midPre = json['midPre'];
    positionCode = json['positionCode'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    bookingDetailCode = json['bookingDetailCode'];
    recordnumber = json['recordnumber'];
    segmentNumber = json['segmentNumber'];
    breaknumber = json['breaknumber'];
    spotPositionTypeName = json['spotPositionTypeName'];
    positionName = json['positionName'];
    edit = json['edit'];
    bookingstatus = json['bookingstatus'];
    killDate = json['killDate'];
    campaignStartDate = json['campaignStartDate'];
    campaignEndDate = json['campaignEndDate'];
    backColor = json['backColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programCode'] = this.programCode;
    data['revType'] = this.revType;
    data['tapeLanguage'] = this.tapeLanguage;
    data['midPre'] = this.midPre;
    data['positionCode'] = this.positionCode;
    data['programName'] = this.programName;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['exportTapeCode'] = this.exportTapeCode;
    data['commercialCaption'] = this.commercialCaption;
    data['tapeDuration'] = this.tapeDuration;
    data['spotAmount'] = this.spotAmount;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['recordnumber'] = this.recordnumber;
    data['segmentNumber'] = this.segmentNumber;
    data['breaknumber'] = this.breaknumber;
    data['spotPositionTypeName'] = this.spotPositionTypeName;
    data['positionName'] = this.positionName;
    data['edit'] = this.edit;
    data['bookingstatus'] = this.bookingstatus;
    data['killDate'] = this.killDate;
    data['campaignStartDate'] = this.campaignStartDate;
    data['campaignEndDate'] = this.campaignEndDate;
    data['backColor'] = this.backColor;
    return data;
  }
}

class LstTapeDetails {
  String? exporttapecode;
  String? commercialCaption;
  String? revType;
  String? tapeLanguage;
  int? duration;

  LstTapeDetails(
      {this.exporttapecode,
      this.commercialCaption,
      this.revType,
      this.tapeLanguage,
      this.duration});

  LstTapeDetails.fromJson(Map<String, dynamic> json) {
    exporttapecode = json['exporttapecode'];
    commercialCaption = json['commercialCaption'];
    revType = json['revType'];
    tapeLanguage = json['tapeLanguage'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exporttapecode'] = this.exporttapecode;
    data['commercialCaption'] = this.commercialCaption;
    data['revType'] = this.revType;
    data['tapeLanguage'] = this.tapeLanguage;
    data['duration'] = this.duration;
    return data;
  }
}
