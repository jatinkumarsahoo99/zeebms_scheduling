class SlideModel {
  String? fpcTime;
  String? programCode;
  String? programName;
  bool? stationIdCheck;
  bool? presentsCheck;
  bool? presentationCheck;
  bool? commProgCheck;
  bool? commMenuCheck;
  bool? commUpTom;
  bool? networkId;
  bool? marrideId;

  SlideModel(
      {this.fpcTime,
      this.programCode,
      this.programName,
      this.stationIdCheck,
      this.presentsCheck,
      this.presentationCheck,
      this.commProgCheck,
      this.commMenuCheck,
      this.commUpTom,
      this.networkId,
      this.marrideId});

  SlideModel.fromJson(Map<String, dynamic> json) {
    fpcTime = json['fpcTime'];
    programCode = json['programCode'];
    programName = json['programName'];

    stationIdCheck = json['stationIdCheck'];
    presentsCheck = json['presentsCheck'];
    presentationCheck = json['presentationCheck'];
    commProgCheck = json['commProgCheck'];
    commMenuCheck = json['commMenuCheck'];
    commUpTom = json['commUpTom'];
    networkId = json['networkId'];
    marrideId = json['marrideId'];
  }

  Map<String, dynamic> toJson({bool fromSave = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromSave) {
      data['fpcTime'] = "2023-03-28T$fpcTime";
      data['programCode'] = programCode;
      // data['programName'] = programName;
      data['stationIdCheck'] = stationIdCheck;
      data['presentsCheck'] = presentsCheck;
      data['presentationCheck'] = presentationCheck;
      data['commProgCheck'] = commProgCheck;
      data['commMenuCheck'] = commMenuCheck;
      data['commUpTom'] = commUpTom;
      data['networkId'] = networkId;
      data['marrideId'] = marrideId;
    } else {
      data['fpcTime'] = fpcTime;
      data['programCode'] = programCode;
      data['programName'] = programName;
      data['stationIdCheck'] = stationIdCheck.toString();
      data['presentsCheck'] = presentsCheck.toString();
      data['presentationCheck'] = presentationCheck.toString();
      data['commProgCheck'] = commProgCheck.toString();
      data['commMenuCheck'] = commMenuCheck.toString();
      data['commUpTom'] = commUpTom.toString();
      data['networkId'] = networkId.toString();
      data['marrideId'] = marrideId.toString();
    }
    return data;
  }
}
