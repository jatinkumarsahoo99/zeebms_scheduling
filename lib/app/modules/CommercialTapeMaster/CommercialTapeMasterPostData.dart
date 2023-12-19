class CommercialTapeMasterPostData {
  String? commercialCode;
  String? commercialCaption;
  String? commercialDuration;
  String? exportTapeCode;
  String? exportTapeCaption;
  String? tapeTypeCode;
  String? agencyCode;
  String? brandCode;
  String? som;
  String? recievedOn;
  String? killDate;
  String? houseID;
  String? segmentNumber;
  String? despatchDate;
  String? eventtypecode;
  String? eventsubtype;
  String? agencytapeid;
  String? languagecode;
  String? clockid;
  String? eom;
  String? censorshipCode;
  List<Annotations>? annotations;

  CommercialTapeMasterPostData(
      {this.commercialCode,
        this.commercialCaption,
        this.commercialDuration,
        this.exportTapeCode,
        this.exportTapeCaption,
        this.tapeTypeCode,
        this.agencyCode,
        this.brandCode,
        this.som,
        this.recievedOn,
        this.killDate,
        this.houseID,
        this.segmentNumber,
        this.despatchDate,
        this.eventtypecode,
        this.eventsubtype,
        this.agencytapeid,
        this.languagecode,
        this.clockid,
        this.eom,
        this.censorshipCode,
        this.annotations});

  CommercialTapeMasterPostData.fromJson(Map<String, dynamic> json) {
    commercialCode = json['commercialCode'];
    commercialCaption = json['commercialCaption'];
    commercialDuration = json['commercialDuration'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    tapeTypeCode = json['tapeTypeCode'];
    agencyCode = json['agencyCode'];
    brandCode = json['brandCode'];
    som = json['som'];
    recievedOn = json['recievedOn'];
    killDate = json['killDate'];
    houseID = json['houseID'];
    segmentNumber = json['segmentNumber'];
    despatchDate = json['despatchDate'];
    eventtypecode = json['eventtypecode'];
    eventsubtype = json['eventsubtype'];
    agencytapeid = json['agencytapeid'];
    languagecode = json['languagecode'];
    clockid = json['clockid'];
    eom = json['eom'];
    censorshipCode = json['censorshipCode'];
    if (json['annotations'] != null) {
      annotations = <Annotations>[];
      json['annotations'].forEach((v) {
        annotations!.add(new Annotations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commercialCode'] = this.commercialCode;
    data['commercialCaption'] = this.commercialCaption;
    data['commercialDuration'] = this.commercialDuration;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['tapeTypeCode'] = this.tapeTypeCode;
    data['agencyCode'] = this.agencyCode;
    data['brandCode'] = this.brandCode;
    data['som'] = this.som;
    data['recievedOn'] = this.recievedOn;
    data['killDate'] = this.killDate;
    data['houseID'] = this.houseID;
    data['segmentNumber'] = this.segmentNumber;
    data['despatchDate'] = this.despatchDate;
    data['eventtypecode'] = this.eventtypecode;
    data['eventsubtype'] = this.eventsubtype;
    data['agencytapeid'] = this.agencytapeid;
    data['languagecode'] = this.languagecode;
    data['clockid'] = this.clockid;
    data['eom'] = this.eom;
    data['censorshipCode'] = this.censorshipCode;
    if (this.annotations != null) {
      data['annotations'] = this.annotations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Annotations {
  String? tcIn;
  String? tcOut;
  String? eventName;

  Annotations({this.tcIn, this.tcOut, this.eventName});

  Annotations.fromJson(Map<String, dynamic> json) {
    tcIn = json['tcIn'];
    tcOut = json['tcOut'];
    eventName = json['eventName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tcIn'] = this.tcIn;
    data['tcOut'] = this.tcOut;
    data['eventName'] = this.eventName;
    return data;
  }
}