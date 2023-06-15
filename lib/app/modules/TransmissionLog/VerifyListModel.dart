class VerifyListModel {
  List<LstCheckTimeBetweenCommercials>? lstCheckTimeBetweenCommercials;

  VerifyListModel({this.lstCheckTimeBetweenCommercials});

  VerifyListModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['lstCheckTimeBetweenCommercials'] != null) {
      lstCheckTimeBetweenCommercials = <LstCheckTimeBetweenCommercials>[];
      json['lstCheckTimeBetweenCommercials'].forEach((v) {
        lstCheckTimeBetweenCommercials!
            .add(new LstCheckTimeBetweenCommercials.fromJson(v));
      });
    }
    if (json['lstVerifyInDetails'] != null) {
      lstCheckTimeBetweenCommercials = <LstCheckTimeBetweenCommercials>[];
      json['lstVerifyInDetails'].forEach((v) {
        lstCheckTimeBetweenCommercials!
            .add(new LstCheckTimeBetweenCommercials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstCheckTimeBetweenCommercials != null) {
      data['lstCheckTimeBetweenCommercials'] =
          this.lstCheckTimeBetweenCommercials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstCheckTimeBetweenCommercials {
  String? eventType;
  String? exportTapeCode;
  String? exportTapeCaption;
  int? separationTime;
  int? minTime;

  LstCheckTimeBetweenCommercials(
      {this.eventType,
        this.exportTapeCode,
        this.exportTapeCaption,
        this.separationTime,
        this.minTime});

  LstCheckTimeBetweenCommercials.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    separationTime = json['separationTime'];
    minTime = json['minTime']??json['mintime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = this.eventType;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['separationTime'] = this.separationTime;
    data['minTime'] = this.minTime;
    return data;
  }
}