class SalesAuditNotTRLstChannelModel {
  Generate? generate;

  SalesAuditNotTRLstChannelModel({this.generate});

  SalesAuditNotTRLstChannelModel.fromJson(Map<String, dynamic> json) {
    generate = json['generate'] != null
        ? new Generate.fromJson(json['generate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.generate != null) {
      data['generate'] = this.generate!.toJson();
    }
    return data;
  }
}



class Generate {
  List<LstnottelModel>? lstnottel;
  List<LsterrorModel>? lsterror;

  Generate({this.lstnottel, this.lsterror});

  Generate.fromJson(Map<String, dynamic> json) {
    if (json['lstnottel'] != null) {
      lstnottel = <LstnottelModel>[];
      json['lstnottel'].forEach((v) {
        lstnottel!.add(new LstnottelModel.fromJson(v));
      });
    }
    if (json['lsterror'] != null) {
      lsterror = <LsterrorModel>[];
      json['lsterror'].forEach((v) {
        lsterror!.add(new LsterrorModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstnottel != null) {
      data['lstnottel'] = this.lstnottel!.map((v) => v.toJson()).toList();
    }
    if (this.lsterror != null) {
      data['lsterror'] = this.lsterror!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class LstnottelModel {
  String? channel;
  String? location;
  String? tOnumber;
  String? bookingdetailcode;
  String? client;
  String? agency;
  String? brand;
  String? schDate;
  String? schTime;
  String? sendtolog;
  String? program;
  String? tapeID;
  String? dur;
  String? amount;
  String? bKstatus;
  String? isRos;
  String? remark;
  String? reveuve;

  LstnottelModel(
      {this.channel,
        this.location,
        this.tOnumber,
        this.bookingdetailcode,
        this.client,
        this.agency,
        this.brand,
        this.schDate,
        this.schTime,
        this.sendtolog,
        this.program,
        this.tapeID,
        this.dur,
        this.amount,
        this.bKstatus,
        this.isRos,
        this.remark,
        this.reveuve});

  LstnottelModel.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    location = json['location'];
    tOnumber = json['tOnumber'];
    bookingdetailcode = (json['bookingdetailcode']??"").toString();
    client = json['client'];
    agency = json['agency'];
    brand = json['brand'];
    schDate = json['schDate'];
    schTime = json['schTime'];
    sendtolog = json['sendtolog'];
    program = json['program'];
    tapeID = json['tapeID'];
    dur = (json['dur']??"").toString();
    amount = (json['amount']??"").toString();
    bKstatus = json['bKstatus'];
    isRos = json['isRos'];
    remark = json['remark'];
    reveuve = json['reveuve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel'] = this.channel;
    data['location'] = this.location;
    data['tOnumber'] = this.tOnumber;
    data['bookingdetailcode'] = this.bookingdetailcode;
    data['client'] = this.client;
    data['agency'] = this.agency;
    data['brand'] = this.brand;
    data['schDate'] = this.schDate;
    data['schTime'] = this.schTime;
    data['sendtolog'] = this.sendtolog;
    data['program'] = this.program;
    data['tapeID'] = this.tapeID;
    data['dur'] = this.dur;
    data['amount'] = this.amount;
    data['bKstatus'] = this.bKstatus;
    data['isRos'] = this.isRos;
    data['remark'] = this.remark;
    data['reveuve'] = this.reveuve;
    return data;
  }
}

class LsterrorModel {
  String? channel;
  String? location;
  String? tOnumber;
  String? bookingDetailCode;
  String? client;
  String? agency;
  String? brand;
  String? schDate;
  String? schTime;
  String? sendtolog;
  String? program;
  String? tapeID;
  String? dur;
  String? amount;
  String? bKstatus;
  String? ros;
  String? remark;
  String? revenue;
  String? valuationAmount;
  String? timeBand;

  LsterrorModel(
      {this.channel,
        this.location,
        this.tOnumber,
        this.bookingDetailCode,
        this.client,
        this.agency,
        this.brand,
        this.schDate,
        this.schTime,
        this.sendtolog,
        this.program,
        this.tapeID,
        this.dur,
        this.amount,
        this.bKstatus,
        this.ros,
        this.remark,
        this.revenue,
        this.valuationAmount,
        this.timeBand});

  LsterrorModel.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    location = json['location'];
    tOnumber = json['tOnumber'];
    bookingDetailCode = (json['bookingDetailCode']??"").toString();
    client = json['client'];
    agency = json['agency'];
    brand = json['brand'];
    schDate = json['schDate'];
    schTime = json['schTime'];
    sendtolog = json['sendtolog'];
    program = json['program'];
    tapeID = json['tapeID'];
    dur = (json['dur']??"").toString();
    amount =( json['amount']??"").toString();
    bKstatus = json['bKstatus'];
    ros = json['ros'];
    remark = json['remark'];
    revenue = json['revenue'];
    valuationAmount = (json['valuationAmount']??"").toString();
    timeBand = json['timeBand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel'] = this.channel;
    data['location'] = this.location;
    data['tOnumber'] = this.tOnumber;
    data['bookingDetailCode'] = this.bookingDetailCode;
    data['client'] = this.client;
    data['agency'] = this.agency;
    data['brand'] = this.brand;
    data['schDate'] = this.schDate;
    data['schTime'] = this.schTime;
    data['sendtolog'] = this.sendtolog;
    data['program'] = this.program;
    data['tapeID'] = this.tapeID;
    data['dur'] = this.dur;
    data['amount'] = this.amount;
    data['bKstatus'] = this.bKstatus;
    data['ros'] = this.ros;
    data['remark'] = this.remark;
    data['revenue'] = this.revenue;
    data['valuationAmount'] = this.valuationAmount;
    data['timeBand'] = this.timeBand;
    return data;
  }
}
