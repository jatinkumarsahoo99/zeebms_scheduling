class SecondaryEventTemplateProgramGridData {
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

  SecondaryEventTemplateProgramGridData(
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

  SecondaryEventTemplateProgramGridData.fromJson(Map<String, dynamic> json) {
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
