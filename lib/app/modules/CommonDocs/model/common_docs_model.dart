class CommonDocsModel {
  int? documentId;
  String? documentName;
  String? uploadedBy;
  String? upLoadedDate;

  CommonDocsModel({this.documentId, this.documentName, this.uploadedBy, this.upLoadedDate});

  CommonDocsModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    documentName = json['documentName'];
    uploadedBy = json['uploadedBy'];
    upLoadedDate = json['upLoadedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['documentName'] = this.documentName;
    data['uploadedBy'] = this.uploadedBy;
    data['uploadedDate'] = this.upLoadedDate;
    return data;
  }
}
