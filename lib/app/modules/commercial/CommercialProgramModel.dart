class CommercialProgramModel {
  String? startTime;
  String? programName;
  String? episodeNumber;
  String? tapeId;
  String? programCode;
  String? promoCap;
  int? episodeDuration;
  bool? isSelected=false;


  CommercialProgramModel(
      {this.startTime,
        this.programName,
        this.episodeNumber,
        this.tapeId,
        this.programCode,
        this.promoCap,
        this.episodeDuration});

  CommercialProgramModel.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    programName = json['programName'];
    episodeNumber = (json['episodeNumber']??"").toString();
    tapeId = json['tapeId'];
    programCode = json['programCode'];
    promoCap = (json['promoCap']??'').toString();
    episodeDuration = json['episodeDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['programName'] = this.programName;
    data['episodeNumber'] = this.episodeNumber;
    data['tapeId'] = this.tapeId;
    data['programCode'] = this.programCode;
    data['promoCap'] = this.promoCap;
    data['episodeDuration'] = this.episodeDuration;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['programName'] = this.programName;
    // data['episodeNumber'] = this.episodeNumber;
    // data['tapeId'] = this.tapeId;
    // data['programCode'] = this.programCode;
    // data['promoCap'] = this.promoCap;
    // data['episodeDuration'] = this.episodeDuration;
    return data;
  }

}
