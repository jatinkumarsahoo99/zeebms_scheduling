class RoBookingDealDblClick {
  String? message;
  List<String>? dgvProgramsAllowColumnsEditingTrue;
  List<String>? dgvProgramsVisiableTrue;
  List? dgvProgramsVisiableFalse;
  List<String>? dgvProgramsColumnMaxInputLength4;
  List<LstProgram>? lstProgram;
  List? lstDealConsumption;
  String? strAccountCode;
  String? intSubRevenueTypeCode;
  String? revenueType;
  String? preMid;
  String? positionNo;
  String? breakNo;
  String? rate;
  String? total;
  BrandResponse? brandResponse;

  RoBookingDealDblClick(
      {this.message,
      this.dgvProgramsAllowColumnsEditingTrue,
      this.dgvProgramsVisiableTrue,
      this.dgvProgramsVisiableFalse,
      this.dgvProgramsColumnMaxInputLength4,
      this.lstProgram,
      this.lstDealConsumption,
      this.strAccountCode,
      this.intSubRevenueTypeCode,
      this.revenueType,
      this.preMid,
      this.positionNo,
      this.breakNo,
      this.rate,
      this.total,
      this.brandResponse});

  RoBookingDealDblClick.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    dgvProgramsAllowColumnsEditingTrue = json['dgvPrograms_AllowColumnsEditing_True'].cast<String>();
    dgvProgramsVisiableTrue = json['dgvPrograms_Visiable_True'].cast<String>();
    if (json['dgvPrograms_Visiable_False'] != null) {
      dgvProgramsVisiableFalse = [];
      json['dgvPrograms_Visiable_False'].forEach((v) {
        dgvProgramsVisiableFalse!.add(v);
      });
    }
    dgvProgramsColumnMaxInputLength4 = json['dgvPrograms_Column_MaxInputLength_4'].cast<String>();
    if (json['lstProgram'] != null) {
      lstProgram = <LstProgram>[];
      json['lstProgram'].forEach((v) {
        lstProgram!.add(new LstProgram.fromJson(v));
      });
    }
    if (json['lstDealConsumption'] != null) {
      lstDealConsumption = [];
      json['lstDealConsumption'].forEach((v) {
        lstDealConsumption!.add(v);
      });
    }
    strAccountCode = json['strAccountCode'];
    intSubRevenueTypeCode = json['intSubRevenueTypeCode'];
    revenueType = json['revenueType'];
    preMid = json['preMid'];
    positionNo = json['positionNo'];
    breakNo = json['breakNo'];
    rate = json['rate'];
    total = json['total'];
    brandResponse = json['brandResponse'] != null ? new BrandResponse.fromJson(json['brandResponse']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['dgvPrograms_AllowColumnsEditing_True'] = this.dgvProgramsAllowColumnsEditingTrue;
    data['dgvPrograms_Visiable_True'] = this.dgvProgramsVisiableTrue;
    if (this.dgvProgramsVisiableFalse != null) {
      data['dgvPrograms_Visiable_False'] = this.dgvProgramsVisiableFalse!.map((v) => v.toJson()).toList();
    }
    data['dgvPrograms_Column_MaxInputLength_4'] = this.dgvProgramsColumnMaxInputLength4;
    if (this.lstProgram != null) {
      data['lstProgram'] = this.lstProgram!.map((v) => v.toJson()).toList();
    }
    if (this.lstDealConsumption != null) {
      data['lstDealConsumption'] = this.lstDealConsumption!.map((v) => v.toJson()).toList();
    }
    data['strAccountCode'] = this.strAccountCode;
    data['intSubRevenueTypeCode'] = this.intSubRevenueTypeCode;
    data['revenueType'] = this.revenueType;
    data['preMid'] = this.preMid;
    data['positionNo'] = this.positionNo;
    data['breakNo'] = this.breakNo;
    data['rate'] = this.rate;
    data['total'] = this.total;
    if (this.brandResponse != null) {
      data['brandResponse'] = this.brandResponse!.toJson();
    }
    return data;
  }
}

class LstProgram {
  String? telecastdate;
  int? bookedSpots;
  String? startTime;
  String? endTime;
  String? programName;
  int? availableDuration;
  String? programcode;

  LstProgram({this.telecastdate, this.bookedSpots, this.startTime, this.endTime, this.programName, this.availableDuration, this.programcode});

  LstProgram.fromJson(Map<String, dynamic> json) {
    telecastdate = json['telecastdate'];
    bookedSpots = json['bookedSpots'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    availableDuration = json['availableDuration'];
    programcode = json['programcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['telecastdate'] = this.telecastdate;
    data['bookedSpots'] = this.bookedSpots;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['programName'] = this.programName;
    data['availableDuration'] = this.availableDuration;
    data['programcode'] = this.programcode;
    return data;
  }
}

class BrandResponse {
  Null? lstDealNumber;
  List<LstTapeDetails>? lstTapeDetails;
  List<LstTapeCampaign>? lstTapeCampaign;
  String? dealNo;
  String? preMid;
  String? positionNo;
  String? breakNo;

  BrandResponse({this.lstDealNumber, this.lstTapeDetails, this.lstTapeCampaign, this.dealNo, this.preMid, this.positionNo, this.breakNo});

  BrandResponse.fromJson(Map<String, dynamic> json) {
    lstDealNumber = json['lstDealNumber'];
    if (json['lstTapeDetails'] != null) {
      lstTapeDetails = <LstTapeDetails>[];
      json['lstTapeDetails'].forEach((v) {
        lstTapeDetails!.add(new LstTapeDetails.fromJson(v));
      });
    }
    if (json['lstTapeCampaign'] != null) {
      lstTapeCampaign = <LstTapeCampaign>[];
      json['lstTapeCampaign'].forEach((v) {
        lstTapeCampaign!.add(new LstTapeCampaign.fromJson(v));
      });
    }
    dealNo = json['dealNo'];
    preMid = json['preMid'];
    positionNo = json['positionNo'];
    breakNo = json['breakNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lstDealNumber'] = this.lstDealNumber;
    if (this.lstTapeDetails != null) {
      data['lstTapeDetails'] = this.lstTapeDetails!.map((v) => v.toJson()).toList();
    }
    if (this.lstTapeCampaign != null) {
      data['lstTapeCampaign'] = this.lstTapeCampaign!.map((v) => v.toJson()).toList();
    }
    data['dealNo'] = this.dealNo;
    data['preMid'] = this.preMid;
    data['positionNo'] = this.positionNo;
    data['breakNo'] = this.breakNo;
    return data;
  }
}

class LstTapeDetails {
  String? commercialCode;
  String? exporttapecode;
  String? commercialcaption;
  int? segmentnumber;
  int? commercialduration;
  String? agencytapeid;
  String? languageName;
  String? eventtypecode;
  String? accountName;
  Null? subRevenueTypeCode;
  String? subRevenueTypeName;
  String? killDate;
  String? campaignStartDate;
  String? campaignEndDate;

  LstTapeDetails(
      {this.commercialCode,
      this.exporttapecode,
      this.commercialcaption,
      this.segmentnumber,
      this.commercialduration,
      this.agencytapeid,
      this.languageName,
      this.eventtypecode,
      this.accountName,
      this.subRevenueTypeCode,
      this.subRevenueTypeName,
      this.killDate,
      this.campaignStartDate,
      this.campaignEndDate});

  LstTapeDetails.fromJson(Map<String, dynamic> json) {
    commercialCode = json['commercialCode'];
    exporttapecode = json['exporttapecode'];
    commercialcaption = json['commercialcaption'];
    segmentnumber = json['segmentnumber'];
    commercialduration = json['commercialduration'];
    agencytapeid = json['agencytapeid'];
    languageName = json['languageName'];
    eventtypecode = json['eventtypecode'];
    accountName = json['accountName'];
    subRevenueTypeCode = json['subRevenueTypeCode'];
    subRevenueTypeName = json['subRevenueTypeName'];
    killDate = json['killDate'];
    campaignStartDate = json['campaignStartDate'];
    campaignEndDate = json['campaignEndDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commercialCode'] = this.commercialCode;
    data['exporttapecode'] = this.exporttapecode;
    data['commercialcaption'] = this.commercialcaption;
    data['segmentnumber'] = this.segmentnumber;
    data['commercialduration'] = this.commercialduration;
    data['agencytapeid'] = this.agencytapeid;
    data['languageName'] = this.languageName;
    data['eventtypecode'] = this.eventtypecode;
    data['accountName'] = this.accountName;
    data['subRevenueTypeCode'] = this.subRevenueTypeCode;
    data['subRevenueTypeName'] = this.subRevenueTypeName;
    data['killDate'] = this.killDate;
    data['campaignStartDate'] = this.campaignStartDate;
    data['campaignEndDate'] = this.campaignEndDate;
    return data;
  }
}

class LstTapeCampaign {
  String? exportTapeCode;
  String? startDate;
  String? endDate;
  String? brandCode;

  LstTapeCampaign({this.exportTapeCode, this.startDate, this.endDate, this.brandCode});

  LstTapeCampaign.fromJson(Map<String, dynamic> json) {
    exportTapeCode = json['exportTapeCode'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    brandCode = json['brandCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exportTapeCode'] = this.exportTapeCode;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['brandCode'] = this.brandCode;
    return data;
  }
}
