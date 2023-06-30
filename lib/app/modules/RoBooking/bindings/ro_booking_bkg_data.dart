class RoBookingBkgNOLeaveData {
  int? intEditMode;
  int? intPDCReqd;
  String? dblOldBookingAmount;
  String? locationCode;
  String? channelcode;
  String? bookingEffectiveDate;
  String? bookingDate;
  String? bookingReferenceNumber;
  String? bookingReferenceDate;
  String? zone;
  String? zonename;
  String? zonecode;
  String? clientcode;
  List<LstClientAgency>? lstClientAgency;
  String? dealno;
  List<LstDealNumber>? lstDealNumber;
  String? agencycode;
  List<LstAgency>? lstAgency;
  String? payrouteName;
  String? payroutecode;
  String? brandcode;
  List<LstBrand>? lstBrand;
  String? executiveCode;
  String? maxSpend;
  String? dealFromDate;
  String? dealtoDate;
  String? secondaryEventId;
  String? secondaryEvent;
  String? triggerId;
  String? triggerCaption;
  String? modifiedBy;
  String? verifiedby;
  bool? btnSaveEnable;
  List<LstAddInfo>? lstAddInfo;
  String? dealType;
  String? payMode;
  String? message;
  List<LstdgvDealDetails>? lstdgvDealDetails;
  String? previousBookedAmount;
  String? previousValAmount;
  List<LstMakeGood>? lstMakeGood;
  List<LstSpots>? lstSpots;
  List? lstPdcList;
  String? pdcID;
  String? pdcAmount;
  String? pdcBankName;
  String? totalSpots;
  String? totalDuration;
  String? totalAmount;
  String? revenueType;
  String? accountCode;
  String? gstPlantID;
  String? gstRegNo;
  String? gstPlantIDCheck;
  String? gstRegNoCheck;
  String? gstRegN;
  String? gstPlants;

  RoBookingBkgNOLeaveData(
      {this.intEditMode,
      this.intPDCReqd,
      this.dblOldBookingAmount,
      this.locationCode,
      this.channelcode,
      this.bookingEffectiveDate,
      this.bookingDate,
      this.bookingReferenceNumber,
      this.bookingReferenceDate,
      this.zone,
      this.zonename,
      this.zonecode,
      this.clientcode,
      this.lstClientAgency,
      this.dealno,
      this.lstDealNumber,
      this.agencycode,
      this.lstAgency,
      this.payrouteName,
      this.payroutecode,
      this.brandcode,
      this.lstBrand,
      this.executiveCode,
      this.maxSpend,
      this.dealFromDate,
      this.dealtoDate,
      this.secondaryEventId,
      this.secondaryEvent,
      this.triggerId,
      this.triggerCaption,
      this.modifiedBy,
      this.verifiedby,
      this.btnSaveEnable,
      this.lstAddInfo,
      this.dealType,
      this.payMode,
      this.message,
      this.lstdgvDealDetails,
      this.previousBookedAmount,
      this.previousValAmount,
      this.lstMakeGood,
      this.lstSpots,
      this.lstPdcList,
      this.pdcID,
      this.pdcAmount,
      this.pdcBankName,
      this.totalSpots,
      this.totalDuration,
      this.totalAmount,
      this.revenueType,
      this.accountCode,
      this.gstPlantID,
      this.gstRegNo,
      this.gstPlantIDCheck,
      this.gstRegNoCheck,
      this.gstRegN,
      this.gstPlants});

  RoBookingBkgNOLeaveData.fromJson(Map<String, dynamic> json) {
    intEditMode = json['intEditMode'];
    intPDCReqd = json['intPDCReqd'];
    dblOldBookingAmount = json['dblOldBookingAmount'];
    locationCode = json['locationCode'];
    channelcode = json['channelcode'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    bookingDate = json['bookingDate'];
    bookingReferenceNumber = json['bookingReferenceNumber'];
    bookingReferenceDate = json['bookingReferenceDate'];
    zone = json['zone'];
    zonename = json['zonename'];
    zonecode = json['zonecode'];
    clientcode = json['clientcode'];
    if (json['lstClientAgency'] != null) {
      lstClientAgency = <LstClientAgency>[];
      json['lstClientAgency'].forEach((v) {
        lstClientAgency!.add(LstClientAgency.fromJson(v));
      });
    }
    dealno = json['dealno'];
    if (json['lstDealNumber'] != null) {
      lstDealNumber = <LstDealNumber>[];
      json['lstDealNumber'].forEach((v) {
        lstDealNumber!.add(LstDealNumber.fromJson(v));
      });
    }
    agencycode = json['agencycode'];
    if (json['lstAgency'] != null) {
      lstAgency = <LstAgency>[];
      json['lstAgency'].forEach((v) {
        lstAgency!.add(LstAgency.fromJson(v));
      });
    }
    payrouteName = json['payrouteName'];
    payroutecode = json['payroutecode'];
    brandcode = json['brandcode'];
    if (json['lstBrand'] != null) {
      lstBrand = <LstBrand>[];
      json['lstBrand'].forEach((v) {
        lstBrand!.add(LstBrand.fromJson(v));
      });
    }
    executiveCode = json['executiveCode'];

    maxSpend = json['maxSpend'];
    dealFromDate = json['dealFromDate'];
    dealtoDate = json['dealtoDate'];

    secondaryEventId = json['secondaryEventId'];
    secondaryEvent = json['secondaryEvent'];
    triggerId = json['triggerId'];
    triggerCaption = json['triggerCaption'];
    modifiedBy = json['modifiedBy'];
    verifiedby = json['verifiedby'];
    btnSaveEnable = json['btnSave_Enable'];
    if (json['lstAddInfo'] != null) {
      lstAddInfo = <LstAddInfo>[];
      json['lstAddInfo'].forEach((v) {
        lstAddInfo!.add(LstAddInfo.fromJson(v));
      });
    }
    dealType = json['dealType'];
    payMode = json['payMode'];
    message = json['message'];
    if (json['lstdgvDealDetails'] != null) {
      lstdgvDealDetails = <LstdgvDealDetails>[];
      json['lstdgvDealDetails'].forEach((v) {
        lstdgvDealDetails!.add(LstdgvDealDetails.fromJson(v));
      });
    }
    previousBookedAmount = json['previousBookedAmount'];
    previousValAmount = json['previousValAmount'];
    if (json['lstMakeGood'] != null) {
      lstMakeGood = <LstMakeGood>[];
      json['lstMakeGood'].forEach((v) {
        lstMakeGood!.add(LstMakeGood.fromJson(v));
      });
    }
    if (json['lstSpots'] != null) {
      lstSpots = <LstSpots>[];
      json['lstSpots'].forEach((v) {
        lstSpots!.add(LstSpots.fromJson(v));
      });
    }
    if (json['lstPdcList'] != null) {
      lstPdcList = [];
      json['lstPdcList'].forEach((v) {
        lstPdcList!.add(v);
      });
    }
    pdcID = json['pdcID'];
    pdcAmount = json['pdcAmount'];
    pdcBankName = json['pdcBankName'];
    totalSpots = json['totalSpots'];
    totalDuration = json['totalDuration'];
    totalAmount = json['totalAmount'];
    revenueType = json['revenueType'];
    accountCode = json['accountCode'];
    gstPlantID = json['gstPlantID'];
    gstRegNo = json['gstRegNo'];
    gstPlantIDCheck = json['gstPlantID_Check'];
    gstRegNoCheck = json['gstRegNo_Check'];
    gstRegN = json['gstRegN'];
    gstPlants = json['gstPlants'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['intEditMode'] = intEditMode;
    data['intPDCReqd'] = intPDCReqd;
    data['dblOldBookingAmount'] = dblOldBookingAmount;
    data['locationCode'] = locationCode;
    data['channelcode'] = channelcode;
    data['bookingEffectiveDate'] = bookingEffectiveDate;
    data['bookingDate'] = bookingDate;
    data['bookingReferenceNumber'] = bookingReferenceNumber;
    data['bookingReferenceDate'] = bookingReferenceDate;
    data['zone'] = zone;
    data['zonename'] = zonename;
    data['zonecode'] = zonecode;
    data['clientcode'] = clientcode;
    if (lstClientAgency != null) {
      data['lstClientAgency'] =
          lstClientAgency!.map((v) => v.toJson()).toList();
    }
    data['dealno'] = dealno;
    if (lstDealNumber != null) {
      data['lstDealNumber'] = lstDealNumber!.map((v) => v.toJson()).toList();
    }
    data['agencycode'] = agencycode;
    if (lstAgency != null) {
      data['lstAgency'] = lstAgency!.map((v) => v.toJson()).toList();
    }
    data['payrouteName'] = payrouteName;
    data['payroutecode'] = payroutecode;
    data['brandcode'] = brandcode;
    if (lstBrand != null) {
      data['lstBrand'] = lstBrand!.map((v) => v.toJson()).toList();
    }
    data['executiveCode'] = executiveCode;
    data['maxSpend'] = maxSpend;
    data['dealFromDate'] = dealFromDate;
    data['dealtoDate'] = dealtoDate;
    data['secondaryEventId'] = secondaryEventId;
    data['secondaryEvent'] = secondaryEvent;
    data['triggerId'] = triggerId;
    data['triggerCaption'] = triggerCaption;
    data['modifiedBy'] = modifiedBy;
    data['verifiedby'] = verifiedby;
    data['btnSave_Enable'] = btnSaveEnable;
    if (lstAddInfo != null) {
      data['lstAddInfo'] = lstAddInfo!.map((v) => v.toJson()).toList();
    }
    data['dealType'] = dealType;
    data['payMode'] = payMode;
    data['message'] = message;
    if (lstdgvDealDetails != null) {
      data['lstdgvDealDetails'] =
          lstdgvDealDetails!.map((v) => v.toJson()).toList();
    }
    data['previousBookedAmount'] = previousBookedAmount;
    data['previousValAmount'] = previousValAmount;
    if (lstMakeGood != null) {
      data['lstMakeGood'] = lstMakeGood!.map((v) => v.toJson()).toList();
    }
    if (lstSpots != null) {
      data['lstSpots'] = lstSpots!.map((v) => v.toJson()).toList();
    }
    if (lstPdcList != null) {
      data['lstPdcList'] = lstPdcList!.map((v) => v.toJson()).toList();
    }
    data['pdcID'] = pdcID;
    data['pdcAmount'] = pdcAmount;
    data['pdcBankName'] = pdcBankName;
    data['totalSpots'] = totalSpots;
    data['totalDuration'] = totalDuration;
    data['totalAmount'] = totalAmount;
    data['revenueType'] = revenueType;
    data['accountCode'] = accountCode;
    data['gstPlantID'] = gstPlantID;
    data['gstRegNo'] = gstRegNo;
    data['gstPlantID_Check'] = gstPlantIDCheck;
    data['gstRegNo_Check'] = gstRegNoCheck;
    data['gstRegN'] = gstRegN;
    data['gstPlants'] = gstPlants;
    return data;
  }
}

class LstClientAgency {
  String? clientname;
  String? clientcode;

  LstClientAgency({this.clientname, this.clientcode});

  LstClientAgency.fromJson(Map<String, dynamic> json) {
    clientname = json['clientname'];
    clientcode = json['clientcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientname'] = clientname;
    data['clientcode'] = clientcode;
    return data;
  }
}

class LstDealNumber {
  String? dealNumber;
  String? dealNumber2;

  LstDealNumber({this.dealNumber, this.dealNumber2});

  LstDealNumber.fromJson(Map<String, dynamic> json) {
    dealNumber = json['dealNumber'];
    dealNumber2 = json['dealNumber2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealNumber'] = dealNumber;
    data['dealNumber2'] = dealNumber2;
    return data;
  }
}

class LstAgency {
  String? agencycode;
  String? agencyname;

  LstAgency({this.agencycode, this.agencyname});

  LstAgency.fromJson(Map<String, dynamic> json) {
    agencycode = json['agencycode'];
    agencyname = json['agencyname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agencycode'] = agencycode;
    data['agencyname'] = agencyname;
    return data;
  }
}

class LstBrand {
  String? brandcode;
  String? brandname;

  LstBrand({this.brandcode, this.brandname});

  LstBrand.fromJson(Map<String, dynamic> json) {
    brandcode = json['brandcode'];
    brandname = json['brandname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandcode'] = brandcode;
    data['brandname'] = brandname;
    return data;
  }
}

class LstAddInfo {
  String? infoname;
  String? infovalue;
  int? isRequired;
  String? allowedValues;

  LstAddInfo(
      {this.infoname, this.infovalue, this.isRequired, this.allowedValues});

  LstAddInfo.fromJson(Map<String, dynamic> json) {
    infoname = json['infoname'];
    infovalue = json['infovalue'];
    isRequired = json['isRequired'];
    allowedValues = json['allowedValues'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['infoname'] = infoname;
    data['infovalue'] = infovalue;
    data['isRequired'] = isRequired;
    data['allowedValues'] = allowedValues;
    return data;
  }
}

class LstdgvDealDetails {
  int? primaryEventCode;
  int? recordnumber;
  String? networkName;
  String? timeBand;
  String? sponsorTypeName;
  String? programName;
  String? startTime;
  String? endTime;
  num? rate;
  int? seconds;
  num? amount;
  num? valuationRate;
  int? bookedSeconds;
  int? balanceSeconds;
  int? sun;
  int? mon;
  int? tue;
  int? wed;
  int? thu;
  int? fri;
  int? sat;
  int? revFlag;
  String? accountName;
  String? eventName;
  int? spots;
  String? paymentModeCaption;
  String? revenueTypeName;
  String? subRevenueTypeName;
  String? programCategoryName;
  String? sponsorTypeCode;
  String? programCode;
  String? programCategoryCode;
  String? bandcode;
  int? netcode;
  String? accountCode;
  int? eventCode;
  String? revenueTypeCode;
  int? subrevenuetypecode;
  String? locationname;
  String? channelname;
  String? dealNumber;
  String? clientname;
  String? agencyname;
  String? dealStartDate;
  String? dealEndDate;
  String? recoTakenOn;
  num? dealValuationAmount;
  num? bookedAmount;
  num? bookedValuationAmount;
  num? balanceAmount;
  num? balanceValuationAmount;
  int? countbased;
  int? baseduration;
  String? locationcode;
  String? channelcode;

  LstdgvDealDetails(
      {this.primaryEventCode,
      this.recordnumber,
      this.networkName,
      this.timeBand,
      this.sponsorTypeName,
      this.programName,
      this.startTime,
      this.endTime,
      this.rate,
      this.seconds,
      this.amount,
      this.valuationRate,
      this.bookedSeconds,
      this.balanceSeconds,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.sat,
      this.revFlag,
      this.accountName,
      this.eventName,
      this.spots,
      this.paymentModeCaption,
      this.revenueTypeName,
      this.subRevenueTypeName,
      this.programCategoryName,
      this.sponsorTypeCode,
      this.programCode,
      this.programCategoryCode,
      this.bandcode,
      this.netcode,
      this.accountCode,
      this.eventCode,
      this.revenueTypeCode,
      this.subrevenuetypecode,
      this.locationname,
      this.channelname,
      this.dealNumber,
      this.clientname,
      this.agencyname,
      this.dealStartDate,
      this.dealEndDate,
      this.recoTakenOn,
      this.dealValuationAmount,
      this.bookedAmount,
      this.bookedValuationAmount,
      this.balanceAmount,
      this.balanceValuationAmount,
      this.countbased,
      this.baseduration,
      this.locationcode,
      this.channelcode});

  LstdgvDealDetails.fromJson(Map<String, dynamic> json) {
    primaryEventCode = json['primaryEventCode'];
    recordnumber = json['recordnumber'];
    networkName = json['networkName'];
    timeBand = json['timeBand'];
    sponsorTypeName = json['sponsorTypeName'];
    programName = json['programName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    rate = json['rate'];
    seconds = json['seconds'];
    amount = json['amount'];
    valuationRate = json['valuationRate'];
    bookedSeconds = json['bookedSeconds'];
    balanceSeconds = json['balanceSeconds'];
    sun = json['sun'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
    revFlag = json['revFlag'];
    accountName = json['accountName'];
    eventName = json['eventName'];
    spots = json['spots'];
    paymentModeCaption = json['paymentModeCaption'];
    revenueTypeName = json['revenueTypeName'];
    subRevenueTypeName = json['subRevenueTypeName'];
    programCategoryName = json['programCategoryName'];
    sponsorTypeCode = json['sponsorTypeCode'];
    programCode = json['programCode'];
    programCategoryCode = json['programCategoryCode'];
    bandcode = json['bandcode'];
    netcode = json['netcode'];
    accountCode = json['accountCode'];
    eventCode = json['eventCode'];
    revenueTypeCode = json['revenueTypeCode'];
    subrevenuetypecode = json['subrevenuetypecode'];
    locationname = json['locationname'];
    channelname = json['channelname'];
    dealNumber = json['dealNumber'];
    clientname = json['clientname'];
    agencyname = json['agencyname'];
    dealStartDate = json['dealStartDate'];
    dealEndDate = json['dealEndDate'];
    recoTakenOn = json['recoTakenOn'];
    dealValuationAmount = json['dealValuationAmount'];
    bookedAmount = json['bookedAmount'];
    bookedValuationAmount = json['bookedValuationAmount'];
    balanceAmount = json['balanceAmount'];
    balanceValuationAmount = json['balanceValuationAmount'];
    countbased = json['countbased'];
    baseduration = json['baseduration'];
    locationcode = json['locationcode'];
    channelcode = json['channelcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primaryEventCode'] = primaryEventCode;
    data['recordnumber'] = recordnumber;
    data['networkName'] = networkName;
    data['timeBand'] = timeBand;
    data['sponsorTypeName'] = sponsorTypeName;
    data['programName'] = programName;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['rate'] = rate;
    data['seconds'] = seconds;
    data['amount'] = amount;
    data['valuationRate'] = valuationRate;
    data['bookedSeconds'] = bookedSeconds;
    data['balanceSeconds'] = balanceSeconds;
    data['sun'] = sun;
    data['mon'] = mon;
    data['tue'] = tue;
    data['wed'] = wed;
    data['thu'] = thu;
    data['fri'] = fri;
    data['sat'] = sat;
    data['revFlag'] = revFlag;
    data['accountName'] = accountName;
    data['eventName'] = eventName;
    data['spots'] = spots;
    data['paymentModeCaption'] = paymentModeCaption;
    data['revenueTypeName'] = revenueTypeName;
    data['subRevenueTypeName'] = subRevenueTypeName;
    data['programCategoryName'] = programCategoryName;
    data['sponsorTypeCode'] = sponsorTypeCode;
    data['programCode'] = programCode;
    data['programCategoryCode'] = programCategoryCode;
    data['bandcode'] = bandcode;
    data['netcode'] = netcode;
    data['accountCode'] = accountCode;
    data['eventCode'] = eventCode;
    data['revenueTypeCode'] = revenueTypeCode;
    data['subrevenuetypecode'] = subrevenuetypecode;
    data['locationname'] = locationname;
    data['channelname'] = channelname;
    data['dealNumber'] = dealNumber;
    data['clientname'] = clientname;
    data['agencyname'] = agencyname;
    data['dealStartDate'] = dealStartDate;
    data['dealEndDate'] = dealEndDate;
    data['recoTakenOn'] = recoTakenOn;
    data['dealValuationAmount'] = dealValuationAmount;
    data['bookedAmount'] = bookedAmount;
    data['bookedValuationAmount'] = bookedValuationAmount;
    data['balanceAmount'] = balanceAmount;
    data['balanceValuationAmount'] = balanceValuationAmount;
    data['countbased'] = countbased;
    data['baseduration'] = baseduration;
    data['locationcode'] = locationcode;
    data['channelcode'] = channelcode;
    return data;
  }
}

class LstMakeGood {
  bool? selectRow;
  String? bookingNumber;
  int? bookingDetailCode;
  String? dealno;
  String? recordNumber;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? clientName;
  String? agencyName;
  String? bookingReferenceNumber;
  String? brandName;
  String? exportTapeCode;
  String? commercialCaption;
  String? tapeDuration;
  String? spotAmount;
  String? er;
  String? ros;
  String? cancelRefNoRemarks;
  String? startTime;
  String? endTime;
  String? zoneName;
  String? cancelNumber;
  String? cancelDate;

  LstMakeGood(
      {this.selectRow,
      this.bookingNumber,
      this.bookingDetailCode,
      this.dealno,
      this.recordNumber,
      this.programName,
      this.scheduleDate,
      this.scheduleTime,
      this.clientName,
      this.agencyName,
      this.bookingReferenceNumber,
      this.brandName,
      this.exportTapeCode,
      this.commercialCaption,
      this.tapeDuration,
      this.spotAmount,
      this.er,
      this.ros,
      this.cancelRefNoRemarks,
      this.startTime,
      this.endTime,
      this.zoneName,
      this.cancelNumber,
      this.cancelDate});

  LstMakeGood.fromJson(Map<String, dynamic> json) {
    selectRow = json['selectRow'];
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    dealno = json['dealno'];
    recordNumber = json['recordNumber'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    clientName = json['clientName'];
    agencyName = json['agencyName'];
    bookingReferenceNumber = json['bookingReferenceNumber'];
    brandName = json['brandName'];
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    er = json['er'];
    ros = json['ros'];
    cancelRefNoRemarks = json['cancelRefNoRemarks'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    zoneName = json['zoneName'];
    cancelNumber = json['cancelNumber'];
    cancelDate = json['cancelDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['selectRow'] = selectRow;
    data['bookingNumber'] = bookingNumber;
    data['bookingDetailCode'] = bookingDetailCode;
    data['dealno'] = dealno;
    data['recordNumber'] = recordNumber;
    data['programName'] = programName;
    data['scheduleDate'] = scheduleDate;
    data['scheduleTime'] = scheduleTime;
    data['clientName'] = clientName;
    data['agencyName'] = agencyName;
    data['bookingReferenceNumber'] = bookingReferenceNumber;
    data['brandName'] = brandName;
    data['exportTapeCode'] = exportTapeCode;
    data['commercialCaption'] = commercialCaption;
    data['tapeDuration'] = tapeDuration;
    data['spotAmount'] = spotAmount;
    data['er'] = er;
    data['ros'] = ros;
    data['cancelRefNoRemarks'] = cancelRefNoRemarks;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['zoneName'] = zoneName;
    data['cancelNumber'] = cancelNumber;
    data['cancelDate'] = cancelDate;
    return data;
  }
}

class LstSpots {
  String? programName;
  String? telecastDate;
  String? startTime;
  String? endTime;
  int? spots;
  String? tapeId;
  int? segmentNumber;
  int? tapeDuration;
  String? spotPositionTypeName;
  int? breaknumber;
  String? positionName;
  int? ratePer10Sec;
  int? spotAmount;
  String? dealNo;
  int? dealrownumber;
  String? toNo;
  String? schId;
  String? commercialCaption;
  String? programCode;
  String? spotPositionTypeCode;
  String? positionCode;

  LstSpots(
      {this.programName,
      this.telecastDate,
      this.startTime,
      this.endTime,
      this.spots,
      this.tapeId,
      this.segmentNumber,
      this.tapeDuration,
      this.spotPositionTypeName,
      this.breaknumber,
      this.positionName,
      this.ratePer10Sec,
      this.spotAmount,
      this.dealNo,
      this.dealrownumber,
      this.toNo,
      this.schId,
      this.commercialCaption,
      this.programCode,
      this.spotPositionTypeCode,
      this.positionCode});

  LstSpots.fromJson(Map<String, dynamic> json) {
    programName = json['programName'];
    telecastDate = json['telecastDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    spots = json['spots'];
    tapeId = json['tapeId'];
    segmentNumber = json['segmentNumber'];
    tapeDuration = json['tapeDuration'];
    spotPositionTypeName = json['spotPositionTypeName'];
    breaknumber = json['breaknumber'];
    positionName = json['positionName'];
    ratePer10Sec = json['ratePer10Sec'];
    spotAmount = json['spotAmount'];
    dealNo = json['dealNo'];
    dealrownumber = json['dealrownumber'];
    toNo = json['toNo'];
    schId = json['schId'];
    commercialCaption = json['commercialCaption'];
    programCode = json['programCode'];
    spotPositionTypeCode = json['spotPositionTypeCode'];
    positionCode = json['positionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['programName'] = programName;
    data['telecastDate'] = telecastDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['spots'] = spots;
    data['tapeId'] = tapeId;
    data['segmentNumber'] = segmentNumber;
    data['tapeDuration'] = tapeDuration;
    data['spotPositionTypeName'] = spotPositionTypeName;
    data['breaknumber'] = breaknumber;
    data['positionName'] = positionName;
    data['ratePer10Sec'] = ratePer10Sec;
    data['spotAmount'] = spotAmount;
    data['dealNo'] = dealNo;
    data['dealrownumber'] = dealrownumber;
    data['toNo'] = toNo;
    data['schId'] = schId;
    data['commercialCaption'] = commercialCaption;
    data['programCode'] = programCode;
    data['spotPositionTypeCode'] = spotPositionTypeCode;
    data['positionCode'] = positionCode;
    return data;
  }
}
