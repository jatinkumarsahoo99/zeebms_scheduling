class RoBookingAgencyLeaveData {
  String? message;
  String? gstPlantID;
  String? gstRegNo;
  String? gstPlantIDCheck;
  String? gstRegNoCheck;
  String? gstRegN;
  String? gstPlants;
  List<LstGstPlants>? lstGstPlants;
  List? lstPdcList;
  List<LstDealNumber>? lstDealNumber;
  List<ExcutiveDetails>? excutiveDetails;
  List<LstExcutive>? lstExcutive;
  String? selectedExcutiveCode;
  String? selectedExcutiveName;
  String? zone;
  String? zoneName;
  String? zoneCode;
  String? payroute;
  String? payRouteCode;
  String? bookingNumber;

  RoBookingAgencyLeaveData(
      {this.message,
      this.gstPlantID,
      this.gstRegNo,
      this.gstPlantIDCheck,
      this.gstRegNoCheck,
      this.gstRegN,
      this.gstPlants,
      this.lstGstPlants,
      this.lstPdcList,
      this.lstDealNumber,
      this.excutiveDetails,
      this.lstExcutive,
      this.selectedExcutiveCode,
      this.selectedExcutiveName,
      this.zone,
      this.zoneName,
      this.zoneCode,
      this.payroute,
      this.payRouteCode,
      this.bookingNumber});

  RoBookingAgencyLeaveData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    gstPlantID = json['gstPlantID'];
    gstRegNo = json['gstRegNo'];
    gstPlantIDCheck = json['gstPlantID_Check'];
    gstRegNoCheck = json['gstRegNo_Check'];
    gstRegN = json['gstRegN'];
    gstPlants = json['gstPlants'];
    if (json['lstGstPlants'] != null) {
      lstGstPlants = <LstGstPlants>[];
      json['lstGstPlants'].forEach((v) {
        lstGstPlants!.add(LstGstPlants.fromJson(v));
      });
    }
    if (json['lstPdcList'] != null) {
      lstPdcList = <Null>[];
      json['lstPdcList'].forEach((v) {
        lstPdcList!.add(v);
      });
    }
    if (json['lstDealNumber'] != null) {
      lstDealNumber = <LstDealNumber>[];
      json['lstDealNumber'].forEach((v) {
        lstDealNumber!.add(LstDealNumber.fromJson(v));
      });
    }
    if (json['excutiveDetails'] != null) {
      excutiveDetails = <ExcutiveDetails>[];
      json['excutiveDetails'].forEach((v) {
        excutiveDetails!.add(ExcutiveDetails.fromJson(v));
      });
    }
    if (json['lstExcutive'] != null) {
      lstExcutive = <LstExcutive>[];
      json['lstExcutive'].forEach((v) {
        lstExcutive!.add(LstExcutive.fromJson(v));
      });
    }
    selectedExcutiveCode = json['selectedExcutiveCode'];
    selectedExcutiveName = json['selectedExcutiveName'];
    zone = json['zone'];
    zoneName = json['zoneName'];
    zoneCode = json['zoneCode'];
    payroute = json['payroute'];
    payRouteCode = json['payRouteCode'];
    bookingNumber = json['bookingNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['gstPlantID'] = gstPlantID;
    data['gstRegNo'] = gstRegNo;
    data['gstPlantID_Check'] = gstPlantIDCheck;
    data['gstRegNo_Check'] = gstRegNoCheck;
    data['gstRegN'] = gstRegN;
    data['gstPlants'] = gstPlants;
    if (lstGstPlants != null) {
      data['lstGstPlants'] = lstGstPlants!.map((v) => v.toJson()).toList();
    }
    if (lstPdcList != null) {
      data['lstPdcList'] = lstPdcList!.map((v) => v).toList();
    }
    if (lstDealNumber != null) {
      data['lstDealNumber'] = lstDealNumber!.map((v) => v.toJson()).toList();
    }
    if (excutiveDetails != null) {
      data['excutiveDetails'] = excutiveDetails!.map((v) => v.toJson()).toList();
    }
    if (lstExcutive != null) {
      data['lstExcutive'] = lstExcutive!.map((v) => v.toJson()).toList();
    }
    data['selectedExcutiveCode'] = selectedExcutiveCode;
    data['selectedExcutiveName'] = selectedExcutiveName;
    data['zone'] = zone;
    data['zoneName'] = zoneName;
    data['zoneCode'] = zoneCode;
    data['payroute'] = payroute;
    data['payRouteCode'] = payRouteCode;
    data['bookingNumber'] = bookingNumber;
    return data;
  }
}

class LstGstPlants {
  int? plantid;
  String? column1;

  LstGstPlants({this.plantid, this.column1});

  LstGstPlants.fromJson(Map<String, dynamic> json) {
    plantid = json['plantid'];
    column1 = json['column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plantid'] = plantid;
    data['column1'] = column1;
    return data;
  }
}

class LstDealNumber {
  String? dealNumber;
  String? dealNumber1;

  LstDealNumber({this.dealNumber, this.dealNumber1});

  LstDealNumber.fromJson(Map<String, dynamic> json) {
    dealNumber = json['dealNumber'];
    dealNumber1 = json['dealNumber1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealNumber'] = dealNumber;
    data['dealNumber1'] = dealNumber1;
    return data;
  }
}

class ExcutiveDetails {
  String? personnelCode;
  String? personnelname;
  String? zonename;
  String? payroutename;
  String? zoneshortname;
  String? zonecode;
  String? payRouteCode;

  ExcutiveDetails({this.personnelCode, this.personnelname, this.zonename, this.payroutename, this.zoneshortname, this.zonecode, this.payRouteCode});

  ExcutiveDetails.fromJson(Map<String, dynamic> json) {
    personnelCode = json['personnelCode'];
    personnelname = json['personnelname'];
    zonename = json['zonename'];
    payroutename = json['payroutename'];
    zoneshortname = json['zoneshortname'];
    zonecode = json['zonecode'];
    payRouteCode = json['payRouteCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['personnelCode'] = personnelCode;
    data['personnelname'] = personnelname;
    data['zonename'] = zonename;
    data['payroutename'] = payroutename;
    data['zoneshortname'] = zoneshortname;
    data['zonecode'] = zonecode;
    data['payRouteCode'] = payRouteCode;
    return data;
  }
}

class LstExcutive {
  String? personnelCode;
  String? personnelName;

  LstExcutive({this.personnelCode, this.personnelName});

  LstExcutive.fromJson(Map<String, dynamic> json) {
    personnelCode = json['personnelCode'];
    personnelName = json['personnelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['personnelCode'] = personnelCode;
    data['personnelName'] = personnelName;
    return data;
  }
}
