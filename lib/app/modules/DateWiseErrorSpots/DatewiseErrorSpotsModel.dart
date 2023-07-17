class DatewiseErrorSpotsModel {
  List<DatewiseErrorSpots>? datewiseErrorSpots;

  DatewiseErrorSpotsModel({this.datewiseErrorSpots});

  DatewiseErrorSpotsModel.fromJson(Map<String, dynamic> json) {
    if (json['datewiseErrorSpots'] != null) {
      datewiseErrorSpots = <DatewiseErrorSpots>[];
      json['datewiseErrorSpots'].forEach((v) {
        datewiseErrorSpots!.add(new DatewiseErrorSpots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datewiseErrorSpots != null) {
      data['datewiseErrorSpots'] =
          this.datewiseErrorSpots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatewiseErrorSpots {
  String? bookingNumber;
  int? bookingDetailCode;
  String? dealNumber;
  int? recordnumber;
  String? programName;
  String? scheduleDate;
  String? scheduleTime;
  String? startTime;
  String? endtime;
  String? clientName;
  String? agencyName;
  String? bookingReferenceNumber;
  String? brandname;
  String? tapeid;
  String? commercialCaption;
  int? tapeDuration;
  double? spotAmount;
  double? er;
  String? zonename;
  String? executivename;
  double? spotAmount1;
  double? valAmount;
  String? accountname;
  String? reason;

  DatewiseErrorSpots(
      {this.bookingNumber,
        this.bookingDetailCode,
        this.dealNumber,
        this.recordnumber,
        this.programName,
        this.scheduleDate,
        this.scheduleTime,
        this.startTime,
        this.endtime,
        this.clientName,
        this.agencyName,
        this.bookingReferenceNumber,
        this.brandname,
        this.tapeid,
        this.commercialCaption,
        this.tapeDuration,
        this.spotAmount,
        this.er,
        this.zonename,
        this.executivename,
        this.spotAmount1,
        this.valAmount,
        this.accountname,
        this.reason});

  DatewiseErrorSpots.fromJson(Map<String, dynamic> json) {
    bookingNumber = json['bookingNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    dealNumber = json['dealNumber'];
    recordnumber = json['recordnumber'];
    programName = json['programName'];
    scheduleDate = json['scheduleDate'];
    scheduleTime = json['scheduleTime'];
    startTime = json['startTime'];
    endtime = json['endtime'];
    clientName = json['clientName'];
    agencyName = json['agencyName'];
    bookingReferenceNumber = json['bookingReferenceNumber'];
    brandname = json['brandname'];
    tapeid = json['tapeid'];
    commercialCaption = json['commercialCaption'];
    tapeDuration = json['tapeDuration'];
    spotAmount = json['spotAmount'];
    er = json['er'];
    zonename = json['zonename'];
    executivename = json['executivename'];
    spotAmount1 = json['spotAmount1'];
    valAmount = json['valAmount'];
    accountname = json['accountname'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['dealNumber'] = this.dealNumber;
    data['recordnumber'] = this.recordnumber;
    data['programName'] = this.programName;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduleTime'] = this.scheduleTime;
    data['startTime'] = this.startTime;
    data['endtime'] = this.endtime;
    data['clientName'] = this.clientName;
    data['agencyName'] = this.agencyName;
    data['bookingReferenceNumber'] = this.bookingReferenceNumber;
    data['brandname'] = this.brandname;
    data['tapeid'] = this.tapeid;
    data['commercialCaption'] = this.commercialCaption;
    data['tapeDuration'] = this.tapeDuration;
    data['spotAmount'] = this.spotAmount;
    data['er'] = this.er;
    data['zonename'] = this.zonename;
    data['executivename'] = this.executivename;
    data['spotAmount1'] = this.spotAmount1;
    data['valAmount'] = this.valAmount;
    data['accountname'] = this.accountname;
    data['reason'] = this.reason;
    return data;
  }
}