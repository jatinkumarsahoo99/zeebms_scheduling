class DigitexRunOrderData {
  String? message;
  List<MissingClients>? missingClients;
  List<Map>? newBrands;
  List<Map>? newClocks;
  List<MissingAgencies>? missingAgencies;
  List<MissingLinks>? missingLinks;
  List<MyData>? myData;
  List<ImportRunOrderStatus>? importRunOrderStatus;

  DigitexRunOrderData(
      {this.message,
      this.missingClients,
      this.newBrands,
      this.newClocks,
      this.missingAgencies,
      this.missingLinks,
      this.myData,
      this.importRunOrderStatus});

  DigitexRunOrderData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['missingClients'] != null) {
      missingClients = <MissingClients>[];
      json['missingClients'].forEach((v) {
        missingClients!.add(MissingClients.fromJson(v));
      });
    }
    if (json['newBrands'] != null) {
      newBrands = [];
      json['newBrands'].forEach((v) {
        newBrands!.add(v);
      });
    }
    if (json['newClocks'] != null) {
      newClocks = [];
      json['newClocks'].forEach((v) {
        newClocks!.add(v);
      });
    }
    if (json['missingAgencies'] != null) {
      missingAgencies = <MissingAgencies>[];
      json['missingAgencies'].forEach((v) {
        missingAgencies!.add(MissingAgencies.fromJson(v));
      });
    }
    if (json['missingLinks'] != null) {
      missingLinks = <MissingLinks>[];
      json['missingLinks'].forEach((v) {
        missingLinks!.add(MissingLinks.fromJson(v));
      });
    }
    if (json['myData'] != null) {
      myData = <MyData>[];
      json['myData'].forEach((v) {
        myData!.add(MyData.fromJson(v));
      });
    }
    if (json['importRunOrderStatus'] != null) {
      importRunOrderStatus = <ImportRunOrderStatus>[];
      json['importRunOrderStatus'].forEach((v) {
        importRunOrderStatus!.add(ImportRunOrderStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (missingClients != null) {
      data['missingClients'] = missingClients!.map((v) => v.toJson()).toList();
    }
    if (newBrands != null) {
      data['newBrands'] = newBrands!;
    }
    if (newClocks != null) {
      data['newClocks'] = newClocks!;
    }
    if (missingAgencies != null) {
      data['missingAgencies'] =
          missingAgencies!.map((v) => v.toJson()).toList();
    }
    if (missingLinks != null) {
      data['missingLinks'] = missingLinks!.map((v) => v.toJson()).toList();
    }
    if (myData != null) {
      data['myData'] = myData!.map((v) => v.toJson()).toList();
    }
    if (importRunOrderStatus != null) {
      data['importRunOrderStatus'] =
          importRunOrderStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MissingClients {
  String? clientstoCreate;
  String? clientName;
  String? clientCode;

  MissingClients({this.clientstoCreate, this.clientName, this.clientCode});

  MissingClients.fromJson(Map<String, dynamic> json) {
    clientstoCreate = json['clientstoCreate'];
    clientName = json['clientName'];
    clientCode = json['clientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientstoCreate'] = clientstoCreate;
    data['clientName'] = clientName;
    data['clientCode'] = clientCode;
    return data;
  }
}

class MissingAgencies {
  String? agenciestoCreate;
  String? agenciesName;
  String? agenciesCode;

  MissingAgencies(
      {this.agenciestoCreate, this.agenciesName, this.agenciesCode});

  MissingAgencies.fromJson(Map<String, dynamic> json) {
    agenciestoCreate = json['agenciestoCreate'];
    agenciesName = json['agenciesName'];
    agenciesCode = json['agenciesCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agenciestoCreate'] = agenciestoCreate;
    data['agenciesName'] = agenciesName;
    data['agenciesCode'] = agenciesCode;
    return data;
  }
}

class MissingLinks {
  String? clientName;
  String? agencyName;

  MissingLinks({this.clientName, this.agencyName});

  MissingLinks.fromJson(Map<String, dynamic> json) {
    clientName = json['clientName'];
    agencyName = json['agencyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientName'] = clientName;
    data['agencyName'] = agencyName;
    return data;
  }
}

class MyData {
  int? rid;
  String? breakid;
  String? digiClockId;
  int? duration;
  String? commercialCaption;
  int? spotid;
  String? digiBRandName;
  String? digiclientName;
  String? digiAgencyName;
  String? agencyCode1;
  String? bmSClientcode;
  double? cps;
  String? breakStatus;
  String? clockStatus;
  String? importStatus;
  String? clientName;
  String? agencyName;

  MyData(
      {this.rid,
      this.breakid,
      this.digiClockId,
      this.duration,
      this.commercialCaption,
      this.spotid,
      this.digiBRandName,
      this.digiclientName,
      this.digiAgencyName,
      this.agencyCode1,
      this.bmSClientcode,
      this.cps,
      this.breakStatus,
      this.clockStatus,
      this.importStatus,
      this.clientName,
      this.agencyName});

  MyData.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    breakid = json['breakid'];
    digiClockId = json['digiClockId'];
    duration = json['duration'];
    commercialCaption = json['commercialCaption'];
    spotid = json['spotid'];
    digiBRandName = json['digiBRandName'];
    digiclientName = json['digiclientName'];
    digiAgencyName = json['digiAgencyName'];
    agencyCode1 = json['agencyCode1'];
    bmSClientcode = json['bmS_Clientcode'];
    cps = json['cps'];
    breakStatus = json['breakStatus'];
    clockStatus = json['clockStatus'];
    importStatus = json['importStatus'];
    clientName = json['clientName'];
    agencyName = json['agencyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rid'] = rid;
    data['breakid'] = breakid;
    data['digiClockId'] = digiClockId;
    data['duration'] = duration;
    data['commercialCaption'] = commercialCaption;
    data['spotid'] = spotid;
    data['digiBRandName'] = digiBRandName;
    data['digiclientName'] = digiclientName;
    data['digiAgencyName'] = digiAgencyName;
    data['agencyCode1'] = agencyCode1;
    data['bmS_Clientcode'] = bmSClientcode;
    data['cps'] = cps;
    data['breakStatus'] = breakStatus;
    data['clockStatus'] = clockStatus;
    data['importStatus'] = importStatus;
    data['clientName'] = clientName;
    data['agencyName'] = agencyName;
    return data;
  }
}

class ImportRunOrderStatus {
  String? importStatus;

  ImportRunOrderStatus({this.importStatus});

  ImportRunOrderStatus.fromJson(Map<String, dynamic> json) {
    importStatus = json['importStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['importStatus'] = importStatus;
    return data;
  }
}
