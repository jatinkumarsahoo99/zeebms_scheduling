class DropDownValue {
  String? value;

  String? key;

  DropDownValue({this.value, this.key});

  DropDownValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];

    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;

    data['key'] = key;
    return data;
  }
}
