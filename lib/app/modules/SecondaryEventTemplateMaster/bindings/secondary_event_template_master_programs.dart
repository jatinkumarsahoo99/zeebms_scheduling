import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_program_grid.dart';

class SecondaryEventTemplateMasterProgram {
  bool? firstSegment;
  bool? lastSegment;
  bool? allSegments;
  bool? preEvent;
  bool? postEvent;
  String? eventType;
  String? exportTapeCaption;
  String? exportTapeCode;
  int? segmentNumber;
  int? tapeDuration;
  String? som;
  int? rowNumber;
  String? eventCode;
  int? offSet;

  SecondaryEventTemplateMasterProgram(
      {this.firstSegment,
      this.lastSegment,
      this.allSegments,
      this.preEvent,
      this.postEvent,
      this.eventType,
      this.exportTapeCaption,
      this.exportTapeCode,
      this.segmentNumber,
      this.tapeDuration,
      this.som,
      this.rowNumber,
      this.eventCode,
      this.offSet});

  SecondaryEventTemplateMasterProgram.fromJson(Map<String, dynamic> json) {
    firstSegment = json['firstSegment'];
    lastSegment = json['lastSegment'];
    allSegments = json['allSegments'];
    preEvent = json['preEvent'];
    postEvent = json['postEvent'];
    eventType = json['eventType'];
    exportTapeCaption = json['exportTapeCaption'];
    exportTapeCode = json['exportTapeCode'];
    segmentNumber = json['segmentNumber'];
    tapeDuration = json['tapeDuration'];
    som = json['som'];
    rowNumber = json['rowNumber'];
    eventCode = json['eventCode'];
    offSet = json['offSet'];
  }
  SecondaryEventTemplateMasterProgram.convertSecondaryEventTemplateProgramGridDataToMasterProgram(
      SecondaryEventTemplateProgramGridData programGridData,
      bool _firstSegment,
      bool _lastSegment,
      bool _allSegments,
      bool _preEvent,
      bool _postEvent) {
    firstSegment = _firstSegment;
    lastSegment = _lastSegment;
    allSegments = _allSegments;
    preEvent = _preEvent;
    postEvent = _postEvent;
    eventType = programGridData.eventtype;
    exportTapeCaption = programGridData.caption;
    exportTapeCode = programGridData.txId;
    segmentNumber = programGridData.segmentNumber;
    tapeDuration = programGridData.duration;
    som = programGridData.som;
    rowNumber = null;
    eventCode = programGridData.eventCode;
    offSet = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstSegment'] = firstSegment;
    data['lastSegment'] = lastSegment;
    data['allSegments'] = allSegments;
    data['preEvent'] = preEvent;
    data['postEvent'] = postEvent;
    data['eventType'] = eventType;
    data['exportTapeCaption'] = exportTapeCaption;
    data['exportTapeCode'] = exportTapeCode;
    data['segmentNumber'] = segmentNumber ?? 0;
    data['tapeDuration'] = tapeDuration;
    data['som'] = som;
    data['rowNumber'] = rowNumber;
    data['eventCode'] = eventCode;
    data['offSet'] = offSet ?? 0;
    return data;
  }
}
