class SalesAuditGetRetrieveModel {
  Gettables? gettables;

  SalesAuditGetRetrieveModel({this.gettables});

  SalesAuditGetRetrieveModel.fromJson(Map<String, dynamic> json) {
    gettables = json['gettables'] != null
        ? new Gettables.fromJson(json['gettables'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gettables != null) {
      data['gettables'] = this.gettables!.toJson();
    }
    return data;
  }
}

class Gettables {
  List<LstAsrunlog1>? lstAsrunlog1=[];
  List<LstAsrunlog2>? lstAsrunlog2=[];
  String? asrunStatus;

  Gettables({this.lstAsrunlog1, this.lstAsrunlog2, this.asrunStatus});

  Gettables.fromJson(Map<String, dynamic> json) {
    // lstAsrunlog1 = json['lstAsrunlog1'];
    asrunStatus = json['asrunStatus'];
    if (json['lstAsrunlog2'] != null) {
      lstAsrunlog2 = <LstAsrunlog2>[];
      json['lstAsrunlog2'].forEach((v) {
        lstAsrunlog2!.add(new LstAsrunlog2.fromJson(v));
      });
    }

    if (json['lstAsrunlog1'] != null) {
      lstAsrunlog1 = <LstAsrunlog1>[];
      json['lstAsrunlog1'].forEach((v) {
        lstAsrunlog1!.add(new LstAsrunlog1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['lstAsrunlog1'] = this.lstAsrunlog1;
    if (this.lstAsrunlog2 != null) {
      data['lstAsrunlog2'] = this.lstAsrunlog2!.map((v) => v.toJson()).toList();
    }
    if (this.lstAsrunlog1 != null) {
      data['lstAsrunlog1'] = this.lstAsrunlog1!.map((v) => v.toJson()).toList();
    }
    data['asrunStatus'] = this.asrunStatus;
    return data;
  }
}

class LstAsrunlog2 {
  String? locationcode;
  String? channelcode;
  String? bookingNumber;
  int? bookingDetailCode;
  String? scheduleTime;
  String? exportTapeCode;
  String? exportTapeCaption;
  String? spotamount;
  int? tapeDuration;
  String? telecastTime;
  String? dealno;
  int? recordnumber;
  String? bookingStatus;
  String? previousBookingStatus;
  String? scheduleProgramCode;
  String? auditedOn;
  String? telecastProgram;
  int? rowNumber;
  String? remarks;
  String? remarks1;
  String? programName;
  String? dealTime;
  String? programCode;
  String? reSchTape;
  String? reSchCaption;
  String? reSchDate;

  LstAsrunlog2(
      {this.locationcode,
        this.channelcode,
        this.bookingNumber,
        this.bookingDetailCode,
        this.scheduleTime,
        this.exportTapeCode,
        this.exportTapeCaption,
        this.spotamount,
        this.tapeDuration,
        this.telecastTime,
        this.dealno,
        this.recordnumber,
        this.bookingStatus,
        this.scheduleProgramCode,
        this.auditedOn,
        this.telecastProgram,
        this.rowNumber,
        this.remarks,
        this.remarks1,
        this.programName,
        this.dealTime,
        this.programCode,
        this.reSchTape,
        this.reSchCaption,
        this.reSchDate,
        this.previousBookingStatus
      });

  LstAsrunlog2.fromJson(Map<String, dynamic> json) {
    locationcode = json['locationcode'];
    channelcode = json['channelcode'];
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    scheduleTime = json['scheduleTime'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    spotamount = (json['Spotamount']??"0").toString();
    tapeDuration = json['tapeDuration'];
    telecastTime = json['telecastTime'];
    dealno = json['dealno'];
    recordnumber = json['recordnumber'];
    bookingStatus = json['bookingStatus'];
    scheduleProgramCode = json['scheduleProgramCode'];
    auditedOn = json['auditedOn'];
    telecastProgram = json['telecastProgram'];
    rowNumber = json['rowNumber'];
    remarks = json['remarks'];
    remarks1 = json['remarks1'];
    programName = json['programName'];
    dealTime = json['dealTime'];
    programCode = json['programCode'];
    reSchTape = json['reSchTape'];
    reSchCaption = json['reSchCaption'];
    // reSchDate = json['reSchDate'];
    reSchDate = "";
    previousBookingStatus = json['previousBookingStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationcode'] = this.locationcode;
    data['channelcode'] = this.channelcode;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['scheduleTime'] = this.scheduleTime;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['Spotamount'] = this.spotamount;
    // data['Spotamount'] = double.tryParse((this.spotamount != null && this.spotamount != "")?this.spotamount.toString():"0")??0.00;
    data['tapeDuration'] = this.tapeDuration;
    data['telecastTime'] = this.telecastTime;
    data['dealno'] = this.dealno;
    data['recordnumber'] = this.recordnumber;
    data['bookingStatus'] = this.bookingStatus;
    data['scheduleProgramCode'] = this.scheduleProgramCode;
    data['auditedOn'] = this.auditedOn;
    data['telecastProgram'] = this.telecastProgram;
    data['rowNumber'] = this.rowNumber;
    data['remarks'] = this.remarks;
    data['remarks1'] = this.remarks1;
    data['programName'] = this.programName;
    data['dealTime'] = this.dealTime;
    data['programCode'] = this.programCode;
    data['reSchTape'] = this.reSchTape;
    data['reSchCaption'] = this.reSchCaption;
    data['reSchDate'] = this.reSchDate;
    data['previousBookingStatus'] = this.previousBookingStatus;
    return data;
  }
  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*data['locationcode'] = this.locationcode;
    data['channelcode'] = this.channelcode;*/

    data['bookingNumber'] = this.bookingNumber??"";
    data['bookingDetailCode'] = this.bookingDetailCode??"";
    data['telecastTime'] = "2023-03-03T${(this.telecastTime != null &&
        this.telecastTime.toString().trim() != "" )? this.telecastTime:'00:00:00'}" ;

    data['programCode'] = this.programCode??"";
    data['tapeDuration'] = this.tapeDuration;
    data['bookingStatus'] = this.bookingStatus;
    data['rowNumber'] = this.rowNumber;
    data['remarks'] = this.remarks;

    return data;
  }
}

class LstAsrunlog1 {
  int? rownumber;
  String? exportTapeCode;
  String? exportTapeCaption;
  int? tapeDuration;
  String? telecastTime;
  String? telecastDate;
  String? fpctime;
  String? bookingNumber;
  int? bookingDetailCode;
  String? programCode;
  String? programName;
  String? remark;

  LstAsrunlog1(
      {this.rownumber,
        this.exportTapeCode,
        this.exportTapeCaption,
        this.tapeDuration,
        this.telecastTime,
        this.telecastDate,
        this.fpctime,
        this.bookingNumber,
        this.bookingDetailCode,
        this.programCode,
        this.programName,
        this.remark});

  LstAsrunlog1.fromJson(Map<String, dynamic> json) {
    rownumber = json['rownumber'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    tapeDuration = json['tapeDuration'];
    telecastTime = json['telecastTime'];
    telecastDate = json['telecastDate'];
    fpctime = json['fpctime'];
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    programCode = json['programCode'];
    programName = json['programName'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rownumber'] = this.rownumber;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['tapeDuration'] = this.tapeDuration;
    data['telecastTime'] = this.telecastTime;
    data['telecastDate'] = this.telecastDate;
    data['fpctime'] = this.fpctime;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['programCode'] = this.programCode;
    data['programName'] = this.programName;
    data['remark'] = this.remark;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['telecastTime'] =  "2023-03-03T${(this.telecastTime != null &&
        this.telecastTime.toString().trim()  != "" )?this.telecastTime : '00:00:00'}";

    data['exportTapeCode'] = this.exportTapeCode;
    data['tapeDuration'] = this.tapeDuration;
    data['programCode'] = this.programCode;
    data['remark'] = this.remark;

    return data;
  }

}