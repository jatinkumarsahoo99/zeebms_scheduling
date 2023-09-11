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
    print("parsing lstcmbTapeID");
    if (json['lstcmbTapeID'] != null) {
      lstcmbTapeID = <LstcmbTapeID>[];
      json['lstcmbTapeID'].forEach((v) {
        lstcmbTapeID!.add(LstcmbTapeID.fromJson(v));
      });
    }
    print("parsing lstcmbBulkTape");

    if (json['lstcmbBulkTape'] != null) {
      lstcmbBulkTape = <LstcmbBulkTape>[];
      json['lstcmbBulkTape'].forEach((v) {
        lstcmbBulkTape!.add(LstcmbBulkTape.fromJson(v));
      });
    }
    print("parsing lstdgvUpdated");
    if (json['lstdgvUpdated'] != null) {
      lstdgvUpdated = <LstdgvUpdated>[];
      json['lstdgvUpdated'].forEach((v) {
        lstdgvUpdated!.add(LstdgvUpdated.fromJson(v));
      });
    }
    print("parsing print");
    if (json['lstDgvRO'] != null) {
      lstDgvRO = <LstDgvRO>[];
      json['lstDgvRO'].forEach((v) {
        lstDgvRO!.add(LstDgvRO.fromJson(v));
      });
    }
    print("parsing lstTable");
    if (json['lstTable'] != null) {
      lstTable = <LstTable>[];
      json['lstTable'].forEach((v) {
        lstTable!.add(LstTable.fromJson(v));
      });
    }
    print("parsing lstTapeDetails");
    if (json['lstTapeDetails'] != null) {
      lstTapeDetails = <LstTapeDetails>[];
      json['lstTapeDetails'].forEach((v) {
        lstTapeDetails!.add(LstTapeDetails.fromJson(v));
      });
    }
    print("parsing lstUpdateTable");
    if (json['lstUpdateTable'] != null) {
      lstUpdateTable = <LstUpdateTable>[];
      json['lstUpdateTable'].forEach((v) {
        lstUpdateTable!.add(LstUpdateTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agencyname'] = agencyname;
    data['clientname'] = clientname;
    data['brandname'] = brandname;
    data['dealno'] = dealno;
    data['payRouteName'] = payRouteName;
    data['zoneName'] = zoneName;
    data['bookingEffectiveDate'] = bookingEffectiveDate;
    data['zoneCode'] = zoneCode;
    data['bookingNumber'] = bookingNumber;
    data['bookingMonth'] = bookingMonth;
    if (lstcmbTapeID != null) {
      data['lstcmbTapeID'] = lstcmbTapeID!.map((v) => v.toJson()).toList();
    }
    if (lstcmbBulkTape != null) {
      data['lstcmbBulkTape'] = lstcmbBulkTape!.map((v) => v.toJson()).toList();
    }
    if (lstdgvUpdated != null) {
      data['lstdgvUpdated'] = lstdgvUpdated!.map((v) => v.toJson()).toList();
    }
    if (lstDgvRO != null) {
      data['lstDgvRO'] = lstDgvRO!.map((v) => v.toJson()).toList();
    }
    if (lstTable != null) {
      data['lstTable'] = lstTable!.map((v) => v.toJson()).toList();
    }
    if (lstTapeDetails != null) {
      data['lstTapeDetails'] = lstTapeDetails!.map((v) => v.toJson()).toList();
    }
    if (lstUpdateTable != null) {
      data['lstUpdateTable'] = lstUpdateTable!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commercialCaption'] = commercialCaption;
    data['exporttapecode'] = exporttapecode;
    return data;
  }
}

class LstdgvUpdated {
  int? rowNo;
  String? programCode;
  String? midPre;
  String? positionCode;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? exportTapeCode;
  String? commercialCaption;
  String? tapeDuration;
  String? spotAmount;
  String? bookingDetailCode;
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
    rowNo =
        json['rowNo'] is String ? int.tryParse(json['rowNo']) : json['rowNo'];
    programCode = json['programCode'];
    midPre = json['midPre'];
    positionCode = json['positionCode'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    // scheduleTime = json['scheduleTime'];
    if (json['scheduleTime'] != null) {
      if (json['scheduleTime'].toString().contains(" ")) {
        scheduleTime = json['scheduleTime'].toString().split(" ")[1];
      } else {
        scheduleTime = json['scheduleTime'];
      }
    }
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    bookingDetailCode = json['bookingDetailCode'];
    recordnumber = json['recordnumber'] is String
        ? int.tryParse(json['recordnumber'])
        : json['recordnumber'];
    segmentNumber = json['segmentNumber'] is String
        ? int.tryParse(json['segmentNumber'])
        : json['segmentNumber'];
    spotPositionTypeName = json['spotPositionTypeName'];
    positionName = json['positionName'];
    edit = json['edit'] is String ? int.tryParse(json['edit']) : json['edit'];
    rescheduleno = json['rescheduleno'];
    audited = json['audited'] is String
        ? (json['audited'].toString().toLowerCase() == "true"
            ? true
            : (json['audited'].toString().toLowerCase() == "false"
                ? false
                : null))
        : json['audited'];
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
  String? tapeDuration;
  String? spotAmount;
  String? bookingDetailCode;
  int? recordnumber;
  int? segmentNumber;
  int? breaknumber;
  String? spotPositionTypeName;
  String? positionName;
  int? edit;
  bool? audited;
  String? rescheduleno;
  String? bookingstatus;
  String? killDate;
  String? campaignStartDate;
  String? campaignEndDate;
  String? colorName;

  LstUpdateTable(
      {this.rowNo,
      this.programCode,
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
      this.audited,
      this.rescheduleno,
      this.bookingstatus,
      this.killDate,
      this.campaignStartDate,
      this.campaignEndDate,
      this.colorName});

  LstUpdateTable.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
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
    audited = json['audited'];
    rescheduleno = json['rescheduleno'];
    bookingstatus = json['bookingstatus'];
    killDate = json['killDate'];
    campaignStartDate = json['campaignStartDate'];
    campaignEndDate = json['campaignEndDate'];
    colorName = json['colorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowNo'] = this.rowNo;
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
    data['audited'] = this.audited;
    data['rescheduleno'] = this.rescheduleno;
    data['bookingstatus'] = this.bookingstatus;
    data['killDate'] = this.killDate;
    data['campaignStartDate'] = this.campaignStartDate;
    data['campaignEndDate'] = this.campaignEndDate;
    data['colorName'] = this.colorName;
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
  num? spotAmount;
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
  String? colorName;

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

  Map<String, dynamic> toJson({bool fromSave = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['programCode'] = programCode;
      data['revType'] = revType;
      data['tapeLanguage'] = tapeLanguage;
      data['midPre'] = midPre;
      data['positionCode'] = positionCode;
      data['programName'] = programName;
      data['scheduleDate'] = scheduleDate;
      data['scheduleTime'] = scheduleTime;
      data['exportTapeCode'] = exportTapeCode;
      data['commercialCaption'] = commercialCaption;
      data['tapeDuration'] = tapeDuration;
      data['spotAmount'] = spotAmount;
      data['bookingDetailCode'] = bookingDetailCode;
      data['recordnumber'] = recordnumber;
      data['segmentNumber'] = segmentNumber;
      data['breaknumber'] = breaknumber;
      data['spotPositionTypeName'] = spotPositionTypeName;
      data['positionName'] = positionName;
      data['edit'] = edit;
      data['bookingstatus'] = bookingstatus;
      data['killDate'] = killDate;
      data['campaignStartDate'] = campaignStartDate;
      data['campaignEndDate'] = campaignEndDate;
      data['colorName'] = colorName;
    } else {
      data['programName'] = programName;
      data['scheduleDate'] = scheduleDate;
      data['scheduleTime'] = scheduleTime;
      data['exportTapeCode'] = exportTapeCode;
      data['commercialCaption'] = commercialCaption;
      data['tapeDuration'] = tapeDuration;
      data['spotAmount'] = spotAmount;
      data['bookingDetailCode'] = bookingDetailCode;
      data['recordnumber'] = recordnumber;
      data['segmentNumber'] = segmentNumber;
      data['breaknumber'] = breaknumber;
      data['spotPositionTypeName'] = spotPositionTypeName;
      data['positionName'] = positionName;
      data['bookingstatus'] = bookingstatus;
      data['killDate'] = killDate;
      data['campaignStartDate'] = campaignStartDate;
      data['campaignEndDate'] = campaignEndDate;
      // data['programCode'] = programCode;
      // data['revType'] = revType;
      // data['tapeLanguage'] = tapeLanguage;
      // data['midPre'] = midPre;
      // data['positionCode'] = positionCode;
      // data['edit'] = edit;
      // data['colorName'] = colorName;
    }
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commercialCaption'] = commercialCaption;
    data['exporttapecode'] = exporttapecode;
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
  String? colorName;

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
      this.colorName});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exporttapecode'] = exporttapecode;
    data['commercialCaption'] = commercialCaption;
    data['revType'] = revType;
    data['tapeLanguage'] = tapeLanguage;
    data['duration'] = duration;
    return data;
  }
}
