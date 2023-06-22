class CommercialTapeMasterData {
  List<LstAnnotation>? lstAnnotation;
  String? commercialCode;
  String? commercialCaption;
  int? commercialDuration;
  String? exportTapeCode;
  String? exportTapeCaption;
  String? tapeTypeCode;
  String? agencyCode;
  String? som;
  String? recievedOn;
  String? dated;
  String? killDate;
  String? houseID;
  int? segmentNumber;
  String? despatchDate;
  String? blanktapeid;
  int? branchcode;
  String? eventtypecode;
  String? agencytapeid;
  String? languagecode;
  String? clockid;
  int? eventsubtype;
  String? eom;
  String? brandCode;
  String? brandName;
  String? clientCode;
  String? clientName;
  String? censorshipCode;
  String? productName;
  String? agencyName;
  String? loginName;
  String? level1Name;
  String? level2Name;
  String? level3Name;

  CommercialTapeMasterData(
      {this.lstAnnotation,
        this.commercialCode,
        this.commercialCaption,
        this.commercialDuration,
        this.exportTapeCode,
        this.exportTapeCaption,
        this.tapeTypeCode,
        this.agencyCode,
        this.som,
        this.recievedOn,
        this.dated,
        this.killDate,
        this.houseID,
        this.segmentNumber,
        this.despatchDate,
        this.blanktapeid,
        this.branchcode,
        this.eventtypecode,
        this.agencytapeid,
        this.languagecode,
        this.clockid,
        this.eventsubtype,
        this.eom,
        this.brandCode,
        this.brandName,
        this.clientCode,
        this.clientName,
        this.censorshipCode,
        this.productName,
        this.agencyName,
        this.loginName,
        this.level1Name,
        this.level2Name,
        this.level3Name});

  CommercialTapeMasterData.fromJson(Map<String, dynamic> json) {
    if (json['lstAnnotation'] != null) {
      lstAnnotation = <LstAnnotation>[];
      json['lstAnnotation'].forEach((v) {
        lstAnnotation!.add(new LstAnnotation.fromJson(v));
      });
    }
    commercialCode = json['commercialCode'];
    commercialCaption = json['commercialCaption'];
    commercialDuration = json['commercialDuration'];
    exportTapeCode = json['exportTapeCode'];
    exportTapeCaption = json['exportTapeCaption'];
    tapeTypeCode = json['tapeTypeCode'];
    agencyCode = json['agencyCode'];
    som = json['som'];
    recievedOn = json['recievedOn'];
    dated = json['dated'];
    killDate = json['killDate'];
    houseID = json['houseID'];
    segmentNumber = json['segmentNumber'];
    despatchDate = json['despatchDate'];
    blanktapeid = json['blanktapeid'];
    branchcode = json['branchcode'];
    eventtypecode = json['eventtypecode'];
    agencytapeid = json['agencytapeid'];
    languagecode = json['languagecode'];
    clockid = json['clockid'];
    eventsubtype = json['eventsubtype'];
    eom = json['eom'];
    brandCode = json['brandCode'];
    brandName = json['brandName'];
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    censorshipCode = json['censorshipCode'];
    productName = json['productName'];
    agencyName = json['agencyName'];
    loginName = json['loginName'];
    level1Name = json['level1Name'];
    level2Name = json['level2Name'];
    level3Name = json['level3Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstAnnotation != null) {
      data['lstAnnotation'] =
          this.lstAnnotation!.map((v) => v.toJson()).toList();
    }
    data['commercialCode'] = this.commercialCode;
    data['commercialCaption'] = this.commercialCaption;
    data['commercialDuration'] = this.commercialDuration;
    data['exportTapeCode'] = this.exportTapeCode;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['tapeTypeCode'] = this.tapeTypeCode;
    data['agencyCode'] = this.agencyCode;
    data['som'] = this.som;
    data['recievedOn'] = this.recievedOn;
    data['dated'] = this.dated;
    data['killDate'] = this.killDate;
    data['houseID'] = this.houseID;
    data['segmentNumber'] = this.segmentNumber;
    data['despatchDate'] = this.despatchDate;
    data['blanktapeid'] = this.blanktapeid;
    data['branchcode'] = this.branchcode;
    data['eventtypecode'] = this.eventtypecode;
    data['agencytapeid'] = this.agencytapeid;
    data['languagecode'] = this.languagecode;
    data['clockid'] = this.clockid;
    data['eventsubtype'] = this.eventsubtype;
    data['eom'] = this.eom;
    data['brandCode'] = this.brandCode;
    data['brandName'] = this.brandName;
    data['clientCode'] = this.clientCode;
    data['clientName'] = this.clientName;
    data['censorshipCode'] = this.censorshipCode;
    data['productName'] = this.productName;
    data['agencyName'] = this.agencyName;
    data['loginName'] = this.loginName;
    data['level1Name'] = this.level1Name;
    data['level2Name'] = this.level2Name;
    data['level3Name'] = this.level3Name;
    return data;
  }
}

class LstAnnotation {
  String? tcIn;
  String? tcOut;
  String? eventName;

  LstAnnotation({this.tcIn, this.tcOut, this.eventName});

  LstAnnotation.fromJson(Map<String, dynamic> json) {
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