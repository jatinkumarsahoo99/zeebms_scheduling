import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_re_schedule_leave_dart.dart';

class RoRescheduleBookingNumberLeaveData {
  InfoLeaveBookingNumber? infoLeaveBookingNumber;

  RoRescheduleBookingNumberLeaveData({this.infoLeaveBookingNumber});

  RoRescheduleBookingNumberLeaveData.fromJson(Map<String, dynamic> json) {
    infoLeaveBookingNumber = json['info_LeaveBookingNumber'] != null ? InfoLeaveBookingNumber.fromJson(json['info_LeaveBookingNumber']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (infoLeaveBookingNumber != null) {
      data['info_LeaveBookingNumber'] = infoLeaveBookingNumber!.toJson();
    }
    return data;
  }
}

class InfoLeaveBookingNumber {
  String? agencyname;
  String? clientname;
  String? brandname;
  String? dealno;
  String? payRouteName;
  String? zoneName;
  String? bookingEffectiveDate;
  String? zoneCode;
  String? bookingNumber;
  String? bookingMonth;
  List<LstcmbTapeID>? lstcmbTapeID;
  List<LstcmbBulkTape>? lstcmbBulkTape;
  List<LstdgvUpdated>? lstdgvUpdated;
  List? lstDgvRO;

  InfoLeaveBookingNumber(
      {this.agencyname,
      this.clientname,
      this.brandname,
      this.dealno,
      this.payRouteName,
      this.zoneName,
      this.bookingEffectiveDate,
      this.zoneCode,
      this.bookingNumber,
      this.bookingMonth,
      this.lstcmbTapeID,
      this.lstcmbBulkTape,
      this.lstdgvUpdated,
      this.lstDgvRO});

  InfoLeaveBookingNumber.fromJson(Map<String, dynamic> json) {
    agencyname = json['agencyname'];
    clientname = json['clientname'];
    brandname = json['brandname'];
    dealno = json['dealno'];
    payRouteName = json['payRouteName'];
    zoneName = json['zoneName'];
    bookingEffectiveDate = json['bookingEffectiveDate'];
    zoneCode = json['zoneCode'];
    bookingNumber = json['bookingNumber'];
    bookingMonth = json['bookingMonth'];
    if (json['lstcmbTapeID'] != null) {
      lstcmbTapeID = <LstcmbTapeID>[];
      json['lstcmbTapeID'].forEach((v) {
        lstcmbTapeID!.add(LstcmbTapeID.fromJson(v));
      });
    }
    if (json['lstcmbBulkTape'] != null) {
      lstcmbBulkTape = [];
      json['lstcmbBulkTape'].forEach((v) {
        lstcmbBulkTape!.add(LstcmbBulkTape.fromJson(v));
      });
    }
    if (json['lstdgvUpdated'] != null) {
      lstdgvUpdated = [];
      json['lstdgvUpdated'].forEach((v) {
        lstdgvUpdated!.add(LstdgvUpdated.fromJson(v));
      });
    }
    if (json['lstDgvRO'] != null) {
      lstDgvRO = [];
      json['lstDgvRO'].forEach((v) {
        lstDgvRO!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agencyname'] = agencyname;
    data['clientname'] = clientname;
    data['brandname'] = brandname;
    data['dealno'] = dealno;
    data['payRouteName'] = payRouteName;
    data['zoneName'] = zoneName;
    data['bookingEffectiveDate'] = bookingEffectiveDate;
    data['zoneCode'] = zoneCode;
    data['bookingNumber'] = bookingNumber;
    data['bookingMonth'] = bookingMonth;
    if (lstcmbTapeID != null) {
      data['lstcmbTapeID'] = lstcmbTapeID!.map((v) => v.toJson()).toList();
    }
    if (lstcmbBulkTape != null) {
      data['lstcmbBulkTape'] = lstcmbBulkTape!.map((v) => v.toJson()).toList();
    }
    if (lstdgvUpdated != null) {
      data['lstdgvUpdated'] = lstdgvUpdated!.map((v) => v.toJson()).toList();
    }
    if (lstDgvRO != null) {
      data['lstDgvRO'] = lstDgvRO!.map((v) => v).toList();
    }
    return data;
  }
}
