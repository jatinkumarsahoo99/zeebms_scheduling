class FillerSegmentModel {
  int? segNo;
  int? seq;
  int? brkNo;
  int? ponumber;
  String? brktype;
  String? fillerCode;
  String? tapeID;
  String? allowMove;
  String? segmentCaption;
  String? som;
  String? segDur;

  FillerSegmentModel({
    this.segNo,
    this.seq,
    this.brkNo,
    this.ponumber,
    this.brktype,
    this.fillerCode,
    this.tapeID,
    this.allowMove,
    this.segmentCaption,
    this.som,
    this.segDur,
  });

  FillerSegmentModel.fromJson(Map<String, dynamic> json) {
    segNo = (json['segNo'] ?? 0);
    seq = (json['seq'] ?? 0);
    brkNo = (json['brkNo'] ?? 0);
    ponumber = (json['ponumber'] ?? 0);
    brktype = (json['brktype'] ?? 0).toString();
    fillerCode = (json['fillerCode'] ?? 0).toString();
    tapeID = (json['tapeID'] ?? "").toString();
    allowMove = (json['allowMove'] ?? "").toString();
    segmentCaption = (json['segmentCaption'] ?? "").toString();
    som = (json['som'] ?? "").toString();
    segDur = (json['segDur'] ?? "").toString();
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['fillerCode'] = fillerCode;
      data['brktype'] = brktype;
      data['brkNo'] = (brkNo ?? "").toString();
      data['segmentCaption'] = segmentCaption;
      // data['segNo'] = this.segNo;
      // data['seq'] = this.seq;
      // data['ponumber'] = this.ponumber;
      // data['tapeID'] = this.tapeID;
      // data['allowMove'] = this.allowMove;
      // data['som'] = this.som;
      // data['segDur'] = this.segDur;
    } else {
      data['segNo'] = segNo;
      data['seq'] = seq;
      data['brkNo'] = brkNo;
      data['ponumber'] = ponumber;
      data['brktype'] = brktype;
      data['fillerCode'] = fillerCode;
      data['tapeID'] = tapeID;
      data['allowMove'] = allowMove;
      data['segmentCaption'] = segmentCaption;
      data['som'] = som;
      data['segDur'] = segDur;
    }
    return data;
  }
}
