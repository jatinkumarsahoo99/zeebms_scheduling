class RoBookingSaveCheckTapeId {
  bool? chkSummaryType;
  String? message;
  String? tbROInfoSelectedIndex;
  List<LstdgvbookingSummary>? lstdgvbookingSummary;

  RoBookingSaveCheckTapeId({this.chkSummaryType, this.message, this.tbROInfoSelectedIndex, this.lstdgvbookingSummary});

  RoBookingSaveCheckTapeId.fromJson(Map<String, dynamic> json) {
    chkSummaryType = json['chkSummaryType'];
    message = json['message'];
    tbROInfoSelectedIndex = json['tbROInfo_SelectedIndex'];
    if (json['lstdgvbookingSummary'] != null) {
      lstdgvbookingSummary = <LstdgvbookingSummary>[];
      json['lstdgvbookingSummary'].forEach((v) {
        lstdgvbookingSummary!.add(new LstdgvbookingSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chkSummaryType'] = this.chkSummaryType;
    data['message'] = this.message;
    data['tbROInfo_SelectedIndex'] = this.tbROInfoSelectedIndex;
    if (this.lstdgvbookingSummary != null) {
      data['lstdgvbookingSummary'] = this.lstdgvbookingSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstdgvbookingSummary {
  String? tapeId;
  String? commercialCaption;
  String? brand;
  int? duration;
  int? spots;
  int? spotAmount;
  String? minTelecastDate;
  String? maxTelecastDate;

  LstdgvbookingSummary(
      {this.tapeId, this.commercialCaption, this.brand, this.duration, this.spots, this.spotAmount, this.minTelecastDate, this.maxTelecastDate});

  LstdgvbookingSummary.fromJson(Map<String, dynamic> json) {
    tapeId = json['tapeId'];
    commercialCaption = json['commercialCaption'];
    brand = json['brand'];
    duration = json['duration'];
    spots = json['spots'];
    spotAmount = json['spotAmount'];
    minTelecastDate = json['minTelecastDate'];
    maxTelecastDate = json['maxTelecastDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tapeId'] = this.tapeId;
    data['commercialCaption'] = this.commercialCaption;
    data['brand'] = this.brand;
    data['duration'] = this.duration;
    data['spots'] = this.spots;
    data['spotAmount'] = this.spotAmount;
    data['minTelecastDate'] = this.minTelecastDate;
    data['maxTelecastDate'] = this.maxTelecastDate;
    return data;
  }
}
