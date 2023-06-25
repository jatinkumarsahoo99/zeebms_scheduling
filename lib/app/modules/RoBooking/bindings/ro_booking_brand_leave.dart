class RoBookingBrandLeave {
  List? lstDealNumber;
  List? lstTapeDetails;
  List? lstTapeCampaign;
  String? dealNo;
  String? preMid;
  String? positionNo;
  String? breakNo;

  RoBookingBrandLeave({this.lstDealNumber, this.lstTapeDetails, this.lstTapeCampaign, this.dealNo, this.preMid, this.positionNo, this.breakNo});

  RoBookingBrandLeave.fromJson(Map<String, dynamic> json) {
    if (json['lstDealNumber'] != null) {
      lstDealNumber = <Null>[];
      json['lstDealNumber'].forEach((v) {
        lstDealNumber!.add(v);
      });
    }
    if (json['lstTapeDetails'] != null) {
      lstTapeDetails = <Null>[];
      json['lstTapeDetails'].forEach((v) {
        lstTapeDetails!.add(v);
      });
    }
    if (json['lstTapeCampaign'] != null) {
      lstTapeCampaign = <Null>[];
      json['lstTapeCampaign'].forEach((v) {
        lstTapeCampaign!.add(v);
      });
    }
    dealNo = json['dealNo'];
    preMid = json['preMid'];
    positionNo = json['positionNo'];
    breakNo = json['breakNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lstDealNumber != null) {
      data['lstDealNumber'] = lstDealNumber!.map((v) => v).toList();
    }
    if (lstTapeDetails != null) {
      data['lstTapeDetails'] = lstTapeDetails!.map((v) => v).toList();
    }
    if (lstTapeCampaign != null) {
      data['lstTapeCampaign'] = lstTapeCampaign!.map((v) => v).toList();
    }
    data['dealNo'] = dealNo;
    data['preMid'] = preMid;
    data['positionNo'] = positionNo;
    data['breakNo'] = breakNo;
    return data;
  }
}
