class MovieSearchModel {
  List<Moviesearch>? moviesearch;

  MovieSearchModel({this.moviesearch});

  MovieSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['moviesearch'] != null) {
      moviesearch = <Moviesearch>[];
      json['moviesearch'].forEach((v) {
        moviesearch!.add(new Moviesearch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.moviesearch != null) {
      data['moviesearch'] = this.moviesearch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Moviesearch {
  String? programDescription;
  String? programDescriptionid;

  Moviesearch({this.programDescription, this.programDescriptionid});

  Moviesearch.fromJson(Map<String, dynamic> json) {
    programDescription = json['programDescription'];
    programDescriptionid = json['programDescriptionid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programDescription'] = this.programDescription;
    data['programDescriptionid'] = this.programDescriptionid;
    return data;
  }
}
