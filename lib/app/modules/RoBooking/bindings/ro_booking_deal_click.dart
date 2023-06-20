class RoBookingDealDblClick {
  String? message;
  List<String>? dgvProgramsAllowColumnsEditingTrue;
  List<String>? dgvProgramsVisiableTrue;
  List<String>? dgvProgramsVisiableFalse;
  List<String>? dgvProgramsColumnMaxInputLength4;
  List<LstProgram>? lstProgram;
  List? lstDealConsumption;
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
      this.revenueType,
      this.preMid,
      this.positionNo,
      this.breakNo,
      this.rate,
      this.total,
      this.brandResponse});

  RoBookingDealDblClick.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    dgvProgramsAllowColumnsEditingTrue = (json['dgvPrograms_AllowColumnsEditing_True'] ?? <String>[]).cast<String>();
    dgvProgramsVisiableTrue = (json['dgvPrograms_Visiable_True'] ?? <String>[]).cast<String>();
    dgvProgramsVisiableFalse = (json['dgvPrograms_Visiable_False'] ?? <String>[]).cast<String>();
    dgvProgramsColumnMaxInputLength4 = (json['dgvPrograms_Column_MaxInputLength_4'] ?? <String>[]).cast<String>();
    if (json['lstProgram'] != null) {
      lstProgram = <LstProgram>[];
      json['lstProgram'].forEach((v) {
        lstProgram!.add(LstProgram.fromJson(v));
      });
    }
    if (json['lstDealConsumption'] != null) {
      lstDealConsumption = [];
      json['lstDealConsumption'].forEach((v) {
        lstDealConsumption!.add(v);
      });
    }

    revenueType = json['revenueType'];
    preMid = json['preMid'];
    positionNo = json['positionNo'];
    breakNo = json['breakNo'];
    rate = json['rate'];
    total = json['total'];
    brandResponse = json['brandResponse'] != null ? BrandResponse.fromJson(json['brandResponse']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['dgvPrograms_AllowColumnsEditing_True'] = dgvProgramsAllowColumnsEditingTrue;
    data['dgvPrograms_Visiable_True'] = dgvProgramsVisiableTrue;
    data['dgvPrograms_Visiable_False'] = dgvProgramsVisiableFalse;
    data['dgvPrograms_Column_MaxInputLength_4'] = dgvProgramsColumnMaxInputLength4;
    if (lstProgram != null) {
      data['lstProgram'] = lstProgram!.map((v) => v.toJson()).toList();
    }
    data['lstDealConsumption'] = lstDealConsumption;
    data['revenueType'] = revenueType;
    data['preMid'] = preMid;
    data['positionNo'] = positionNo;
    data['breakNo'] = breakNo;
    data['rate'] = rate;
    data['total'] = total;
    if (brandResponse != null) {
      data['brandResponse'] = brandResponse!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['telecastdate'] = telecastdate;
    data['bookedSpots'] = bookedSpots;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['programName'] = programName;
    data['availableDuration'] = availableDuration;
    data['programcode'] = programcode;
    return data;
  }
}

class BrandResponse {
  String? lstDealNumber;
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
        lstTapeDetails!.add(LstTapeDetails.fromJson(v));
      });
    }
    if (json['lstTapeCampaign'] != null) {
      lstTapeCampaign = <LstTapeCampaign>[];
      json['lstTapeCampaign'].forEach((v) {
        lstTapeCampaign!.add(LstTapeCampaign.fromJson(v));
      });
    }
    dealNo = json['dealNo'];
    preMid = json['preMid'];
    positionNo = json['positionNo'];
    breakNo = json['breakNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lstDealNumber'] = lstDealNumber;
    if (lstTapeDetails != null) {
      data['lstTapeDetails'] = lstTapeDetails!.map((v) => v.toJson()).toList();
    }
    if (lstTapeCampaign != null) {
      data['lstTapeCampaign'] = lstTapeCampaign!.map((v) => v.toJson()).toList();
    }
    data['dealNo'] = dealNo;
    data['preMid'] = preMid;
    data['positionNo'] = positionNo;
    data['breakNo'] = breakNo;
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
  int? subRevenueTypeCode;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commercialCode'] = commercialCode;
    data['exporttapecode'] = exporttapecode;
    data['commercialcaption'] = commercialcaption;
    data['segmentnumber'] = segmentnumber;
    data['commercialduration'] = commercialduration;
    data['agencytapeid'] = agencytapeid;
    data['languageName'] = languageName;
    data['eventtypecode'] = eventtypecode;
    data['accountName'] = accountName;
    data['subRevenueTypeCode'] = subRevenueTypeCode;
    data['subRevenueTypeName'] = subRevenueTypeName;
    data['killDate'] = killDate;
    data['campaignStartDate'] = campaignStartDate;
    data['campaignEndDate'] = campaignEndDate;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exportTapeCode'] = exportTapeCode;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['brandCode'] = brandCode;
    return data;
  }
}
