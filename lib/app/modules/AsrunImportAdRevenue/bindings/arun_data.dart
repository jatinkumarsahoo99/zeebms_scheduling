class AsRunData {
  int? eventNumber;
  String? telecastdate;
  String? fpctIme;
  String? programName;
  String? programCode;
  String? telecasttime;
  String? tapeId;
  int? segmentnumber;
  String? caption;
  String? telecastDuration;
  String? vtr;
  String? ch;
  String? eventtype;
  String? bookingnumber;
  int? bookingdetailcode;
  String? scheduletime;
  String? scheduledProgram;
  String? rosBand;
  String? programTime;
  String? isMismatch;
  String? scheduledate;
  String? tapeDuration;
  String? fpc;
  String? dur;
  String? ros;
  String? backColor;
  String? foreColor;

  AsRunData(
      {this.eventNumber,
      this.telecastdate,
      this.fpctIme,
      this.programName,
      this.programCode,
      this.telecasttime,
      this.tapeId,
      this.segmentnumber,
      this.caption,
      this.telecastDuration,
      this.vtr,
      this.ch,
      this.eventtype,
      this.bookingnumber,
      this.bookingdetailcode,
      this.scheduletime,
      this.scheduledProgram,
      this.rosBand,
      this.programTime,
      this.isMismatch,
      this.scheduledate,
      this.tapeDuration,
      this.fpc,
      this.dur,
      this.ros,
      this.backColor,
      this.foreColor});

  AsRunData.fromJson(Map<String, dynamic> json) {
    eventNumber = json['eventNumber'];
    telecastdate = json['telecastdate'];
    fpctIme = json['fpctIme'];
    programName = json['programName'];
    programCode = json['programCode'];
    telecasttime = json['telecasttime'];
    tapeId = json['tapeId'];
    segmentnumber = json['segmentnumber'] is String ? int.tryParse(json['segmentnumber']) : json['segmentnumber'];
    caption = json['caption'];
    telecastDuration = json['telecastDuration'];
    vtr = json['vtr'];
    ch = json['ch'];
    eventtype = json['eventtype'];
    bookingnumber = json['bookingnumber'];
    bookingdetailcode = json['bookingdetailcode'] is String ? int.tryParse(json['bookingdetailcode']) : json['bookingdetailcode'];
    scheduletime = json['scheduletime'];
    scheduledProgram = json['scheduledProgram'];
    rosBand = json['rosBand'];
    programTime = json['programTime'];
    isMismatch = json['isMismatch'];
    scheduledate = json['scheduledate'];
    tapeDuration = json['tapeDuration'];
    fpc = json['fpc'];
    dur = json['dur'];
    ros = json['ros'];
    backColor = json['backColor'];
    foreColor = json['foreColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventNumber'] = this.eventNumber;
    data['telecastdate'] = this.telecastdate;
    data['fpctIme'] = this.fpctIme;
    data['programName'] = this.programName;
    data['programCode'] = this.programCode;
    data['telecasttime'] = this.telecasttime;
    data['tapeId'] = this.tapeId;
    data['segmentnumber'] = this.segmentnumber;
    data['caption'] = this.caption;
    data['telecastDuration'] = this.telecastDuration;
    data['vtr'] = this.vtr;
    data['ch'] = this.ch;
    data['eventtype'] = this.eventtype;
    data['bookingnumber'] = this.bookingnumber;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['scheduletime'] = this.scheduletime;
    data['scheduledProgram'] = this.scheduledProgram;
    data['rosBand'] = this.rosBand;
    data['programTime'] = this.programTime;
    data['isMismatch'] = this.isMismatch;
    data['scheduledate'] = this.scheduledate;
    data['tapeDuration'] = this.tapeDuration;
    data['fpc'] = this.fpc;
    data['dur'] = this.dur;
    data['ros'] = this.ros;
    data['backColor'] = this.backColor;
    data['foreColor'] = this.foreColor;
    return data;
  }
}
