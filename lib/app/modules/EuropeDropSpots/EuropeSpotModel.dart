class EuropeSpotModel {
  List<Generates>? generates;

  EuropeSpotModel({this.generates});

  EuropeSpotModel.fromJson(Map<String, dynamic> json) {
    if (json['generates'] != null) {
      generates = <Generates>[];
      json['generates'].forEach((v) {
        generates!.add(new Generates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generates != null) {
      data['generates'] = this.generates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Generates {
  bool? selectItem;
  String? clientname;
  String? agencyname;
  String? tapeid;
  String? clockid;
  String? commercialcaption;
  int? duration;
  String? toNumber;
  int? bookingDetailCode;
  String? scheduleDate;
  String? scheduletime;
  String? brandname;

  Generates(
      {this.selectItem,
        this.clientname,
        this.agencyname,
        this.tapeid,
        this.clockid,
        this.commercialcaption,
        this.duration,
        this.toNumber,
        this.bookingDetailCode,
        this.scheduleDate,
        this.scheduletime,
        this.brandname});

  Generates.fromJson(Map<String, dynamic> json) {
    selectItem = json['selectItem'];
    clientname = json['clientname'];
    agencyname = json['agencyname'];
    tapeid = json['tapeid'];
    clockid = json['clockid'];
    commercialcaption = json['commercialcaption'];
    duration = json['duration'];
    toNumber = json['toNumber'];
    bookingDetailCode = json['bookingDetailCode'];
    scheduleDate = json['scheduleDate'];
    scheduletime = json['scheduletime'];
    brandname = json['brandname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectItem'] = this.selectItem;
    data['clientname'] = this.clientname;
    data['agencyname'] = this.agencyname;
    data['tapeid'] = this.tapeid;
    data['clockid'] = this.clockid;
    data['commercialcaption'] = this.commercialcaption;
    data['duration'] = this.duration;
    data['toNumber'] = this.toNumber;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['scheduleDate'] = this.scheduleDate;
    data['scheduletime'] = this.scheduletime;
    data['brandname'] = this.brandname;
    return data;
  }
}
