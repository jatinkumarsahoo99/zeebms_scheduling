class AsrunFPCData {
  String? programName;
  String? telecastdate;
  String? starttime;
  String? endtime;
  String? exporttapecode;
  String? programcose;
  int? present;

  AsrunFPCData(
      {this.programName,
      this.telecastdate,
      this.starttime,
      this.endtime,
      this.exporttapecode,
      this.programcose,
      this.present});

  AsrunFPCData.fromJson(Map<String, dynamic> json) {
    programName = json['programName'];
    telecastdate = json['telecastdate'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    exporttapecode = json['exporttapecode'];
    programcose = json['programcose'];
    present = json['present'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programName'] = this.programName;
    data['telecastdate'] = this.telecastdate;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['exporttapecode'] = this.exporttapecode;
    data['programcose'] = this.programcose;
    data['present'] = this.present;
    return data;
  }
}
