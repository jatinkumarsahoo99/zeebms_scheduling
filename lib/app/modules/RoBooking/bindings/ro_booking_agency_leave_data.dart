class RoBookingAgencyLeaveData {
  String? message;
  String? gstPlantID;
  String? gstRegNo;
  String? gstPlantIDCheck;
  String? gstRegNoCheck;
  String? gstRegN;
  String? gstPlants;
  List? lstPdcList;
  List<LstDealNumber>? lstDealNumber;
  List<ExcutiveDetails>? excutiveDetails;
  List<LstExcutive>? lstExcutive;
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
      this.lstPdcList,
      this.lstDealNumber,
      this.excutiveDetails,
      this.lstExcutive,
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
    if (json['lstPdcList'] != null) {
      lstPdcList = <Null>[];
      json['lstPdcList'].forEach((v) {
        lstPdcList!.add(v);
      });
    }
    if (json['lstDealNumber'] != null) {
      lstDealNumber = <LstDealNumber>[];
      json['lstDealNumber'].forEach((v) {
        lstDealNumber!.add(new LstDealNumber.fromJson(v));
      });
    }

    if (json['excutiveDetails'] != null) {
      excutiveDetails = <ExcutiveDetails>[];
      json['excutiveDetails'].forEach((v) {
        excutiveDetails!.add(new ExcutiveDetails.fromJson(v));
      });
    }
    if (json['lstExcutive'] != null) {
      lstExcutive = <LstExcutive>[];
      json['lstExcutive'].forEach((v) {
        lstExcutive!.add(new LstExcutive.fromJson(v));
      });
    }
    zone = json['zone'];
    zoneName = json['zoneName'];
    zoneCode = json['zoneCode'];
    payroute = json['payroute'];
    payRouteCode = json['payRouteCode'];
    bookingNumber = json['bookingNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['gstPlantID'] = this.gstPlantID;
    data['gstRegNo'] = this.gstRegNo;
    data['gstPlantID_Check'] = this.gstPlantIDCheck;
    data['gstRegNo_Check'] = this.gstRegNoCheck;
    data['gstRegN'] = this.gstRegN;
    data['gstPlants'] = this.gstPlants;
    if (this.lstPdcList != null) {
      data['lstPdcList'] = this.lstPdcList!.map((v) => v).toList();
    }
    if (this.lstDealNumber != null) {
      data['lstDealNumber'] = this.lstDealNumber!.map((v) => v.toJson()).toList();
    }
    data['excutiveDetails'] = this.excutiveDetails;
    if (this.lstExcutive != null) {
      data['lstExcutive'] = this.lstExcutive!.map((v) => v.toJson()).toList();
    }
    data['zone'] = this.zone;
    data['zoneName'] = this.zoneName;
    data['zoneCode'] = this.zoneCode;
    data['payroute'] = this.payroute;
    data['payRouteCode'] = this.payRouteCode;
    data['bookingNumber'] = this.bookingNumber;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personnelCode'] = this.personnelCode;
    data['personnelname'] = this.personnelname;
    data['zonename'] = this.zonename;
    data['payroutename'] = this.payroutename;
    data['zoneshortname'] = this.zoneshortname;
    data['zonecode'] = this.zonecode;
    data['payRouteCode'] = this.payRouteCode;
    return data;
  }
}

class LstDealNumber {
  String? dealNumber;
  String? dealNumber2;

  LstDealNumber({this.dealNumber, this.dealNumber2});

  LstDealNumber.fromJson(Map<String, dynamic> json) {
    dealNumber = json['dealNumber'];
    dealNumber2 = json['dealNumber2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dealNumber'] = this.dealNumber;
    data['dealNumber2'] = this.dealNumber2;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personnelCode'] = this.personnelCode;
    data['personnelName'] = this.personnelName;
    return data;
  }
}
