import 'ro_booking_bkg_data.dart';

class RoBookingDealNoLeave {
  int? intPDCReqd;
  String? message;
  String? dealFromDate;
  String? dealtoDate;
  String? dealType;
  String? payMode;
  String? maxSpend;
  List<LstdgvDealDetails>? lstdgvDealDetails;
  List? lstdgvLinkedDeals;
  String? previousBookedAmount;
  String? previousValAmount;
  String? strRevenueTypeCode;
  List<LstBrand>? lstBrand;

  RoBookingDealNoLeave(
      {this.intPDCReqd,
      this.message,
      this.dealFromDate,
      this.dealtoDate,
      this.dealType,
      this.payMode,
      this.maxSpend,
      this.lstdgvDealDetails,
      this.lstdgvLinkedDeals,
      this.previousBookedAmount,
      this.previousValAmount,
      this.strRevenueTypeCode,
      this.lstBrand});

  RoBookingDealNoLeave.fromJson(Map<String, dynamic> json) {
    intPDCReqd = json['intPDCReqd'];
    message = json['message'];
    dealFromDate = json['dealFromDate'];
    dealtoDate = json['dealtoDate'];
    dealType = json['dealType'];
    payMode = json['payMode'];
    maxSpend = json['maxSpend'];
    if (json['lstdgvDealDetails'] != null) {
      lstdgvDealDetails = <LstdgvDealDetails>[];
      json['lstdgvDealDetails'].forEach((v) {
        lstdgvDealDetails!.add(new LstdgvDealDetails.fromJson(v));
      });
    }
    lstdgvLinkedDeals = json['lstdgvLinkedDeals'];
    previousBookedAmount = json['previousBookedAmount'];
    previousValAmount = json['previousValAmount'];
    strRevenueTypeCode = json['strRevenueTypeCode'];
    if (json['lstBrand'] != null) {
      lstBrand = <LstBrand>[];
      json['lstBrand'].forEach((v) {
        lstBrand!.add(new LstBrand.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intPDCReqd'] = intPDCReqd;
    data['message'] = message;
    data['dealFromDate'] = dealFromDate;
    data['dealtoDate'] = dealtoDate;
    data['dealType'] = dealType;
    data['payMode'] = payMode;
    data['maxSpend'] = maxSpend;
    if (lstdgvDealDetails != null) {
      data['lstdgvDealDetails'] = lstdgvDealDetails!.map((v) => v.toJson()).toList();
    }
    data['lstdgvLinkedDeals'] = lstdgvLinkedDeals;
    data['previousBookedAmount'] = previousBookedAmount;
    data['previousValAmount'] = previousValAmount;
    data['strRevenueTypeCode'] = strRevenueTypeCode;
    if (lstBrand != null) {
      data['lstBrand'] = lstBrand!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstBrand {
  String? brandcode;
  String? brandname;

  LstBrand({this.brandcode, this.brandname});

  LstBrand.fromJson(Map<String, dynamic> json) {
    brandcode = json['brandcode'];
    brandname = json['brandname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandcode'] = brandcode;
    data['brandname'] = brandname;
    return data;
  }
}
