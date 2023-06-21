class ChannelListModel{
  String? channelCode;
  String? channelName;
  bool? ischecked = false;
  ChannelListModel({this.channelCode,this.channelName,this.ischecked});

  ChannelListModel.fromJson(Map<String, dynamic> json) {
    channelCode = json['channelCode'];
    channelName = json['channelName'];
    ischecked = json['ischecked']??false;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelCode'] = this.channelCode;
    data['channelName'] = this.channelName;
    data['ischecked'] = this.ischecked??false;


    return data;

  }
}