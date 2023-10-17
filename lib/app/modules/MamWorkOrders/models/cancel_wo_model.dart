import 'package:intl/intl.dart';

class CancelWOModel {
  int? rowNumber;
  bool? cancelWO;
  String? contentType;
  String? vendor;
  String? language;
  String? location;
  String? channel;
  String? program;
  num? ep;
  String? telecastType;
  String? tapeId;
  String? telecastDate;
  String? telecastTime;
  int? epiSegCnt;
  int? woId;

  CancelWOModel(
      {this.cancelWO,
      this.contentType,
      this.vendor,
      this.language,
      this.location,
      this.channel,
      this.program,
      this.ep,
      this.telecastType,
      this.tapeId,
      this.telecastDate,
      this.telecastTime,
      this.epiSegCnt,
      this.woId});

  CancelWOModel.fromJson(Map<String, dynamic> json) {
    cancelWO = json['cancelWO'];
    rowNumber = json['rownumber'];
    contentType = json['contentType'];
    vendor = json['vendor'];
    language = json['language'];
    location = json['location'];
    channel = json['channel'];
    program = json['program'];
    ep = json['ep'];
    telecastType = json['telecastType'];
    tapeId = json['tapeId'];
    telecastDate = json['telDate'];
    telecastTime = json['telTime'];
    epiSegCnt = json['epiSegCnt'];
    woId = json['woId'];
  }

  parsedDate(String? dateTime) {
    return (dateTime ?? '').contains("T")
        ? DateFormat("dd-MM-yyyy")
            .format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateTime!))
        : (dateTime ?? '');
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['cancelWO'] = cancelWO;
      data['contentType'] = contentType;
      data['vendor'] = vendor;
      data['language'] = language;
      data['location'] = location;
      data['channel'] = channel;
      data['program'] = program;
      data['ep'] = ep;
      data['telecastType'] = telecastType;
      data['tapeId'] = tapeId;
      data['telecastDate'] = telecastDate;
      data['telecastTime'] = telecastTime;
      data['epiSegCnt'] = epiSegCnt;
      data['woId'] = woId;
    } else {
      data['rownumber'] = (rowNumber ?? -1).toString();
      data['cancelWO'] = (cancelWO ?? false).toString();
      data['contentType'] = contentType;
      data['vendor'] = vendor;
      data['language'] = language;
      data['location'] = location;
      data['channel'] = channel;
      data['program'] = program;
      data['ep#'] = ep ?? '';
      data['telecastType'] = telecastType;
      data['tapeId'] = tapeId;
      data['telecastDate'] = parsedDate(telecastDate);
      data['telecastTime'] = telecastTime ?? '';
      data['epiSegCnt'] = epiSegCnt;
      data['woId'] = woId;
    }
    return data;
  }
}
