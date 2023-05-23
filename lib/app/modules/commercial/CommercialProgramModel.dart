class CommercialProgramModel {

  String? fpcTime;
  String? programname;
  String? programcode;

  CommercialProgramModel({
      this.fpcTime,
      this.programname,
      this.programcode,
      });

  CommercialProgramModel.fromJson(Map<String, dynamic> json) {
    fpcTime = json['fpcTime'];
    programname = json['programname'];
    programcode = (json['programcode']??"").toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fpcTime'] = this.fpcTime;
    data['programname'] = this.programname;
    data['programcode'] = this.programcode;
    return data;
  }

}
