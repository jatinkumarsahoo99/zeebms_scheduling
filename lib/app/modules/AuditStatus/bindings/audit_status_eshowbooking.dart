class AuditStatusShowEbooking {
  List<LstShowEbooking>? lstShowEbooking;
  List<LstShowEbook>? lstShowEbook;
  String? bkmonth;
  String? bkno;
  String? location;
  String? channel;
  String? client;
  String? brand;
  String? zone;
  String? ageny;

  AuditStatusShowEbooking(
      {this.lstShowEbooking,
      this.lstShowEbook,
      this.bkmonth,
      this.bkno,
      this.location,
      this.channel,
      this.client,
      this.brand,
      this.zone,
      this.ageny});

  AuditStatusShowEbooking.fromJson(Map<String, dynamic> json) {
    if (json['lstShowEbooking'] != null) {
      lstShowEbooking = <LstShowEbooking>[];
      json['lstShowEbooking'].forEach((v) {
        lstShowEbooking!.add(new LstShowEbooking.fromJson(v));
      });
    }
    if (json['lstShowEbook'] != null) {
      lstShowEbook = <LstShowEbook>[];
      json['lstShowEbook'].forEach((v) {
        lstShowEbook!.add(new LstShowEbook.fromJson(v));
      });
    }
    bkmonth = json['bkmonth'];
    bkno = json['bkno'];
    location = json['location'];
    channel = json['channel'];
    client = json['client'];
    brand = json['brand'];
    zone = json['zone'];
    ageny = json['ageny'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstShowEbooking != null) {
      data['lstShowEbooking'] =
          this.lstShowEbooking!.map((v) => v.toJson()).toList();
    }
    if (this.lstShowEbook != null) {
      data['lstShowEbook'] = this.lstShowEbook!.map((v) => v.toJson()).toList();
    }
    data['bkmonth'] = this.bkmonth;
    data['bkno'] = this.bkno;
    data['location'] = this.location;
    data['channel'] = this.channel;
    data['client'] = this.client;
    data['brand'] = this.brand;
    data['zone'] = this.zone;
    data['ageny'] = this.ageny;
    return data;
  }
}

class LstShowEbooking {
  String? locationCode;
  String? locationname;
  String? channelCode;
  String? channelname;
  num? bookingMonth;
  num? bookingNumber;
  String? bookingDate;
  String? bookingEffectiveDate;
  String? bookingReferenceNumber;
  String? clientCode;
  String? clientname;
  String? agencyCode;
  String? agencyname;
  String? brandCode;
  String? brandname;
  String? executiveCode;
  String? personnelName;
  String? zoneCode;
  String? zoneName;
  String? zoneShortName;
  String? dealno;
  String? dealFromDate;
  String? dealtoDate;
  String? payroutecode;
  String? payRouteName;
  String? paymentmodecode;
  String? paymentmodecaption;
  num? isPdcEnterd;
  num? maxSpend;
  String? modifiedBy;
  String? verifiedby;
  String? chequeId;
  String? chequeNo;
  num? chequeAmount;
  String? bankName;
  num? pdcRequired;

  LstShowEbooking(
      {this.locationCode,
      this.locationname,
      this.channelCode,
      this.channelname,
      this.bookingMonth,
      this.bookingNumber,
      this.bookingDate,
      this.bookingEffectiveDate,
      this.bookingReferenceNumber,
      this.clientCode,
      this.clientname,
      this.agencyCode,
      this.agencyname,
      this.brandCode,
      this.brandname,
      this.executiveCode,
      this.personnelName,
      this.zoneCode,
      this.zoneName,
      this.zoneShortName,
      this.dealno,
      this.dealFromDate,
      this.dealtoDate,
      this.payroutecode,
      this.payRouteName,
      this.paymentmodecode,
      this.paymentmodecaption,
      this.isPdcEnterd,
      this.maxSpend,
      this.modifiedBy,
      this.verifiedby,
      this.chequeId,
      this.chequeNo,
      this.chequeAmount,
      this.bankName,
      this.pdcRequired});

  LstShowEbooking.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    locationname = json['locationname'];
    channelCode = json['channelCode'];
    channelname = json['channelname'];
    bookingMonth = json['bookingMonth'];
    bookingNumber = json['bookingNumber'];
    bookingDate = json['bookingDate'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    bookingReferenceNumber = json['bookingReferenceNumber'];
    clientCode = json['clientCode'];
    clientname = json['clientname'];
    agencyCode = json['agencyCode'];
    agencyname = json['agencyname'];
    brandCode = json['brandCode'];
    brandname = json['brandname'];
    executiveCode = json['executiveCode'];
    personnelName = json['personnelName'];
    zoneCode = json['zoneCode'];
    zoneName = json['zoneName'];
    zoneShortName = json['zoneShortName'];
    dealno = json['dealno'];
    dealFromDate = json['dealFromDate'];
    dealtoDate = json['dealtoDate'];
    payroutecode = json['payroutecode'];
    payRouteName = json['payRouteName'];
    paymentmodecode = json['paymentmodecode'];
    paymentmodecaption = json['paymentmodecaption'];
    isPdcEnterd = json['isPdcEnterd'];
    maxSpend = json['maxSpend'];
    modifiedBy = json['modifiedBy'];
    verifiedby = json['verifiedby'];
    chequeId = json['chequeId'];
    chequeNo = json['chequeNo'];
    chequeAmount = json['chequeAmount'];
    bankName = json['bankName'];
    pdcRequired = json['pdcRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationCode'] = this.locationCode;
    data['locationname'] = this.locationname;
    data['channelCode'] = this.channelCode;
    data['channelname'] = this.channelname;
    data['bookingMonth'] = this.bookingMonth;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDate'] = this.bookingDate;
    data['bookingEffectiveDate'] = this.bookingEffectiveDate;
    data['bookingReferenceNumber'] = this.bookingReferenceNumber;
    data['clientCode'] = this.clientCode;
    data['clientname'] = this.clientname;
    data['agencyCode'] = this.agencyCode;
    data['agencyname'] = this.agencyname;
    data['brandCode'] = this.brandCode;
    data['brandname'] = this.brandname;
    data['executiveCode'] = this.executiveCode;
    data['personnelName'] = this.personnelName;
    data['zoneCode'] = this.zoneCode;
    data['zoneName'] = this.zoneName;
    data['zoneShortName'] = this.zoneShortName;
    data['dealno'] = this.dealno;
    data['dealFromDate'] = this.dealFromDate;
    data['dealtoDate'] = this.dealtoDate;
    data['payroutecode'] = this.payroutecode;
    data['payRouteName'] = this.payRouteName;
    data['paymentmodecode'] = this.paymentmodecode;
    data['paymentmodecaption'] = this.paymentmodecaption;
    data['isPdcEnterd'] = this.isPdcEnterd;
    data['maxSpend'] = this.maxSpend;
    data['modifiedBy'] = this.modifiedBy;
    data['verifiedby'] = this.verifiedby;
    data['chequeId'] = this.chequeId;
    data['chequeNo'] = this.chequeNo;
    data['chequeAmount'] = this.chequeAmount;
    data['bankName'] = this.bankName;
    data['pdcRequired'] = this.pdcRequired;
    return data;
  }
}

class LstShowEbook {
  num? rownumber;
  num? bookingNumber;
  String? programname;
  String? scheduleDate;
  String? scheduleTime;
  String? endTime;
  String? tapeCode;
  num? segmentnumber;
  String? commercialCaption;
  num? totalspots;
  num? tapeDuration;
  num? spotAmount;
  num? audited;
  String? auditedby;
  String? bookingNo;
  String? dealno;
  num? dealrownumber;
  num? auditedspots;
  num? salesgroupcode;
  String? auditedon;
  num? bookingRate;
  num? dealrate;

  LstShowEbook(
      {this.rownumber,
      this.bookingNumber,
      this.programname,
      this.scheduleDate,
      this.scheduleTime,
      this.endTime,
      this.tapeCode,
      this.segmentnumber,
      this.commercialCaption,
      this.totalspots,
      this.tapeDuration,
      this.spotAmount,
      this.audited,
      this.auditedby,
      this.bookingNo,
      this.dealno,
      this.dealrownumber,
      this.auditedspots,
      this.salesgroupcode,
      this.auditedon,
      this.bookingRate,
      this.dealrate});

  LstShowEbook.fromJson(Map<String, dynamic> json) {
    rownumber = json['rownumber'];
    bookingNumber = json['bookingNumber'];
    programname = json['programname'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    endTime = json['endTime'];
    tapeCode = json['tapeCode'];
    segmentnumber = json['segmentnumber'];
    commercialCaption = json['commercialCaption'];
    totalspots = json['totalspots'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    audited = json['audited'];
    auditedby = json['auditedby'];
    bookingNo = json['bookingNo'];
    dealno = json['dealno'];
    dealrownumber = json['dealrownumber'];
    auditedspots = json['auditedspots'];
    salesgroupcode = json['salesgroupcode'];
    auditedon = json['auditedon'];
    bookingRate = json['bookingRate'];
    dealrate = json['dealrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rownumber'] = this.rownumber;
    data['bookingNumber'] = this.bookingNumber;
    data['programname'] = this.programname;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['endTime'] = this.endTime;
    data['tapeCode'] = this.tapeCode;
    data['segmentnumber'] = this.segmentnumber;
    data['commercialCaption'] = this.commercialCaption;
    data['totalspots'] = this.totalspots;
    data['tapeDuration'] = this.tapeDuration;
    data['spotAmount'] = this.spotAmount;
    data['audited'] = this.audited;
    data['auditedby'] = this.auditedby;
    data['bookingNo'] = this.bookingNo;
    data['dealno'] = this.dealno;
    data['dealrownumber'] = this.dealrownumber;
    data['auditedspots'] = this.auditedspots;
    data['salesgroupcode'] = this.salesgroupcode;
    data['auditedon'] = this.auditedon;
    data['bookingRate'] = this.bookingRate;
    data['dealrate'] = this.dealrate;
    return data;
  }
}
