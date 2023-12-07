class InsertSearchModel {
  LstListMyEventData? lstListMyEventData;

  InsertSearchModel({this.lstListMyEventData});

  InsertSearchModel.fromJson(Map<String, dynamic> json) {
    lstListMyEventData = json['lstListMyEventClips'] != null
        ? new LstListMyEventData.fromJson(json['lstListMyEventClips'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstListMyEventData != null) {
      data['lstListMyEventClips'] = this.lstListMyEventData!.toJson();
    }
    return data;
  }
}

class LstListMyEventData {
  List<LstListMyEventClips>? lstListMyEventClips;
  List<LstFastInsertTags>? lstFastInsertTags;
  num totalDuration = 0;
  String? popUpMessage;

  LstListMyEventData({this.lstListMyEventClips, this.lstFastInsertTags});

  LstListMyEventData.fromJson(Map<String, dynamic> json) {
    if (json['lstListMyEventClips'] != null) {
      lstListMyEventClips = <LstListMyEventClips>[];
      json['lstListMyEventClips'].forEach((v) {
        totalDuration = totalDuration + v["duration"];
        lstListMyEventClips!.add(new LstListMyEventClips.fromJson(v));
      });
    }
    if (json['lstFastInsertTags'] != null) {
      lstFastInsertTags = <LstFastInsertTags>[];
      json['lstFastInsertTags'].forEach((v) {
        lstFastInsertTags!.add(new LstFastInsertTags.fromJson(v));
      });
    }

    popUpMessage = json["popUpMessage"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstListMyEventClips != null) {
      data['lstListMyEventClips'] =
          this.lstListMyEventClips!.map((v) => v.toJson()).toList();
    }
    if (this.lstFastInsertTags != null) {
      data['lstFastInsertTags'] =
          this.lstFastInsertTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstListMyEventClips {
  String? eventtype;
  String? caption;
  String? txCaption;
  String? txId;
  int? duration;
  String? som;
  int? segmentNumber;
  String? languagename;
  String? promoTypeCode;
  String? eventCode;

  LstListMyEventClips(
      {this.eventtype,
      this.caption,
      this.txCaption,
      this.txId,
      this.duration,
      this.som,
      this.segmentNumber,
      this.languagename,
      this.promoTypeCode,
      this.eventCode});

  LstListMyEventClips.fromJson(Map<String, dynamic> json) {
    eventtype = json['eventtype'];
    caption = json['caption'];
    txCaption = json['txCaption'];
    txId = json['txId'];
    duration = json['duration'];
    som = json['som'];
    segmentNumber = json['segmentNumber'];
    languagename = json['languagename'];
    promoTypeCode = json['promoTypeCode'];
    eventCode = json['eventCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventtype'] = this.eventtype;
    data['caption'] = this.caption;
    data['txCaption'] = this.txCaption;
    data['txId'] = this.txId;
    data['duration'] = this.duration;
    data['som'] = this.som;
    data['segmentNumber'] = this.segmentNumber;
    data['languagename'] = this.languagename;
    data['promoTypeCode'] = this.promoTypeCode;
    data['eventCode'] = this.eventCode;
    return data;
  }
}

class LstFastInsertTags {
  Null? crTapeID;
  int? tagSegmentnumber;
  Null? eventtype;
  Null? exportTapeCaption;
  int? promoDuration;
  String? som;
  Null? promoTypeCode;
  Null? tagTapeid;
  int? segmentNumber;

  LstFastInsertTags(
      {this.crTapeID,
      this.tagSegmentnumber,
      this.eventtype,
      this.exportTapeCaption,
      this.promoDuration,
      this.som,
      this.promoTypeCode,
      this.tagTapeid,
      this.segmentNumber});

  LstFastInsertTags.fromJson(Map<String, dynamic> json) {
    crTapeID = json['crTapeID'];
    tagSegmentnumber = json['tagSegmentnumber'];
    eventtype = json['eventtype'];
    exportTapeCaption = json['exportTapeCaption'];
    promoDuration = json['promoDuration'];
    som = json['som'];
    promoTypeCode = json['promoTypeCode'];
    tagTapeid = json['tagTapeid'];
    segmentNumber = json['segmentNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crTapeID'] = this.crTapeID;
    data['tagSegmentnumber'] = this.tagSegmentnumber;
    data['eventtype'] = this.eventtype;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['promoDuration'] = this.promoDuration;
    data['som'] = this.som;
    data['promoTypeCode'] = this.promoTypeCode;
    data['tagTapeid'] = this.tagTapeid;
    data['segmentNumber'] = this.segmentNumber;
    return data;
  }
}
