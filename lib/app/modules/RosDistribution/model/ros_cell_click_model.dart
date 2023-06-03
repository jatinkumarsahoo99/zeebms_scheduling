class ROSCellClickDataModel {
  InfoGetFpcCellDoubleClick? infoGetFpcCellDoubleClick;

  ROSCellClickDataModel({this.infoGetFpcCellDoubleClick});

  ROSCellClickDataModel.copyWith({InfoGetFpcCellDoubleClick? infoGetFpcCellDoubleClick}) {
    this.infoGetFpcCellDoubleClick = infoGetFpcCellDoubleClick ?? this.infoGetFpcCellDoubleClick;
  }

  ROSCellClickDataModel.fromJson(Map<String, dynamic> json) {
    infoGetFpcCellDoubleClick =
        json['info_GetFpcCellDoubleClick'] != null ? InfoGetFpcCellDoubleClick.fromJson(json['info_GetFpcCellDoubleClick']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (infoGetFpcCellDoubleClick != null) {
      data['info_GetFpcCellDoubleClick'] = infoGetFpcCellDoubleClick!.toJson();
    }
    return data;
  }
}

class InfoGetFpcCellDoubleClick {
  String? today;
  String? tomorrow;
  int? moveSpotbuys;
  String? commercialCap;
  String? bookedduration;
  String? balanceDuration;
  String? programname;
  String? fpctime;
  List<LstFPC>? lstFPC;
  List<LstAllocatedSpots>? lstAllocatedSpots;
  List<LstUnallocatedSpots>? lstUnallocatedSpots;
  List<String>? tblAllocatedSpotsVisiableFalse;
  List<String>? tblUnallocatedSpotsVisiableFalse;

  InfoGetFpcCellDoubleClick(
      {this.today,
      this.tomorrow,
      this.moveSpotbuys,
      this.commercialCap,
      this.bookedduration,
      this.balanceDuration,
      this.programname,
      this.fpctime,
      this.lstFPC,
      this.lstAllocatedSpots,
      this.lstUnallocatedSpots,
      this.tblAllocatedSpotsVisiableFalse,
      this.tblUnallocatedSpotsVisiableFalse});

  InfoGetFpcCellDoubleClick.fromJson(Map<String, dynamic> json) {
    today = json['today'];
    tomorrow = json['tomorrow'];
    moveSpotbuys = json['moveSpotbuys'];
    commercialCap = json['commercialCap'];
    bookedduration = json['bookedduration'];
    balanceDuration = json['balanceDuration'];
    programname = json['programname'];
    fpctime = json['fpctime'];
    if (json['lstFPC'] != null) {
      lstFPC = <LstFPC>[];
      json['lstFPC'].forEach((v) {
        lstFPC!.add(LstFPC.fromJson(v));
      });
    }
    if (json['lstAllocatedSpots'] != null) {
      lstAllocatedSpots = <LstAllocatedSpots>[];
      json['lstAllocatedSpots'].forEach((v) {
        lstAllocatedSpots!.add(LstAllocatedSpots.fromJson(v));
      });
    }
    if (json['lstUnallocatedSpots'] != null) {
      lstUnallocatedSpots = <LstUnallocatedSpots>[];
      json['lstUnallocatedSpots'].forEach((v) {
        lstUnallocatedSpots!.add(LstUnallocatedSpots.fromJson(v));
      });
    }
    tblAllocatedSpotsVisiableFalse = json['tblAllocatedSpots_Visiable_False'].cast<String>();
    tblUnallocatedSpotsVisiableFalse = json['tblUnallocatedSpots_Visiable_False'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['today'] = today;
    data['tomorrow'] = tomorrow;
    data['moveSpotbuys'] = moveSpotbuys;
    data['commercialCap'] = commercialCap;
    data['bookedduration'] = bookedduration;
    data['balanceDuration'] = balanceDuration;
    data['programname'] = programname;
    data['fpctime'] = fpctime;
    if (lstFPC != null) {
      data['lstFPC'] = lstFPC!.map((v) => v.toJson()).toList();
    }
    if (lstAllocatedSpots != null) {
      data['lstAllocatedSpots'] = lstAllocatedSpots!.map((v) => v.toJson()).toList();
    }
    if (lstUnallocatedSpots != null) {
      data['lstUnallocatedSpots'] = lstUnallocatedSpots!.map((v) => v.toJson()).toList();
    }
    data['tblAllocatedSpots_Visiable_False'] = tblAllocatedSpotsVisiableFalse;
    data['tblUnallocatedSpots_Visiable_False'] = tblUnallocatedSpotsVisiableFalse;
    return data;
  }
}

class LstFPC {
  int? rowNo;
  String? programCode;
  String? languageCode;
  String? oriRepCode;
  String? programTypeCode;
  String? color;
  int? episodeDuration;
  String? fpcTime;
  String? endTime;
  String? programName;
  int? epsNo;
  String? tapeID;
  String? oriRep;
  String? wbs;
  String? caption;
  String? modifed;
  int? commercialCap;
  int? groupCode;
  int? bookedDuration;
  String? backColor;
  String? foreColor;
  String? selectionBackColor;
  String? selectionForeColor;

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
      this.bookedDuration,
      this.backColor,
      this.foreColor,
      this.selectionBackColor,
      this.selectionForeColor});

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
    backColor = json['backColor'];
    foreColor = json['foreColor'];
    selectionBackColor = json['selectionBackColor'];
    selectionForeColor = json['selectionForeColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fpcTime'] = fpcTime;
    data['programName'] = programName;
    data['rowNo'] = rowNo;
    data['programCode'] = programCode;
    data['languageCode'] = languageCode;
    data['oriRepCode'] = oriRepCode;
    data['programTypeCode'] = programTypeCode;
    data['color'] = color;
    data['episodeDuration'] = episodeDuration;
    data['endTime'] = endTime;
    data['epsNo'] = epsNo;
    data['tapeID'] = tapeID;
    data['oriRep'] = oriRep;
    data['wbs'] = wbs;
    data['caption'] = caption;
    data['modifed'] = modifed;
    data['commercialCap'] = commercialCap;
    data['groupCode'] = groupCode;
    data['bookedDuration'] = bookedDuration;
    data['backColor'] = backColor;
    data['foreColor'] = foreColor;
    data['selectionBackColor'] = selectionBackColor;
    data['selectionForeColor'] = selectionForeColor;
    return data;
  }
}

class LstAllocatedSpots {
  int? rid;
  int? rrr;
  String? locationcode;
  String? channelcode;
  String? bookingNumber;
  int? bookingDetailCode;
  String? zoneName;
  String? brandcode;
  String? scheduledate;
  String? clientName;
  String? brandname;
  int? tapeduration;
  String? scheduletime;
  int? rate;
  int? valuationrate;
  String? sponsorTypeCode;
  int? dealBand;
  String? commercialCode;
  String? sponsorTypeName;
  String? dealNumber;
  dynamic spotPriority;
  String? dealTypeName;
  String? allocatedSpot;
  int? groupcode;
  dynamic midend;
  dynamic midstart;
  String? backColor;
  String? selectionBackColor;
  String? selectionForeColor;

  LstAllocatedSpots(
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
      this.groupcode,
      this.midend,
      this.midstart,
      this.backColor,
      this.selectionBackColor,
      this.selectionForeColor});

  LstAllocatedSpots.fromJson(Map<String, dynamic> json) {
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
    midend = json['midend'];
    midstart = json['midstart'];
    backColor = json['backColor'];
    selectionBackColor = json['selectionBackColor'];
    selectionForeColor = json['selectionForeColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['midend'] = midend;
    data['midstart'] = midstart;
    data['backColor'] = backColor;
    data['selectionBackColor'] = selectionBackColor;
    data['selectionForeColor'] = selectionForeColor;
    return data;
  }
}

class LstUnallocatedSpots {
  int? rid;
  int? rrr;
  String? locationcode;
  String? channelcode;
  String? bookingNumber;
  int? bookingDetailCode;
  String? zoneName;
  String? brandcode;
  String? scheduledate;
  String? clientName;
  String? brandname;
  int? tapeduration;
  String? scheduletime;
  String? starttime;
  String? endtime;
  int? rate;
  int? valuationrate;
  String? sponsorTypeCode;
  int? dealBand;
  String? commercialCode;
  String? sponsorTypeName;
  String? dealNumber;
  dynamic spotPriority;
  String? dealTypeName;
  String? allocatedSpot;
  int? groupcode;
  String? midend;
  String? midstart;
  String? backColor;
  String? selectionBackColor;
  String? selectionForeColor;

  LstUnallocatedSpots(
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
      this.groupcode,
      this.midend,
      this.midstart,
      this.backColor,
      this.selectionBackColor,
      this.selectionForeColor});

  LstUnallocatedSpots.fromJson(Map<String, dynamic> json) {
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
    midend = json['midend'];
    midstart = json['midstart'];
    backColor = json['backColor'];
    selectionBackColor = json['selectionBackColor'];
    selectionForeColor = json['selectionForeColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['midend'] = midend;
    data['midstart'] = midstart;
    data['backColor'] = backColor;
    data['selectionBackColor'] = selectionBackColor;
    data['selectionForeColor'] = selectionForeColor;
    return data;
  }
}
