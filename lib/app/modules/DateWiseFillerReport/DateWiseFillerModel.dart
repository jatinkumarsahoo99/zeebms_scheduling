import 'package:intl/intl.dart';

class DateWiseFillerModel {
  List<DatewiseErrorSpots>? datewiseErrorSpots;

  DateWiseFillerModel({this.datewiseErrorSpots});

  DateWiseFillerModel.fromJson(Map<String, dynamic> json) {
    if (json['datewiseErrorSpots'] != null) {
      datewiseErrorSpots = <DatewiseErrorSpots>[];
      json['datewiseErrorSpots'].forEach((v) {
        datewiseErrorSpots!.add(new DatewiseErrorSpots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datewiseErrorSpots != null) {
      data['datewiseErrorSpots'] =
          this.datewiseErrorSpots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatewiseErrorSpots {
  String? channelname;
  String? locationname;
  String? telecastdate;
  String? telecastTime;
  String? programname;
  String? filler;
  String? duration;
  String? tapeid;
  int? segNo;
  String? fillertype;
  int? break1;
  int? position;

  DatewiseErrorSpots(
      {this.channelname,
      this.locationname,
      this.telecastdate,
      this.telecastTime,
      this.programname,
      this.filler,
      this.duration,
      this.tapeid,
      this.segNo,
      this.fillertype,
      this.break1,
      this.position});

  DatewiseErrorSpots.fromJson(Map<String, dynamic> json) {
    channelname = json['channelname'];
    locationname = json['locationname'];
    telecastdate = json['telecastdate'];
    telecastTime = json['telecastTime'];
    programname = json['programname'];
    filler = json['filler'];
    duration = json['duration'];
    tapeid = json['tapeid'];
    segNo = json['segNo'];
    fillertype = json['fillertype'];
    break1 = json['break'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelname'] = this.channelname;
    data['locationname'] = this.locationname;
    data['telecastdate'] = convertDateFormat(telecastdate);
    data['telecastTime'] = convertDateFormat2(telecastTime ?? "");
    data['programname'] = this.programname;
    data['filler'] = this.filler;
    data['duration'] = this.duration;
    data['tapeid'] = this.tapeid;
    data['segNo'] = this.segNo;
    data['fillertype'] = this.fillertype;
    data['break'] = this.break1;
    data['position'] = this.position;
    return data;
  }

  String convertDateFormat(String? date) {
    if (date != null && date != "") {
      return DateFormat("dd/MM/yyyy")
          .format(DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date));
    }
    return "";
  }

  String convertDateFormat2(String? date) {
    if (date != null && date != "") {
      return DateFormat('d/M/yyyy H:mm a')
          .format(DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date));
    }
    return "";
  }
}
