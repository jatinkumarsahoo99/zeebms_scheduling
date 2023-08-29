class ROSDistuibutionShowModel {
  InfoShowBucketList? infoShowBucketList;

  ROSDistuibutionShowModel({this.infoShowBucketList});
  ROSDistuibutionShowModel.copyWith({InfoShowBucketList? infoShowBucketList}) {
    this.infoShowBucketList = infoShowBucketList ?? this.infoShowBucketList;
  }

  ROSDistuibutionShowModel.fromJson(Map<String, dynamic> json) {
    infoShowBucketList = json['info_ShowBucketList'] != null
        ? InfoShowBucketList.fromJson(json['info_ShowBucketList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (infoShowBucketList != null) {
      data['info_ShowBucketList'] = infoShowBucketList!.toJson();
    }
    return data;
  }
}

class InfoShowBucketList {
  List<LstROSSpots>? lstROSSpots;
  List<LstFPC>? lstFPC;
  List<String>? controlEnableFalse;
  List<String>? controlEnableTrue;

  InfoShowBucketList(
      {this.lstROSSpots,
      this.lstFPC,
      this.controlEnableFalse,
      this.controlEnableTrue});

  InfoShowBucketList.fromJson(Map<String, dynamic> json) {
    if (json['lstROSSpots'] != null) {
      lstROSSpots = <LstROSSpots>[];
      json['lstROSSpots'].forEach((v) {
        lstROSSpots!.add(LstROSSpots.fromJson(v));
      });
    }
    if (json['lstFPC'] != null) {
      lstFPC = <LstFPC>[];
      json['lstFPC'].forEach((v) {
        lstFPC!.add(LstFPC.fromJson(v));
      });
    }
    if (json['control_Enable_False'] != null) {
      controlEnableFalse = json['control_Enable_False'].cast<String>();
    }
    if (json['control_Enable_True'] != null) {
      controlEnableTrue = json['control_Enable_True'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lstROSSpots != null) {
      data['lstROSSpots'] = lstROSSpots!.map((v) => v.toJson()).toList();
    }
    if (lstFPC != null) {
      data['lstFPC'] = lstFPC!.map((v) => v.toJson()).toList();
    }
    data['control_Enable_False'] = controlEnableFalse;
    data['control_Enable_True'] = controlEnableTrue;
    return data;
  }
}

class LstROSSpots {
  num? rid;
  num? rrr;
  String? locationcode;
  String? channelcode;
  String? bookingNumber;
  num? bookingDetailCode;
  String? zoneName;
  String? brandcode;
  String? scheduledate;
  String? clientName;
  String? brandname;
  num? tapeduration;
  String? scheduletime;
  String? starttime;
  String? endtime;
  num? rate;
  num? valuationrate;
  String? sponsorTypeCode;
  num? dealBand;
  String? commercialCode;
  String? sponsorTypeName;
  String? dealNumber;
  String? spotPriority;
  String? dealTypeName;
  String? allocatedSpot;
  num? groupcode;

  LstROSSpots(
      {this.rid,
      this.rrr,
      this.locationcode,
      this.channelcode,
      this.bookingNumber,
      this.bookingDetailCode,
      this.zoneName,
      this.brandcode,
      this.scheduledate,
      this.clientName,
      this.brandname,
      this.tapeduration,
      this.scheduletime,
      this.starttime,
      this.endtime,
      this.rate,
      this.valuationrate,
      this.sponsorTypeCode,
      this.dealBand,
      this.commercialCode,
      this.sponsorTypeName,
      this.dealNumber,
      this.spotPriority,
      this.dealTypeName,
      this.allocatedSpot,
      this.groupcode});

  LstROSSpots.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    rrr = json['rrr'];
    locationcode = json['locationcode'];
    channelcode = json['channelcode'];
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    zoneName = json['zoneName'];
    brandcode = json['brandcode'];
    scheduledate = json['scheduledate'];
    clientName = json['clientName'];
    brandname = json['brandname'];
    tapeduration = json['tapeduration'];
    scheduletime = json['scheduletime'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    rate = json['rate'];
    valuationrate = json['valuationrate'];
    sponsorTypeCode = json['sponsorTypeCode'];
    dealBand = json['dealBand'];
    commercialCode = json['commercialCode'];
    sponsorTypeName = json['sponsorTypeName'];
    dealNumber = json['dealNumber'];
    spotPriority = json['spotPriority'];
    dealTypeName = json['dealTypeName'];
    allocatedSpot = json['allocatedSpot'];
    groupcode = json['groupcode'];
  }

  Map<String, dynamic> toJson({bool fromSave = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['rid'] = rid;
      data['rrr'] = rrr;
      data['locationcode'] = locationcode;
      data['channelcode'] = channelcode;
      data['bookingNumber'] = bookingNumber;
      data['bookingDetailCode'] = bookingDetailCode;
      data['zoneName'] = zoneName;
      data['brandcode'] = brandcode;
      data['scheduledate'] = scheduledate;
      data['clientName'] = clientName;
      data['brandname'] = brandname;
      data['tapeduration'] = tapeduration;
      data['scheduletime'] = scheduletime;
      data['starttime'] = starttime;
      data['endtime'] = endtime;
      data['rate'] = rate;
      data['valuationrate'] = valuationrate;
      data['sponsorTypeCode'] = sponsorTypeCode;
      data['dealBand'] = dealBand;
      data['commercialCode'] = commercialCode;
      data['sponsorTypeName'] = sponsorTypeName;
      data['dealNumber'] = dealNumber;
      data['spotPriority'] = spotPriority;
      data['dealTypeName'] = dealTypeName;
      data['allocatedSpot'] = allocatedSpot;
      data['groupcode'] = groupcode;
    } else {
      // data['rid'] = rid;
      data['RRR'] = rrr;
      // data['locationcode'] = locationcode;
      // data['channelcode'] = channelcode;
      data['bookingNumber'] = bookingNumber;
      data['bookingDetailCode'] = bookingDetailCode;
      data['zoneName'] = zoneName;
      // data['brandcode'] = brandcode;
      data['scheduledate'] = scheduledate;
      data['clientName'] = clientName;
      data['brandname'] = brandname;
      data['tapeduration'] = tapeduration;
      data['scheduletime'] = scheduletime;
      data['starttime'] = starttime;
      data['endtime'] = endtime;
      data['rate'] = rate;
      data['valuationrate'] = valuationrate;
      // data['sponsorTypeCode'] = sponsorTypeCode;
      data['dealBand'] = dealBand;
      data['commercialCode'] = commercialCode;
      data['sponsorTypeName'] = sponsorTypeName;
      data['dealNumber'] = dealNumber;
      data['spotPriority'] = spotPriority;
      data['dealTypeName'] = dealTypeName;
      data['allocatedSpot'] = allocatedSpot;
      data['groupcode'] = groupcode;
    }
    return data;
  }
}

class LstFPC {
  num? rowNo;
  String? programCode;
  String? languageCode;
  String? oriRepCode;
  String? programTypeCode;
  String? color;
  num? episodeDuration;
  String? fpcTime;
  String? endTime;
  String? programName;
  num? epsNo;
  String? tapeID;
  String? oriRep;
  String? wbs;
  String? caption;
  String? modifed;
  num? commercialCap;
  num? groupCode;
  String? bookedDuration;

  LstFPC(
      {this.rowNo,
      this.programCode,
      this.languageCode,
      this.oriRepCode,
      this.programTypeCode,
      this.color,
      this.episodeDuration,
      this.fpcTime,
      this.endTime,
      this.programName,
      this.epsNo,
      this.tapeID,
      this.oriRep,
      this.wbs,
      this.caption,
      this.modifed,
      this.commercialCap,
      this.groupCode,
      this.bookedDuration});

  LstFPC.fromJson(Map<String, dynamic> json) {
    rowNo = json['rowNo'];
    programCode = json['programCode'];
    languageCode = json['languageCode'];
    oriRepCode = json['oriRepCode'];
    programTypeCode = json['programTypeCode'];
    color = json['color'];
    episodeDuration = json['episodeDuration'];
    fpcTime = json['fpcTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    epsNo = json['epsNo'];
    tapeID = json['tapeID'];
    oriRep = json['oriRep'];
    wbs = json['wbs'];
    caption = json['caption'];
    modifed = json['modifed'];
    commercialCap = json['commercialCap'];
    groupCode = json['groupCode'];
    bookedDuration = json['bookedDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rowNo'] = rowNo;
    data['programCode'] = programCode;
    data['languageCode'] = languageCode;
    data['oriRepCode'] = oriRepCode;
    data['programTypeCode'] = programTypeCode;
    data['color'] = color;
    data['episodeDuration'] = episodeDuration;
    data['fpcTime'] = fpcTime;
    data['endTime'] = endTime;
    data['programName'] = programName;
    data['epsNo'] = epsNo;
    data['tapeID'] = tapeID;
    data['oriRep'] = oriRep;
    data['wbs'] = wbs;
    data['caption'] = caption;
    data['modifed'] = modifed;
    data['commercialCap'] = commercialCap;
    data['groupCode'] = groupCode;
    data['bookedDuration'] = bookedDuration;
    return data;
  }
}
