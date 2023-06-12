class AgencyLeaveData {
  String? message;
  String? gstPlantID;
  String? gstRegNo;
  String? gstPlantIDCheck;
  String? gstRegNoCheck;
  String? gstRegN;
  String? gstPlants;
  List? lstPdcList;
  List<LstDealNumber>? lstDealNumber;
  String? excutiveDetails;
  List<LstExcutive>? lstExcutive;
  String? zone;
  String? zoneName;
  String? zoneCode;
  String? payroute;
  String? payRouteCode;
  String? bookingNumber;

  AgencyLeaveData(
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

  AgencyLeaveData.fromJson(Map<String, dynamic> json) {
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
    excutiveDetails = json['excutiveDetails'];
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

class LstDealNumber {
  String? dealNumber;
  Null? dealNumber2;

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
