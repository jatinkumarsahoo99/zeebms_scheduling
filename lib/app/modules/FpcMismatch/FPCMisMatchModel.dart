class FPCMisMatchModel {
  bool? selectItem;
  String? date;
  String? fpcType;
  String? fpcProgram;
  String? fpcTime;
  String? starttime;
  String? endTime;
  String? tapeId;
  String? caption;
  String? bookedProgram;
  String? bookedTime;
  String? clientName;
  String? agencyname;
  String? personnelName;
  String? bookingNumber;
  String? bookingDetailcode;
  String? bookingReferenceNumber;
  String? brand;
  String? duration;
  String? er;
  dynamic isRos;
  String? dealNo;
  String? misMatch;
  String? hold;
  String? recordnumber;
  String? networkYN;
  String? bookingstatus;
  String? select;

  FPCMisMatchModel(
      {this.selectItem,
        this.date,
        this.fpcType,
        this.fpcProgram,
        this.fpcTime,
        this.starttime,
        this.endTime,
        this.tapeId,
        this.caption,
        this.bookedProgram,
        this.bookedTime,
        this.clientName,
        this.agencyname,
        this.personnelName,
        this.bookingNumber,
        this.bookingDetailcode,
        this.bookingReferenceNumber,
        this.brand,
        this.duration,
        this.er,
        this.isRos,
        this.dealNo,
        this.misMatch,
        this.hold,
        this.recordnumber,
        this.networkYN,
        this.bookingstatus});

  FPCMisMatchModel.fromJson(Map<String, dynamic> json) {
    selectItem = json['selectItem'];
    date = json['date'];
    fpcType = json['fpcType'];
    fpcProgram = json['fpcProgram'];
    fpcTime = json['fpcTime'];
    starttime = json['starttime'];
    endTime = json['endTime'];
    tapeId = json['tapeId']??json['tapeid'];
    caption = json['caption'];
    bookedProgram = json['bookedProgram'];
    bookedTime = json['bookedTime'];
    clientName = json['clientname'];
    agencyname = json['agencyname'];
    personnelName = json['personnelname'];
    bookingNumber = json['bookingNumber'];
    bookingDetailcode = json['bookingDetailcode'].toString();
    bookingReferenceNumber = json['bookingReferenceNumber'];
    brand = json['brand'];
    duration = json['duration'].toString();
    er = json['er'].toString();
    isRos = json['isRos'];
    dealNo = json['dealNo'];
    misMatch = json['misMatch'].toString();
    hold = json['hold'];
    recordnumber = json['recordnumber'].toString();
    networkYN = json['networkYN'];
    bookingstatus = json['bookingstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectItem'] = this.selectItem;
    data['date'] = this.date;
    data['fpcType'] = this.fpcType;
    data['fpcProgram'] = this.fpcProgram;
    data['fpcTime'] = this.fpcTime;
    data['starttime'] = this.starttime;
    data['endTime'] = this.endTime;
    data['tapeId'] = this.tapeId;
    data['caption'] = this.caption;
    data['bookedProgram'] = this.bookedProgram;
    data['bookedTime'] = this.bookedTime;
    data['clientName'] = this.clientName;
    data['agencyname'] = this.agencyname;
    data['personnelName'] = this.personnelName;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailcode'] = this.bookingDetailcode;
    data['bookingReferenceNumber'] = this.bookingReferenceNumber;
    data['brand'] = this.brand;
    data['duration'] = this.duration;
    data['er'] = this.er;
    data['isRos'] = this.isRos;
    data['dealNo'] = this.dealNo;
    data['misMatch'] = this.misMatch;
    data['hold'] = this.hold;
    data['recordnumber'] = this.recordnumber;
    data['networkYN'] = this.networkYN;
    data['bookingstatus'] = this.bookingstatus;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['selectItem'] = this.selectItem;
    data['select'] = "";
    data['date'] = this.date;
    data['fpcType'] = this.fpcType;
    data['fpcProgram'] = this.fpcProgram;
    data['fpcTime'] = this.fpcTime;
    data['starttime'] = this.starttime;
    data['endTime'] = this.endTime;
    data['tapeId'] = this.tapeId;
    data['caption'] = this.caption;
    data['bookedProgram'] = this.bookedProgram;
    data['bookedTime'] = this.bookedTime;
    data['clientName'] = this.clientName;
    data['agencyname'] = this.agencyname;
    data['personnelName'] = this.personnelName;
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailcode'] = this.bookingDetailcode;
    data['bookingReferenceNumber'] = this.bookingReferenceNumber;
    data['brand'] = this.brand;
    data['duration'] = this.duration;
    data['er'] = this.er;
    data['isRos'] = this.isRos;
    data['dealNo'] = this.dealNo;
    data['misMatch'] = this.misMatch;
    data['hold'] = this.hold;
    data['recordnumber'] = this.recordnumber;
    data['networkYN'] = this.networkYN;
    data['bookingstatus'] = this.bookingstatus;
    return data;
  }
  Map<String, dynamic> toMarkErrorJson(String locCode,String chanelCode) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailcode'] = this.bookingDetailcode;
    data['channelCode'] = chanelCode;
    data['locationCode'] = locCode;
    return data;
  }
  Map<String, dynamic> toSaveJson(String locCode,String chanelCode,String progCode,String scheTime) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingNumber'] = this.bookingNumber;
    data['bookingDetailcode'] = this.bookingDetailcode;
    data['hold'] = this.hold;
    data['programCode'] = progCode;
    data['scheduleTime'] = scheTime;
    data['channelCode'] = chanelCode;
    data['locationCode'] = locCode;
    return data;
  }
}
