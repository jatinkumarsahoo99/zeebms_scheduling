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
    programName = json['programName'] ?? json['programname'];
    programCode = json['programCode'] ?? json['programcode'];
    telecasttime = json['telecasttime'];
    tapeId = json['tapeId'];
    segmentnumber = json['segmentnumber'] is String
        ? (json['segmentnumber'].toString().isEmpty
            ? null
            : int.tryParse(json['segmentnumber']))
        : json['segmentnumber'];
    caption = json['caption'];
    telecastDuration = json['telecastDuration'];
    vtr = json['vtr'];
    ch = json['ch'];
    eventtype = json['eventtype'];
    bookingnumber = json['bookingnumber'];
    bookingdetailcode = json['bookingdetailcode'] is String
        ? int.tryParse(json['bookingdetailcode'])
        : json['bookingdetailcode'];
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

  Map<String, dynamic> toJson({isSegInt = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventNumber'] = eventNumber;
    data['telecastdate'] = telecastdate;
    data['fpctIme'] = fpctIme;
    data['programName'] = programName;
    data['programCode'] = programCode;
    data['telecasttime'] = telecasttime;
    data['tapeId'] = tapeId;
    data['segmentnumber'] = isSegInt ? segmentnumber : segmentnumber.toString();
    data['caption'] = caption;
    data['telecastDuration'] = telecastDuration;
    data['vtr'] = vtr;
    data['ch'] = ch;
    data['eventtype'] = eventtype;
    data['bookingnumber'] = bookingnumber;
    data['bookingdetailcode'] =
        isSegInt ? bookingdetailcode : bookingdetailcode.toString();
    data['scheduletime'] = scheduletime;
    data['scheduledProgram'] = scheduledProgram;
    data['rosBand'] = rosBand;
    data['programTime'] = programTime;
    data['isMismatch'] = isMismatch;
    data['scheduledate'] = scheduledate;
    data['tapeDuration'] = tapeDuration;
    data['fpc'] = fpc;
    data['dur'] = dur;
    data['ros'] = ros;
    data['backColor'] = backColor;
    data['foreColor'] = foreColor;
    return data;
  }
}
