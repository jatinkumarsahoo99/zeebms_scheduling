import 'ro_booking_bkg_data.dart';

class RoBookingAddSpotData {
  List<String>? message;
  String? revenueType;
  String? strAccountCode;
  String? dblOldBookingAmount;
  String? totalSpots;
  String? totalDuration;
  String? totalAmount;
  String? totSpots;
  int? intSecondsToBook;
  int? intBookingCount;
  List<LstSpots>? lstSpots;
  List<LstdgvDealDetails>? lstdgvDealDetails;

  List<LstdgvProgram>? lstdgvProgram;

  RoBookingAddSpotData(
      {this.message,
      this.revenueType,
      this.strAccountCode,
      this.dblOldBookingAmount,
      this.totalSpots,
      this.totalDuration,
      this.totalAmount,
      this.totSpots,
      this.intSecondsToBook,
      this.intBookingCount,
      this.lstSpots,
      this.lstdgvDealDetails,
      this.lstdgvProgram});

  RoBookingAddSpotData.fromJson(Map<String, dynamic> json) {
    message = json['message'].cast<String>();
    revenueType = json['revenueType'];
    strAccountCode = json['strAccountCode'];
    dblOldBookingAmount = json['dblOldBookingAmount'];
    totalSpots = json['totalSpots'];
    totalDuration = json['totalDuration'];
    totalAmount = json['totalAmount'];
    totSpots = json['totSpots'];
    intSecondsToBook = json['intSecondsToBook'];
    intBookingCount = json['intBookingCount'];
    if (json['lstSpots'] != null) {
      lstSpots = <LstSpots>[];
      json['lstSpots'].forEach((v) {
        lstSpots!.add(LstSpots.fromJson(v));
      });
    }
    if (json['lstdgvDealDetails'] != null) {
      lstdgvDealDetails = <LstdgvDealDetails>[];
      json['lstdgvDealDetails'].forEach((v) {
        lstdgvDealDetails!.add(LstdgvDealDetails.fromJson(v));
      });
    }
    if (lstdgvProgram != null) {
      json['lstdgvProgram'] = lstdgvProgram!.map((v) => v.toJson()).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['revenueType'] = this.revenueType;
    data['strAccountCode'] = this.strAccountCode;
    data['dblOldBookingAmount'] = this.dblOldBookingAmount;
    data['totalSpots'] = this.totalSpots;
    data['totalDuration'] = this.totalDuration;
    data['totalAmount'] = this.totalAmount;
    data['totSpots'] = this.totSpots;
    data['intSecondsToBook'] = this.intSecondsToBook;
    data['intBookingCount'] = this.intBookingCount;
    data['lstSpots'] = this.lstSpots;
    data['lstdgvDealDetails'] = this.lstdgvDealDetails;
    data['lstdgvProgram'] = this.lstdgvProgram;
    return data;
  }
}

class LstdgvProgram {
  String? telecastdate;
  int? bookedSpots;
  String? startTime;
  String? endTime;
  String? programName;
  int? availableDuration;
  String? programcode;

  LstdgvProgram({this.telecastdate, this.bookedSpots, this.startTime, this.endTime, this.programName, this.availableDuration, this.programcode});

  LstdgvProgram.fromJson(Map<String, dynamic> json) {
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
