import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_bkg_data.dart';

class SpotsNotVerifiedClickData {
  String? locationCode;
  String? channelCode;
  int? bookingMonth;
  String? bookingNumber;
  String? tbROInfoSelectedIndex;
  List<String>? dgvVerifySpotsColumnsVisiableFalse;
  List<String>? dgvVerifySpotsAllowColumnsEditingTrue;
  List? lstdgvVerifySpot;
  RoBookingBkgNOLeaveData? lstDisplayResponse;

  SpotsNotVerifiedClickData(
      {this.locationCode,
      this.channelCode,
      this.bookingMonth,
      this.bookingNumber,
      this.tbROInfoSelectedIndex,
      this.dgvVerifySpotsColumnsVisiableFalse,
      this.dgvVerifySpotsAllowColumnsEditingTrue,
      this.lstdgvVerifySpot,
      this.lstDisplayResponse});

  SpotsNotVerifiedClickData.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    bookingMonth = json['bookingMonth'];
    bookingNumber = json['bookingNumber'];
    tbROInfoSelectedIndex = json['tbROInfo_SelectedIndex'];
    dgvVerifySpotsColumnsVisiableFalse = json['dgvVerifySpots_Columns_Visiable_False'].cast<String>();
    dgvVerifySpotsAllowColumnsEditingTrue = json['dgvVerifySpots_AllowColumnsEditing_True'].cast<String>();
    if (json['lstdgvVerifySpot'] != null) {
      lstdgvVerifySpot = [];
      json['lstdgvVerifySpot'].forEach((v) {
        lstdgvVerifySpot!.add(v);
      });
    }
    lstDisplayResponse = json['lstDisplay_Response'] != null ? new RoBookingBkgNOLeaveData.fromJson(json['lstDisplay_Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationCode'] = this.locationCode;
    data['channelCode'] = this.channelCode;
    data['bookingMonth'] = this.bookingMonth;
    data['bookingNumber'] = this.bookingNumber;
    data['tbROInfo_SelectedIndex'] = this.tbROInfoSelectedIndex;
    data['dgvVerifySpots_Columns_Visiable_False'] = this.dgvVerifySpotsColumnsVisiableFalse;
    data['dgvVerifySpots_AllowColumnsEditing_True'] = this.dgvVerifySpotsAllowColumnsEditingTrue;
    if (this.lstdgvVerifySpot != null) {
      data['lstdgvVerifySpot'] = this.lstdgvVerifySpot!.map((v) => v).toList();
    }
    if (this.lstDisplayResponse != null) {
      data['lstDisplay_Response'] = this.lstDisplayResponse!.toJson();
    }
    return data;
  }
}
