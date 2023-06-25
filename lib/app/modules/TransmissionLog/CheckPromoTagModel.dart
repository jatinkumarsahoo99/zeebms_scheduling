class CheckPromoTagModel {
  List<LstCheckPromoTags>? lstCheckPromoTags;

  CheckPromoTagModel({this.lstCheckPromoTags});

  CheckPromoTagModel.fromJson(Map<String, dynamic> json) {
    if (json['lstCheckPromoTags'] != null) {
      lstCheckPromoTags = <LstCheckPromoTags>[];
      json['lstCheckPromoTags'].forEach((v) {
        lstCheckPromoTags!.add(new LstCheckPromoTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstCheckPromoTags != null) {
      data['lstCheckPromoTags'] =
          this.lstCheckPromoTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstCheckPromoTags {
  String? cRtapeid;
  String? act;
  String? tgtapeid;

  LstCheckPromoTags({this.cRtapeid, this.act, this.tgtapeid});

  LstCheckPromoTags.fromJson(Map<String, dynamic> json) {
    cRtapeid = json['CRtapeid'];
    act = json['Act'];
    tgtapeid = json['tgtapeid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CRtapeid'] = this.cRtapeid;
    data['Act'] = this.act;
    data['tgtapeid'] = this.tgtapeid;
    return data;
  }
}
