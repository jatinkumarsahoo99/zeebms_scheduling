class AuditStatusReschduleDisplay {
  List<LstReshedule>? lstReshedule;
  List<LstBooking>? lstBooking;

  AuditStatusReschduleDisplay({this.lstReshedule, this.lstBooking});

  AuditStatusReschduleDisplay.fromJson(Map<String, dynamic> json) {
    if (json['lstReshedule'] != null) {
      lstReshedule = <LstReshedule>[];
      json['lstReshedule'].forEach((v) {
        lstReshedule!.add(LstReshedule.fromJson(v));
      });
    }
    if (json['lstBooking'] != null) {
      lstBooking = <LstBooking>[];
      json['lstBooking'].forEach((v) {
        lstBooking!.add(LstBooking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (lstReshedule != null) {
      data['lstReshedule'] = lstReshedule!.map((v) => v.toJson()).toList();
    }
    if (lstBooking != null) {
      data['lstBooking'] = lstBooking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstReshedule {
  bool? auditStatus;
  String? rescheduleNo;
  int? audited;
  int? rowNumber;
  String? scheduleDate;
  String? programName;
  String? startTime;
  String? endTime;
  String? tapeCode;
  int? segmentNumber;
  String? commercialCaption;
  int? tapeDuration;
  int? spotAmount;
  int? totalspots;
  String? dealNo;
  int? dealRowNumber;
  int? bookingDetailCode;
  String? spotPositionTypeName;
  String? positionName;
  int? breakNumber;
  String? auditedby;
  String? auditedon;
  String? midPre;
  String? positionCode;
  String? locationCode;
  String? channelCode;
  String? bookingNumber;
  String? commercialCode;
  String? programcode;

  LstReshedule(
      {this.auditStatus,
      this.rescheduleNo,
      this.audited,
      this.rowNumber,
      this.scheduleDate,
      this.programName,
      this.startTime,
      this.endTime,
      this.tapeCode,
      this.segmentNumber,
      this.commercialCaption,
      this.tapeDuration,
      this.spotAmount,
      this.totalspots,
      this.dealNo,
      this.dealRowNumber,
      this.bookingDetailCode,
      this.spotPositionTypeName,
      this.positionName,
      this.breakNumber,
      this.auditedby,
      this.auditedon,
      this.midPre,
      this.positionCode,
      this.locationCode,
      this.channelCode,
      this.bookingNumber,
      this.commercialCode,
      this.programcode});

  LstReshedule.fromJson(Map<String, dynamic> json) {
    auditStatus = json['auditStatus'];
    rescheduleNo = json['rescheduleNo'];
    audited = json['audited'];
    rowNumber = json['rowNumber'];
    scheduleDate = json['scheduleDate'];
    programName = json['programName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    tapeCode = json['tapeCode'];
    segmentNumber = json['segmentNumber'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    totalspots = json['totalspots'];
    dealNo = json['dealNo'];
    dealRowNumber = json['dealRowNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    spotPositionTypeName = json['spotPositionTypeName'];
    positionName = json['positionName'];
    breakNumber = json['breakNumber'];
    auditedby = json['auditedby'];
    auditedon = json['auditedon'];
    midPre = json['midPre'];
    positionCode = json['positionCode'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    bookingNumber = json['bookingNumber'];
    commercialCode = json['commercialCode'];
    programcode = json['programcode'];
  }

  Map<String, dynamic> toJson({bool fromSave = true}) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (fromSave) {
      data['auditStatus'] = auditStatus;
      data['rescheduleNo'] = rescheduleNo;
      data['audited'] = audited;
      data['rowNumber'] = rowNumber;
      data['scheduleDate'] = scheduleDate;
      data['programName'] = programName;
      data['startTime'] = startTime;
      data['endTime'] = endTime;
      data['tapeCode'] = tapeCode;
      data['segmentNumber'] = segmentNumber;
      data['commercialCaption'] = commercialCaption;
      data['tapeDuration'] = tapeDuration;
      data['spotAmount'] = spotAmount;
      data['totalspots'] = totalspots;
      data['dealNo'] = dealNo;
      data['dealRowNumber'] = dealRowNumber;
      data['bookingDetailCode'] = bookingDetailCode;
      data['spotPositionTypeName'] = spotPositionTypeName;
      data['positionName'] = positionName;
      data['breakNumber'] = breakNumber;
      data['auditedby'] = auditedby;
      data['auditedon'] = auditedon;
      data['midPre'] = midPre;
      data['positionCode'] = positionCode;
      data['locationCode'] = locationCode;
      data['channelCode'] = channelCode;
      data['bookingNumber'] = bookingNumber;
      data['commercialCode'] = commercialCode;
      data['programcode'] = programcode;
    } else {
      data['auditStatus'] = (auditStatus ?? false).toString();
      data['rescheduleNo'] = rescheduleNo;
      data['audited'] = audited;
      data['rowNumber'] = rowNumber;
      data['scheduleDate'] = scheduleDate;
      data['programName'] = programName;
      data['startTime'] = startTime;
      data['endTime'] = endTime;
      data['tapeCode'] = tapeCode;
      data['segmentNumber'] = segmentNumber;
      data['commercialCaption'] = commercialCaption;
      data['tapeDuration'] = tapeDuration;
      data['spotAmount'] = spotAmount;
      data['totalspots'] = totalspots;
      data['dealNo'] = dealNo;
      data['dealRowNumber'] = dealRowNumber;
      data['bookingDetailCode'] = bookingDetailCode;
      data['spotPositionTypeName'] = spotPositionTypeName;
      data['positionName'] = positionName;
      data['breakNumber'] = breakNumber;
      data['auditedby'] = auditedby;
      data['auditedon'] = auditedon;
      data['midPre'] = midPre;
      data['positionCode'] = positionCode;
      data['locationCode'] = locationCode;
      data['channelCode'] = channelCode;
      data['bookingNumber'] = bookingNumber;
      data['commercialCode'] = commercialCode;
      data['programcode'] = programcode;
    }
    return data;
  }
}

class LstBooking {
  String? scheduleDate;
  String? programName;
  String? startTime;
  String? tapeCode;
  String? commercialCaption;
  int? tapeDuration;
  String? bookingNumber;
  int? bookingDetailCode;

  LstBooking(
      {this.scheduleDate,
      this.programName,
      this.startTime,
      this.tapeCode,
      this.commercialCaption,
      this.tapeDuration,
      this.bookingNumber,
      this.bookingDetailCode});

  LstBooking.fromJson(Map<String, dynamic> json) {
    scheduleDate = json['scheduleDate'];
    programName = json['programName'];
    startTime = json['startTime'];
    tapeCode = json['tapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scheduleDate'] = scheduleDate;
    data['programName'] = programName;
    data['startTime'] = startTime;
    data['tapeCode'] = tapeCode;
    data['commercialCaption'] = commercialCaption;
    data['tapeDuration'] = tapeDuration;
    data['bookingNumber'] = bookingNumber;
    data['bookingDetailCode'] = bookingDetailCode;
    return data;
  }
}
