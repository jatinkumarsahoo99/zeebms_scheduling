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
    if (dailyFPC != null) {
      data['dailyFPC'] = dailyFPC!.map((v) => v.toJson()).toList();
    }
    if (promoScheduled != null) {
      data['promoScheduled'] = promoScheduled!.map((v) => v.toJson()).toList();
    }
    if (activePromoList != null) {
      data['activePromoList'] = activePromoList!.map((v) => v.toJson()).toList();
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
    data['startTime'] = startTime;
    data['programName'] = programName;
    data['episodeNumber'] = episodeNumber;
    data['tapeId'] = tapeId;
    data['programCode'] = programCode;
    data['promoCap'] = promoCap;
    data['episodeDuration'] = episodeDuration;
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
      data['promoCaption'] = promoCaption ?? "";
      data['priority'] = priority ?? "";
      data['telecastTime'] = telecastTime ?? "";
      data['promoCode'] = promoCode ?? "";
      data['programCode'] = programCode ?? "";

      // data['promoPolicyName'] = this.promoPolicyName;
      // data['promoDuration'] = this.promoDuration;
      // data['houseId'] = this.houseId;
      // data['programName'] = this.programName;
      // data['promoSchedulingCode'] = this.promoSchedulingCode;
      // data['rowNo'] = this.rowNo;
    } else {
      data['promoPolicyName'] = promoPolicyName;
      data['promoCaption'] = promoCaption;
      data['priority'] = priority;
      data['promoDuration'] = promoDuration;
      data['houseId'] = houseId;
      data['programName'] = programName;
      data['telecastTime'] = telecastTime;
      data['promoCode'] = promoCode;
      data['programCode'] = programCode;
      data['promoSchedulingCode'] = promoSchedulingCode;
      data['rowNo'] = rowNo;
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
    data['promoCode'] = promoCode;
    data['promoCaption'] = promoCaption;
    data['houseId'] = houseId;
    data['promoDuration'] = promoDuration;
    return data;
  }
}
