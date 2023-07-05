class AuditStatusShowECancel {
  List<AuditShowECancel>? lstShowECancel;

  AuditStatusShowECancel({this.lstShowECancel});

  AuditStatusShowECancel.fromJson(Map<String, dynamic> json) {
    if (json['lstShowECancel'] != null) {
      lstShowECancel = <AuditShowECancel>[];
      json['lstShowECancel'].forEach((v) {
        lstShowECancel!.add(new AuditShowECancel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstShowECancel != null) {
      data['lstShowECancel'] =
          this.lstShowECancel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuditShowECancel {
  String? locationCode;
  String? channelCode;
  String? locationName;
  String? channelName;
  String? bookingNumber;
  String? referenceNumber;
  String? referenceDate;
  String? clientName;
  String? agencyName;
  String? brandName;
  String? clientCode;
  String? dealNo;
  String? agencyCode;
  String? brandCode;
  String? zoneCode;
  String? zoneName;
  String? payrouteCode;
  String? payrouteName;
  String? executiveCode;
  String? personnelName;
  String? bookingReferenceNumber;
  String? bookingEffectiveDate;
  String? paymentModeCaption;

  AuditShowECancel(
      {this.locationCode,
      this.channelCode,
      this.locationName,
      this.channelName,
      this.bookingNumber,
      this.referenceNumber,
      this.referenceDate,
      this.clientName,
      this.agencyName,
      this.brandName,
      this.clientCode,
      this.dealNo,
      this.agencyCode,
      this.brandCode,
      this.zoneCode,
      this.zoneName,
      this.payrouteCode,
      this.payrouteName,
      this.executiveCode,
      this.personnelName,
      this.bookingReferenceNumber,
      this.bookingEffectiveDate,
      this.paymentModeCaption});

  AuditShowECancel.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    locationName = json['locationName'];
    channelName = json['channelName'];
    bookingNumber = json['bookingNumber'];
    referenceNumber = json['referenceNumber'];
    referenceDate = json['referenceDate'];
    clientName = json['clientName'];
    agencyName = json['agencyName'];
    brandName = json['brandName'];
    clientCode = json['clientCode'];
    dealNo = json['dealNo'];
    agencyCode = json['agencyCode'];
    brandCode = json['brandCode'];
    zoneCode = json['zoneCode'];
    zoneName = json['zoneName'];
    payrouteCode = json['payrouteCode'];
    payrouteName = json['payrouteName'];
    executiveCode = json['executiveCode'];
    personnelName = json['personnelName'];
    bookingReferenceNumber = json['bookingReferenceNumber'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    paymentModeCaption = json['paymentModeCaption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationCode'] = this.locationCode;
    data['channelCode'] = this.channelCode;
    data['locationName'] = this.locationName;
    data['channelName'] = this.channelName;
    data['bookingNumber'] = this.bookingNumber;
    data['referenceNumber'] = this.referenceNumber;
    data['referenceDate'] = this.referenceDate;
    data['clientName'] = this.clientName;
    data['agencyName'] = this.agencyName;
    data['brandName'] = this.brandName;
    data['clientCode'] = this.clientCode;
    data['dealNo'] = this.dealNo;
    data['agencyCode'] = this.agencyCode;
    data['brandCode'] = this.brandCode;
    data['zoneCode'] = this.zoneCode;
    data['zoneName'] = this.zoneName;
    data['payrouteCode'] = this.payrouteCode;
    data['payrouteName'] = this.payrouteName;
    data['executiveCode'] = this.executiveCode;
    data['personnelName'] = this.personnelName;
    data['bookingReferenceNumber'] = this.bookingReferenceNumber;
    data['bookingEffectiveDate'] = this.bookingEffectiveDate;
    data['paymentModeCaption'] = this.paymentModeCaption;
    return data;
  }
}
