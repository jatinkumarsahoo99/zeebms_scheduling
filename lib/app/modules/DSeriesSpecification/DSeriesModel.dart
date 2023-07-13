class DSeriesModel {
  List<Search>? search;

  DSeriesModel({this.search});

  DSeriesModel.fromJson(Map<String, dynamic> json) {
    if (json['search'] != null) {
      search = <Search>[];
      json['search'].forEach((v) {
        search!.add(new Search.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.search != null) {
      data['search'] = this.search!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Search {
  String? eventType;
  bool? isLastSegment;
  int? startPosition;
  int? endPosition;
  String? dataValue;
  String? description;

  Search(
      {this.eventType,
        this.isLastSegment,
        this.startPosition,
        this.endPosition,
        this.dataValue,
        this.description});

  Search.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    isLastSegment = json['isLastSegment'];
    startPosition = json['startPosition'];
    endPosition = json['endPosition'];
    dataValue = json['dataValue'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = this.eventType;
    data['isLastSegment'] = this.isLastSegment;
    data['startPosition'] = this.startPosition;
    data['endPosition'] = this.endPosition;
    data['dataValue'] = this.dataValue;
    data['description'] = this.description;
    return data;
  }
}
