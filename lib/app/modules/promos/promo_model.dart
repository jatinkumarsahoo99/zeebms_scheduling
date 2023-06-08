class PromoModel {
  List<DailyFPC>? dailyFPC;
  List<PromoScheduled>? promoScheduled;
  List<ActivePromoList>? activePromoList;

  PromoModel({this.dailyFPC, this.promoScheduled, this.activePromoList});

  PromoModel.fromJson(Map<String, dynamic> json) {
    if (json['dailyFPC'] != null) {
      dailyFPC = <DailyFPC>[];
      json['dailyFPC'].forEach((v) {
        dailyFPC!.add(DailyFPC.fromJson(v));
      });
    }
    if (json['promoScheduled'] != null) {
      promoScheduled = <PromoScheduled>[];
      json['promoScheduled'].forEach((v) {
        promoScheduled!.add(PromoScheduled.fromJson(v));
      });
    }
    // if (json['activePromoList'] != null) {
    //   activePromoList = <ActivePromoList>[];
    //   json['activePromoList'].forEach((v) {
    //     activePromoList!.add(new ActivePromoList.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.dailyFPC != null) {
      data['dailyFPC'] = this.dailyFPC!.map((v) => v.toJson()).toList();
    }
    if (this.promoScheduled != null) {
      data['promoScheduled'] = this.promoScheduled!.map((v) => v.toJson()).toList();
    }
    if (this.activePromoList != null) {
      data['activePromoList'] = this.activePromoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyFPC {
  String? startTime;
  String? programName;
  int? episodeNumber;
  String? tapeId;
  String? programCode;
  int? promoCap;
  int? episodeDuration;
  bool exceed = false;

  DailyFPC({
    this.startTime,
    this.programName,
    this.episodeNumber,
    this.tapeId,
    this.programCode,
    this.promoCap,
    this.episodeDuration,
  });

  DailyFPC.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    programName = json['programName'];
    episodeNumber = json['episodeNumber'];
    tapeId = json['tapeId'];
    programCode = json['programCode'];
    promoCap = json['promoCap'];
    episodeDuration = json['episodeDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['programName'] = this.programName;
    data['episodeNumber'] = this.episodeNumber;
    data['tapeId'] = this.tapeId;
    data['programCode'] = this.programCode;
    data['promoCap'] = this.promoCap;
    data['episodeDuration'] = this.episodeDuration;
    return data;
  }
}

class PromoScheduled {
  String? promoPolicyName;
  String? promoCaption;
  int? priority;
  String? promoDuration;
  String? houseId;
  String? programName;
  String? telecastTime;
  String? promoCode;
  String? programCode;
  String? promoSchedulingCode;
  int? rowNo;

  PromoScheduled(
      {this.promoPolicyName,
      this.promoCaption,
      this.priority,
      this.promoDuration,
      this.houseId,
      this.programName,
      this.telecastTime,
      this.promoCode,
      this.programCode,
      this.promoSchedulingCode,
      this.rowNo});

  PromoScheduled.fromJson(Map<String, dynamic> json) {
    promoPolicyName = json['promoPolicyName'];
    promoCaption = json['promoCaption'];
    priority = json['priority'];
    promoDuration = json['promoDuration'];
    houseId = json['houseId'];
    programName = json['programName'];
    telecastTime = json['telecastTime'];
    promoCode = json['promoCode'];
    programCode = json['programCode'];
    promoSchedulingCode = json['promoSchedulingCode'];
    rowNo = json['rowNo'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (fromSave) {
      data['promoCaption'] = this.promoCaption;
      data['priority'] = this.priority;
      data['telecastTime'] = this.telecastTime;
      data['promoCode'] = this.promoCode;
      data['programCode'] = this.programCode;

      // data['promoPolicyName'] = this.promoPolicyName;
      // data['promoDuration'] = this.promoDuration;
      // data['houseId'] = this.houseId;
      // data['programName'] = this.programName;
      // data['promoSchedulingCode'] = this.promoSchedulingCode;
      // data['rowNo'] = this.rowNo;
    } else {
      data['promoPolicyName'] = this.promoPolicyName;
      data['promoCaption'] = this.promoCaption;
      data['priority'] = this.priority;
      data['promoDuration'] = this.promoDuration;
      data['houseId'] = this.houseId;
      data['programName'] = this.programName;
      data['telecastTime'] = this.telecastTime;
      data['promoCode'] = this.promoCode;
      data['programCode'] = this.programCode;
      data['promoSchedulingCode'] = this.promoSchedulingCode;
      data['rowNo'] = this.rowNo;
    }
    return data;
  }
}

class ActivePromoList {
  String? promoCode;
  String? promoCaption;
  String? houseId;
  int? promoDuration;

  ActivePromoList({this.promoCode, this.promoCaption, this.houseId, this.promoDuration});

  ActivePromoList.fromJson(Map<String, dynamic> json) {
    promoCode = json['promoCode'];
    promoCaption = json['promoCaption'];
    houseId = json['houseId'];
    promoDuration = json['promoDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['promoCode'] = this.promoCode;
    data['promoCaption'] = this.promoCaption;
    data['houseId'] = this.houseId;
    data['promoDuration'] = this.promoDuration;
    return data;
  }
}
