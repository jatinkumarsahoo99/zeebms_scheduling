class FillerSegmentModel {

  int? segNo;
  int? seq;
  int? brkNo;
  int? ponumber;
  int? brktype;
  int? fillerCode;
  String? tapeID;
  String? allowMove;
  String? segmentCaption;
  String? som;
  String? segDur;


  FillerSegmentModel({ this.segNo, this.seq, this.brkNo,
    this.ponumber, this.brktype, this.fillerCode, this.tapeID,
    this.allowMove, this.segmentCaption, this.som, this.segDur});

  FillerSegmentModel.fromJson(Map<String, dynamic> json) {
    segNo = (json['segNo']??0);
    seq = (json['seq']??0);
    brkNo = (json['brkNo']??0);
    ponumber = (json['ponumber']??0);
    brktype = (json['brktype']??0);
    fillerCode = (json['fillerCode']??0);
    tapeID = (json['tapeID']??"").toString();
    allowMove = (json['allowMove']??"").toString();
    segmentCaption = (json['segmentCaption']??"").toString();
    som = (json['som']??"").toString();
    segDur = (json['segDur']??"").toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['segNo'] = this.segNo;
    data['seq'] = this.seq;
    data['brkNo'] = this.brkNo;
    data['ponumber'] = this.ponumber;
    data['brktype'] = this.brktype;
    data['fillerCode'] = this.fillerCode;
    data['tapeID'] = this.tapeID;
    data['allowMove'] = this.allowMove;
    data['segmentCaption'] = this.segmentCaption;
    data['som'] = this.som;
    data['segDur'] = this.segDur;
    return data;
  }

}
