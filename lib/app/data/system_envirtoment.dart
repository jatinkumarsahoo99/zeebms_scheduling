class SystemEnviroment {
  String? value;
  String? url;
  String? standardMeasure;
  String? key;
  bool? selected = false;

  SystemEnviroment({this.value, this.url, this.key, this.standardMeasure});

  SystemEnviroment.fromJson(Map<String, dynamic> json) {
    value = json['name'];
    url = json['url'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = value;
    data['url'] = url;
    data['standardMeasure'] = standardMeasure;
    data['key'] = key;
    return data;
  }
  Map<String, dynamic> toProgramMaster() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['Sl No'] = url;
    data['Program Name'] = value;
    return data;
  }

  Map<String, dynamic> toLangJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = key;
    data['language'] = value;
    return data;
  }

  Map<String, dynamic> toTapeJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Programtypecode'] = key;
    data['Programtypename'] = value;
    return data;
  }

  @override
  String toString() {
    return 'SystemEnviroment{value: $value, key: $key}';
  }
}
