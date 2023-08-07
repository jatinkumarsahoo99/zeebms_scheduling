class RoCancellationData {
  CancellationData? cancellationData;

  RoCancellationData({this.cancellationData});

  RoCancellationData.fromJson(Map<String, dynamic> json) {
    cancellationData = json['cancellationData'] != null ? CancellationData.fromJson(json['cancellationData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cancellationData != null) {
      data['cancellationData'] = cancellationData!.toJson();
    }
    return data;
  }
}

class CancellationData {
  String? totalAmount;
  String? totalSpots;
  String? totalDuration;
  String? totalValAmount;
  String? bookingEffectiveDate;
  String? enableFalse;
  String? clientName;
  String? agencyName;
  String? brandName;
  String? message;
  String? controlEnableFalse;
  String? controlEnableTrue;
  String? allowColumnsEditing;
  List<LstBookingNoStatusData>? lstBookingNoStatusData;

  CancellationData(
      {this.totalAmount,
      this.totalSpots,
      this.totalDuration,
      this.totalValAmount,
      this.bookingEffectiveDate,
      this.enableFalse,
      this.clientName,
      this.agencyName,
      this.brandName,
      this.message,
      this.controlEnableFalse,
      this.controlEnableTrue,
      this.allowColumnsEditing,
      this.lstBookingNoStatusData});

  CancellationData.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalSpots = json['totalSpots'];
    totalDuration = json['totalDuration'];
    totalValAmount = json['totalValAmount'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    enableFalse = json['enableFalse'];
    clientName = json['clientName'];
    agencyName = json['agencyName'];
    brandName = json['brandName'];
    message = json['message'];
    controlEnableFalse = json['controlEnableFalse'];
    controlEnableTrue = json['controlEnableTrue'];
    allowColumnsEditing = json['allowColumnsEditing'];
    if (json['lstBookingNoStatusData'] != null) {
      lstBookingNoStatusData = <LstBookingNoStatusData>[];
      json['lstBookingNoStatusData'].forEach((v) {
        lstBookingNoStatusData!.add(LstBookingNoStatusData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalAmount'] = totalAmount;
    data['totalSpots'] = totalSpots;
    data['totalDuration'] = totalDuration;
    data['totalValAmount'] = totalValAmount;
    data['bookingEffectiveDate'] = bookingEffectiveDate;
    data['enableFalse'] = enableFalse;
    data['clientName'] = clientName;
    data['agencyName'] = agencyName;
    data['brandName'] = brandName;
    data['message'] = message;
    data['controlEnableFalse'] = controlEnableFalse;
    data['controlEnableTrue'] = controlEnableTrue;
    data['allowColumnsEditing'] = allowColumnsEditing;
    if (lstBookingNoStatusData != null) {
      data['lstBookingNoStatusData'] = lstBookingNoStatusData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstBookingNoStatusData {
  bool? requested, requested1;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? tapeCaption;
  String? tapeID;
  int? tapeDuration;
  int? spotAmount;
  String? cancelNumber;
  int? bookingDetailCode;
  String? dealno;
  int? recordnumber;
  String? locationcode;
  String? channelcode;
  String? bookingnumber;
  String? spotStatus;
  String? bookingStatus;
  String? logged;
  String? telecastProgramCode;
  int? status;
  String? auditedBy;
  String? auditedOn;
  String? clientname;
  String? agencyname;
  int? valuationAmount;

  LstBookingNoStatusData(
      {this.requested,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.tapeCaption,
      this.tapeID,
      this.tapeDuration,
      this.spotAmount,
      this.cancelNumber,
      this.bookingDetailCode,
      this.dealno,
      this.recordnumber,
      this.locationcode,
      this.channelcode,
      this.bookingnumber,
      this.spotStatus,
      this.bookingStatus,
      this.logged,
      this.telecastProgramCode,
      this.status,
      this.auditedBy,
      this.auditedOn,
      this.clientname,
      this.agencyname,
      this.valuationAmount});

  LstBookingNoStatusData.fromJson(Map<String, dynamic> json) {
    requested = json['requested'] ?? false;
    requested1 = json['requested'] ?? false;
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    tapeCaption = json['tapeCaption'];
    tapeID = json['tapeID'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    cancelNumber = json['cancelNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    dealno = json['dealno'];
    recordnumber = json['recordnumber'];
    locationcode = json['locationcode'];
    channelcode = json['channelcode'];
    bookingnumber = json['bookingnumber'];
    spotStatus = json['spotStatus'];
    bookingStatus = json['bookingStatus'];
    logged = json['logged'];
    telecastProgramCode = json['telecastProgramCode'];
    status = json['status'];
    auditedBy = json['auditedBy'];
    auditedOn = json['auditedOn'];
    clientname = json['clientname'];
    agencyname = json['agencyname'];
    valuationAmount = json['valuationAmount'];
  }

  Map<String, dynamic> toJson({bool fromSave = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['requested'] = requested;
      data['programName'] = programName;
      data['scheduleDate'] = scheduleDate;
      data['scheduleTime'] = scheduleTime;
      data['tapeCaption'] = tapeCaption;
      data['tapeID'] = tapeID;
      data['tapeDuration'] = tapeDuration;
      data['spotAmount'] = spotAmount;
      data['cancelNumber'] = cancelNumber;
      data['bookingDetailCode'] = bookingDetailCode;
      data['dealno'] = dealno;
      data['recordnumber'] = recordnumber;
      data['locationcode'] = locationcode;
      data['channelcode'] = channelcode;
      data['bookingnumber'] = bookingnumber;
      data['spotStatus'] = spotStatus;
      data['bookingStatus'] = bookingStatus;
      data['logged'] = logged;
      data['telecastProgramCode'] = telecastProgramCode;
      data['status'] = status;
      data['auditedBy'] = auditedBy;
      data['auditedOn'] = auditedOn;
      data['clientname'] = clientname;
      data['agencyname'] = agencyname;
      data['valuationAmount'] = valuationAmount;
    } else {
      data['requested'] = (requested ?? false).toString();
      data['programName'] = programName;
      data['scheduleDate'] = scheduleDate;
      data['scheduleTime'] = scheduleTime;
      data['tapeCaption'] = tapeCaption;
      data['tapeID'] = tapeID;
      data['tapeDuration'] = tapeDuration;
      data['spotAmount'] = spotAmount;
      data['cancelNumber'] = cancelNumber ?? '';
      data['bookingDetailCode'] = bookingDetailCode;
      data['dealno'] = dealno;
      data['recordnumber'] = recordnumber;
      // data['locationcode'] = locationcode;
      // data['channelcode'] = channelcode;
      data['bookingnumber'] = bookingnumber;
      // data['spotStatus'] = spotStatus;
      // data['bookingStatus'] = bookingStatus;
      // data['logged'] = logged;
      // data['telecastProgramCode'] = telecastProgramCode;
      // data['status'] = status;
      // data['auditedBy'] = auditedBy;
      // data['auditedOn'] = auditedOn;
      // data['clientname'] = clientname;
      // data['agencyname'] = agencyname;
      data['valuationAmount'] = valuationAmount;
    }
    return data;
  }
}
