class AuditStatusShowReschdule {
  String? locationCode;
  String? locationName;
  String? channelCode;
  String? channelName;
  int? rescheduleMonth;
  int? rescheduleNumber;
  String? clientCode;
  String? clientName;
  String? agencyCode;
  String? agencyName;
  String? brandCode;
  String? brandName;
  String? rescheduledate;
  String? bookingEffectiveDate;
  String? dealNo;
  String? bookingNumber;
  String? rescheduleReferenceNumber;

  AuditStatusShowReschdule(
      {this.locationCode,
      this.locationName,
      this.channelCode,
      this.channelName,
      this.rescheduleMonth,
      this.rescheduleNumber,
      this.clientCode,
      this.clientName,
      this.agencyCode,
      this.agencyName,
      this.brandCode,
      this.brandName,
      this.rescheduledate,
      this.bookingEffectiveDate,
      this.dealNo,
      this.bookingNumber,
      this.rescheduleReferenceNumber});

  AuditStatusShowReschdule.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    locationName = json['locationName'];
    channelCode = json['channelCode'];
    channelName = json['channelName'];
    rescheduleMonth = json['rescheduleMonth'];
    rescheduleNumber = json['rescheduleNumber'];
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    agencyCode = json['agencyCode'];
    agencyName = json['agencyName'];
    brandCode = json['brandCode'];
    brandName = json['brandName'];
    rescheduledate = json['rescheduledate'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    dealNo = json['dealNo'];
    bookingNumber = json['bookingNumber'];
    rescheduleReferenceNumber = json['rescheduleReferenceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationCode'] = this.locationCode;
    data['locationName'] = this.locationName;
    data['channelCode'] = this.channelCode;
    data['channelName'] = this.channelName;
    data['rescheduleMonth'] = this.rescheduleMonth;
    data['rescheduleNumber'] = this.rescheduleNumber;
    data['clientCode'] = this.clientCode;
    data['clientName'] = this.clientName;
    data['agencyCode'] = this.agencyCode;
    data['agencyName'] = this.agencyName;
    data['brandCode'] = this.brandCode;
    data['brandName'] = this.brandName;
    data['rescheduledate'] = this.rescheduledate;
    data['bookingEffectiveDate'] = this.bookingEffectiveDate;
    data['dealNo'] = this.dealNo;
    data['bookingNumber'] = this.bookingNumber;
    data['rescheduleReferenceNumber'] = this.rescheduleReferenceNumber;
    return data;
  }
}
