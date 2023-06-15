class RoBookingTapeSearchData {
  List<LstSearchTapeId>? lstSearchTapeId;

  RoBookingTapeSearchData({this.lstSearchTapeId});

  RoBookingTapeSearchData.fromJson(Map<String, dynamic> json) {
    if (json['lstSearchTapeId'] != null) {
      lstSearchTapeId = <LstSearchTapeId>[];
      json['lstSearchTapeId'].forEach((v) {
        lstSearchTapeId!.add(new LstSearchTapeId.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstSearchTapeId != null) {
      data['lstSearchTapeId'] = this.lstSearchTapeId!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstSearchTapeId {
  String? exportTapeCode;
  String? commercialCaption;
  int? commercialDuration;
  String? brandname;
  String? clientname;
  String? languageName;
  String? agencyTapeId;
  String? killDate;
  String? revenueType;
  String? subRevenueType;
  String? enteredBy;
  String? createdModifiedOn;
  int? segmentnumber;
  String? eventtypecode;
  String? languageCode;

  LstSearchTapeId(
      {this.exportTapeCode,
      this.commercialCaption,
      this.commercialDuration,
      this.brandname,
      this.clientname,
      this.languageName,
      this.agencyTapeId,
      this.killDate,
      this.revenueType,
      this.subRevenueType,
      this.enteredBy,
      this.createdModifiedOn,
      this.segmentnumber,
      this.eventtypecode,
      this.languageCode});

  LstSearchTapeId.fromJson(Map<String, dynamic> json) {
    exportTapeCode = json['exportTapeCode'];
    commercialCaption = json['commercialCaption'];
    commercialDuration = json['commercialDuration'];
    brandname = json['brandname'];
    clientname = json['clientname'];
    languageName = json['languageName'];
    agencyTapeId = json['agencyTapeId'];
    killDate = json['killDate'];
    revenueType = json['revenueType'];
    subRevenueType = json['subRevenueType'];
    enteredBy = json['enteredBy'];
    createdModifiedOn = json['createdModifiedOn'];
    segmentnumber = json['segmentnumber'];
    eventtypecode = json['eventtypecode'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exportTapeCode'] = this.exportTapeCode;
    data['commercialCaption'] = this.commercialCaption;
    data['commercialDuration'] = this.commercialDuration;
    data['brandname'] = this.brandname;
    data['clientname'] = this.clientname;
    data['languageName'] = this.languageName;
    data['agencyTapeId'] = this.agencyTapeId;
    data['killDate'] = this.killDate;
    data['revenueType'] = this.revenueType;
    data['subRevenueType'] = this.subRevenueType;
    data['enteredBy'] = this.enteredBy;
    data['createdModifiedOn'] = this.createdModifiedOn;
    data['segmentnumber'] = this.segmentnumber;
    data['eventtypecode'] = this.eventtypecode;
    data['languageCode'] = this.languageCode;
    return data;
  }
}
