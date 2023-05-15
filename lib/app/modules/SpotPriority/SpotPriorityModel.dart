class SpotPriorityModel {
  List<Lstbookingdetail>? lstbookingdetail;
  int? totalCount;
  bool? areRecordExistsInSpotPriority;

  SpotPriorityModel(
      {this.lstbookingdetail,
      this.totalCount,
      this.areRecordExistsInSpotPriority});

  SpotPriorityModel.fromJson(Map<String, dynamic> json) {
    if (json['lstbookingdetail'] != null) {
      lstbookingdetail = <Lstbookingdetail>[];
      json['lstbookingdetail'].forEach((v) {
        lstbookingdetail!.add(new Lstbookingdetail.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
    areRecordExistsInSpotPriority = json['areRecordExistsInSpotPriority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstbookingdetail != null) {
      data['lstbookingdetail'] =
          this.lstbookingdetail!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = this.totalCount;
    data['areRecordExistsInSpotPriority'] = this.areRecordExistsInSpotPriority;
    return data;
  }
}

class Lstbookingdetail {
  String? bookingnumber;
  int? bookingdetailcode;
  String? priorityname;
  String? scheduleDate;
  String? accountname;
  String? clientname;
  String? agencyname;
  String? brandname;
  String? scheduletime;
  String? programname;
  String? exporttapecode;
  String? exporttapecaption;
  int? commercialduration;
  int? spotamount;
  int? priorityCode;

  Lstbookingdetail(
      {this.bookingnumber,
      this.bookingdetailcode,
      this.priorityname,
      this.scheduleDate,
      this.accountname,
      this.clientname,
      this.agencyname,
      this.brandname,
      this.scheduletime,
      this.programname,
      this.exporttapecode,
      this.exporttapecaption,
      this.commercialduration,
      this.spotamount,
      this.priorityCode});

  Lstbookingdetail.fromJson(Map<String, dynamic> json) {
    bookingnumber = json['bookingnumber'];
    bookingdetailcode = json['bookingdetailcode'];
    priorityname = json['priorityname'];
    scheduleDate = json['scheduleDate'];
    accountname = json['accountname'];
    clientname = json['clientname'];
    agencyname = json['agencyname'];
    brandname = json['brandname'];
    scheduletime = json['scheduletime'];
    programname = json['programname'];
    exporttapecode = json['exporttapecode'];
    exporttapecaption = json['exporttapecaption'];
    commercialduration = json['commercialduration'];
    spotamount = json['spotamount'];
    priorityCode = json['priorityCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingnumber'] = this.bookingnumber;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['priorityname'] = this.priorityname;
    data['scheduleDate'] = this.scheduleDate;
    data['accountname'] = this.accountname;
    data['clientname'] = this.clientname;
    data['agencyname'] = this.agencyname;
    data['brandname'] = this.brandname;
    data['scheduletime'] = this.scheduletime;
    data['programname'] = this.programname;
    data['exporttapecode'] = this.exporttapecode;
    data['exporttapecaption'] = this.exporttapecaption;
    data['commercialduration'] = this.commercialduration;
    data['spotamount'] = this.spotamount;
    data['priorityCode'] = this.priorityCode;
    return data;
  }
}
