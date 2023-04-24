class DropDownValue {
  String? value;

  String? key;

  DropDownValue({this.value, this.key});

  DropDownValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    key = json['key'];
  }

  DropDownValue.fromJson1(Map<String, dynamic> json) {
    value = json['locationName'];
    key = json['locationCode'];
  }

  DropDownValue.fromJsonDynamic(
      Map<String, dynamic> json, String key, String name) {
    value = json[name];
    key = json[key];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['key'] = key;
    return data;
  }
}
