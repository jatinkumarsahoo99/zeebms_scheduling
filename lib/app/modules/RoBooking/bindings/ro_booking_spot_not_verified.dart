class SpotsNotVerified {
  int? bookingMonth;
  int? bookingNumber;
  String? zoneName;
  String? clientName;
  String? agencyName;
  String? brandName;
  int? totalSpots;
  int? auditedSpots;
  int? bookedAmount;
  int? auditedAmount;
  String? payrouteName;
  int? unAuditedSpots;
  int? dropped;
  String? bookingNo;
  String? bookingReferenceNumber;
  String? bookedBy;
  String? verifyStatus;

  SpotsNotVerified(
      {this.bookingMonth,
      this.bookingNumber,
      this.zoneName,
      this.clientName,
      this.agencyName,
      this.brandName,
      this.totalSpots,
      this.auditedSpots,
      this.bookedAmount,
      this.auditedAmount,
      this.payrouteName,
      this.unAuditedSpots,
      this.dropped,
      this.bookingNo,
      this.bookingReferenceNumber,
      this.bookedBy,
      this.verifyStatus});

  SpotsNotVerified.fromJson(Map<String, dynamic> json) {
    bookingMonth = json['bookingMonth'];
    bookingNumber = json['bookingNumber'];
    zoneName = json['zoneName'];
    clientName = json['clientName'];
    agencyName = json['agencyName'];
    brandName = json['brandName'];
    totalSpots = json['totalSpots'];
    auditedSpots = json['auditedSpots'];
    bookedAmount = json['bookedAmount'];
    auditedAmount = json['auditedAmount'];
    payrouteName = json['payrouteName'];
    unAuditedSpots = json['unAuditedSpots'];
    dropped = json['dropped'];
    bookingNo = json['bookingNo'];
    bookingReferenceNumber = json['bookingReferenceNumber'];
    bookedBy = json['bookedBy'];
    verifyStatus = json['verifyStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingMonth'] = this.bookingMonth;
    data['bookingNumber'] = this.bookingNumber;
    data['zoneName'] = this.zoneName;
    data['clientName'] = this.clientName;
    data['agencyName'] = this.agencyName;
    data['brandName'] = this.brandName;
    data['totalSpots'] = this.totalSpots;
    data['auditedSpots'] = this.auditedSpots;
    data['bookedAmount'] = this.bookedAmount;
    data['auditedAmount'] = this.auditedAmount;
    data['payrouteName'] = this.payrouteName;
    data['unAuditedSpots'] = this.unAuditedSpots;
    data['dropped'] = this.dropped;
    data['bookingNo'] = this.bookingNo;
    data['bookingReferenceNumber'] = this.bookingReferenceNumber;
    data['bookedBy'] = this.bookedBy;
    data['verifyStatus'] = this.verifyStatus;
    return data;
  }
}
