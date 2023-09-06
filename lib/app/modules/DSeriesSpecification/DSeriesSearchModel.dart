import 'dart:collection';

class DSeriesSearchModel {
  String? eventType;
  bool? isLastSegment;
  int? startPosition;
  int? endPosition;
  String? dataValue;
  String? description;

  DSeriesSearchModel(
      {this.eventType,
        this.isLastSegment,
        this.startPosition,
        this.endPosition,
        this.dataValue,
        this.description});

  DSeriesSearchModel.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    isLastSegment = json['isLastSegment'];
    startPosition = json['startPosition'];
    endPosition = json['endPosition'];
    dataValue = json['dataValue'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    LinkedHashMap<String, dynamic> data = LinkedHashMap();
    data['eventType'] = this.eventType;
    data['isLastSegment'] = this.isLastSegment;
    data['startPosition'] = this.startPosition;
    data['endPosition'] = this.endPosition;
    data['dataValue'] = this.dataValue;
    data['description'] = this.description;
    return data;
  }
}
