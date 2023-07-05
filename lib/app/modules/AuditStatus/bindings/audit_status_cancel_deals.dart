class AuditStatusCancelDeals {
  bool? isGridReadOnly;
  bool? isAllowColumnsEditing;
  List<DisplayRes>? displayRes;

  AuditStatusCancelDeals(
      {this.isGridReadOnly, this.isAllowColumnsEditing, this.displayRes});

  AuditStatusCancelDeals.fromJson(Map<String, dynamic> json) {
    isGridReadOnly = json['isGridReadOnly'];
    isAllowColumnsEditing = json['isAllowColumnsEditing'];
    if (json['displayRes'] != null) {
      displayRes = <DisplayRes>[];
      json['displayRes'].forEach((v) {
        displayRes!.add(new DisplayRes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isGridReadOnly'] = this.isGridReadOnly;
    data['isAllowColumnsEditing'] = this.isAllowColumnsEditing;
    if (this.displayRes != null) {
      data['displayRes'] = this.displayRes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DisplayRes {
  bool? audited;
  bool? requested;
  String? cancelNumber;
  String? locationCode;
  String? channelCode;
  String? bookingNumber;
  int? bookingDetailCode;
  String? commercialCaption;
  String? exportTapeCode;
  int? tapeDuration;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  int? spotAmount;
  String? spotStatus;
  String? bookingStatus;
  String? logged;
  String? telecastProgramCode;
  int? status;
  String? dealno;
  int? recordnumber;
  String? auditedBy;
  String? auditedOn;
  int? editable;

  DisplayRes(
      {this.audited,
      this.requested,
      this.cancelNumber,
      this.locationCode,
      this.channelCode,
      this.bookingNumber,
      this.bookingDetailCode,
      this.commercialCaption,
      this.exportTapeCode,
      this.tapeDuration,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.spotAmount,
      this.spotStatus,
      this.bookingStatus,
      this.logged,
      this.telecastProgramCode,
      this.status,
      this.dealno,
      this.recordnumber,
      this.auditedBy,
      this.auditedOn,
      this.editable});

  DisplayRes.fromJson(Map<String, dynamic> json) {
    audited = json['audited'];
    requested = json['requested'];
    cancelNumber = json['cancelNumber'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    commercialCaption = json['commercialCaption'];
    exportTapeCode = json['exportTapeCode'];
    tapeDuration = json['tapeDuration'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    spotAmount = json['spotAmount'];
    spotStatus = json['spotStatus'];
    bookingStatus = json['bookingStatus'];
    logged = json['logged'];
    telecastProgramCode = json['telecastProgramCode'];
    status = json['status'];
    dealno = json['dealno'];
    recordnumber = json['recordnumber'];
    auditedBy = json['auditedBy'];
    auditedOn = json['auditedOn'];
    editable = json['editable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audited'] = this.audited;
    data['requested'] = this.requested;
    data['cancelNumber'] = this.cancelNumber;
    data['locationCode'] = this.locationCode;
    data['channelCode'] = this.channelCode;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['commercialCaption'] = this.commercialCaption;
    data['exportTapeCode'] = this.exportTapeCode;
    data['tapeDuration'] = this.tapeDuration;
    data['programName'] = this.programName;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['spotAmount'] = this.spotAmount;
    data['spotStatus'] = this.spotStatus;
    data['bookingStatus'] = this.bookingStatus;
    data['logged'] = this.logged;
    data['telecastProgramCode'] = this.telecastProgramCode;
    data['status'] = this.status;
    data['dealno'] = this.dealno;
    data['recordnumber'] = this.recordnumber;
    data['auditedBy'] = this.auditedBy;
    data['auditedOn'] = this.auditedOn;
    data['editable'] = this.editable;
    return data;
  }
}
