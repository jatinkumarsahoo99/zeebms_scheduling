class RoBookingTapeLeave {
  String? caption;
  String? agencyId;
  String? cboSegNo;
  String? duration;
  String? total;
  String? language;
  String? tapeRevenue;
  String? tapeSubRevenue;
  String? campStartDate;
  String? campEndDate;
  String? dtpKillDate;
  List<LstdgvProgram>? lstdgvProgram;
  int? intCountBased;
  int? intBaseDuration;

  RoBookingTapeLeave(
      {this.caption,
      this.agencyId,
      this.cboSegNo,
      this.duration,
      this.total,
      this.language,
      this.tapeRevenue,
      this.tapeSubRevenue,
      this.campStartDate,
      this.campEndDate,
      this.dtpKillDate,
      this.lstdgvProgram,
      this.intCountBased,
      this.intBaseDuration});

  RoBookingTapeLeave.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    agencyId = json['agencyId'];
    cboSegNo = json['cboSegNo'];
    duration = json['duration'];
    total = json['total'];
    language = json['language'];
    tapeRevenue = json['tapeRevenue'];
    tapeSubRevenue = json['tapeSubRevenue'];
    campStartDate = json['campStartDate'];
    campEndDate = json['campEndDate'];
    dtpKillDate = json['dtpKillDate'];
    if (json['lstdgvProgram'] != null) {
      lstdgvProgram = <LstdgvProgram>[];
      json['lstdgvProgram'].forEach((v) {
        lstdgvProgram!.add(LstdgvProgram.fromJson(v));
      });
    }
    intCountBased = json['intCountBased'];
    intBaseDuration = json['intBaseDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['agencyId'] = agencyId;
    data['cboSegNo'] = cboSegNo;
    data['duration'] = duration;
    data['total'] = total;
    data['language'] = language;
    data['tapeRevenue'] = tapeRevenue;
    data['tapeSubRevenue'] = tapeSubRevenue;
    data['campStartDate'] = campStartDate;
    data['campEndDate'] = campEndDate;
    data['dtpKillDate'] = dtpKillDate;
    if (lstdgvProgram != null) {
      data['lstdgvProgram'] = lstdgvProgram!.map((v) => v.toJson()).toList();
    }
    data['intCountBased'] = intCountBased;
    data['intBaseDuration'] = intBaseDuration;
    return data;
  }
}

class LstdgvProgram {
  String? telecastdate;
  int? bookedSpots;
  String? startTime;
  String? endTime;
  String? programName;
  int? availableDuration;
  String? programcode;

  LstdgvProgram(
      {this.telecastdate,
      this.bookedSpots,
      this.startTime,
      this.endTime,
      this.programName,
      this.availableDuration,
      this.programcode});

  LstdgvProgram.fromJson(Map<String, dynamic> json) {
    telecastdate = json['telecastdate'];
    bookedSpots = json['bookedSpots'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    programName = json['programName'];
    availableDuration = json['availableDuration'];
    programcode = json['programcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['telecastdate'] = telecastdate;
    data['bookedSpots'] = bookedSpots;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['programName'] = programName;
    data['availableDuration'] = availableDuration;
    data['programcode'] = programcode;
    return data;
  }
}
