class LogAdditionModel {
  DisplayPreviousAdditon? displayPreviousAdditon;


  LogAdditionModel({this.displayPreviousAdditon});

  LogAdditionModel.fromJson(Map<String, dynamic> json) {
    if (json['displayPreviousAdditon'] != null) {
      displayPreviousAdditon =
          new DisplayPreviousAdditon.fromJson(json['displayPreviousAdditon']);
    }
    if (json['lstnewAdditions'] != null) {
      displayPreviousAdditon =
          new DisplayPreviousAdditon.fromJson(json['lstnewAdditions']);
    }


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.displayPreviousAdditon != null) {
      data['displayPreviousAdditon'] = this.displayPreviousAdditon!.toJson();
    }
    return data;
  }
}

class DisplayPreviousAdditon {
  List<PreviousAdditons>? previousAdditons;
  String? remarks;
  String? additionCount;
  String? cancellationCount;
  DisplayPreviousAdditon({this.previousAdditons, this.remarks});

  DisplayPreviousAdditon.fromJson(Map<String, dynamic> json) {
    if (json['previousAdditons'] != null) {
      previousAdditons = <PreviousAdditons>[];
      json['previousAdditons'].forEach((v) {
        previousAdditons!.add(new PreviousAdditons.fromJson(v));
      });
    }
    if (json['lstnewadditions'] != null) {
      previousAdditons = <PreviousAdditons>[];
      json['lstnewadditions'].forEach((v) {
        previousAdditons!.add(new PreviousAdditons.fromJson(v));
      });
    }
    remarks = json['remarks'];
    additionCount = json['additionCount'];
    cancellationCount = json['cancellationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.previousAdditons != null) {
      data['previousAdditons'] =
          this.previousAdditons!.map((v) => v.toJson()).toList();
    }
    data['remarks'] = this.remarks;
    return data;
  }
}

class PreviousAdditons {
  String? action;
  String? tonumber;
  String? exportTapeCaption;
  String? duration;
  String? spotPositionShortName;
  String? exportTapeCode;
  String? scheduletime;
  String? programName;
  int? breakNumber;
  String? col10;
  int? bookingdetailcode;
  String? segmentNumber;
  String? rOsTime;
  String? clientName;
  String? productName;
  int? bookingdetailcode1;
  String? approxTXtime;

  PreviousAdditons(
      {this.action,
      this.tonumber,
      this.exportTapeCaption,
      this.duration,
      this.spotPositionShortName,
      this.exportTapeCode,
      this.scheduletime,
      this.programName,
      this.breakNumber,
      this.col10,
      this.bookingdetailcode,
      this.segmentNumber,
      this.rOsTime,
      this.clientName,
      this.productName,
      this.bookingdetailcode1,
      this.approxTXtime});

  PreviousAdditons.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    tonumber = json['tonumber'];
    exportTapeCaption = json['exportTapeCaption'];
    duration = json['duration']!=null? (json['duration'] is int?json['duration'].toString():json["duration"]):"";
    spotPositionShortName = json['spotPositionShortName'];
    exportTapeCode = json['exportTapeCode'];
    scheduletime = json['scheduletime'];
    programName = json['programName'];
    breakNumber = json['breakNumber'];
    col10 = json['col10'];
    bookingdetailcode = json['bookingdetailcode'];
    segmentNumber = json['segmentNumber'].toString();
    rOsTime = json['rOsTime'];
    clientName = json['clientName'];
    productName = json['productName'];
    bookingdetailcode1 = json['bookingdetailcode1'];
    approxTXtime = json['approxTXtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['tonumber'] = this.tonumber;
    data['exportTapeCaption'] = this.exportTapeCaption;
    // data['duration'] = num.tryParse(this.duration ?? "0");
    data['duration'] = this.duration;
    data['spotPositionShortName'] = this.spotPositionShortName;
    data['ExportTapeCode'] = this.exportTapeCode;
    data['Scheduletime'] = this.scheduletime;
    data['programName'] = this.programName;
    data['breakNumber'] = this.breakNumber;
    data['col10'] = this.col10;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['Segment No'] = num.tryParse(this.segmentNumber ?? "");
    data['rOsTime'] = this.rOsTime;
    data['clientName'] = this.clientName;
    data['productName'] = this.productName;
    data['Bookingdetailcode1'] = this.bookingdetailcode1;
    data['approxTXtime'] = this.approxTXtime;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['tonumber'] = this.tonumber;
    data['exportTapeCaption'] = this.exportTapeCaption;
    data['duration'] = num.tryParse(this.duration ?? "0");
    data['spotPositionShortName'] = this.spotPositionShortName;
    data['exportTapeCode'] = this.exportTapeCode;
    data['scheduletime'] = this.scheduletime;
    data['programName'] = this.programName;
    data['breakNumber'] = this.breakNumber;
    data['col10'] = this.col10;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['segmentNumber'] = num.tryParse(this.segmentNumber ?? "");
    data['rOsTime'] = this.rOsTime;
    data['clientName'] = this.clientName;
    data['productName'] = this.productName;
    data['bookingdetailcode1'] = this.bookingdetailcode1;
    data['approxTXtime'] = this.approxTXtime;
    return data;
  }
}
