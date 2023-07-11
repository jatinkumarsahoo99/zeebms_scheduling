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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstSegment'] = this.firstSegment;
    data['lastSegment'] = this.lastSegment;
    data['allSegments'] = this.allSegments;
    data['preEvent'] = this.preEvent;
    data['postEvent'] = this.postEvent;
    data['eventType'] = this.eventType;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['exportTapeCode'] = this.exportTapeCode;
    data['segmentNumber'] = this.segmentNumber;
    data['tapeDuration'] = this.tapeDuration;
    data['som'] = this.som;
    data['rowNumber'] = this.rowNumber;
    data['eventCode'] = this.eventCode;
    data['offSet'] = this.offSet;
    return data;
  }
}
