class ClientDetailsAndBrandModel {
  List<Clientdtails>? clientdtails;

  ClientDetailsAndBrandModel({this.clientdtails});

  ClientDetailsAndBrandModel.fromJson(Map<String, dynamic> json) {
    if (json['clientdtails'] != null) {
      clientdtails = <Clientdtails>[];
      json['clientdtails'].forEach((v) {
        clientdtails!.add(new Clientdtails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.clientdtails != null) {
      data['clientdtails'] = this.clientdtails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clientdtails {
  String? brandName;
  String? productName;
  String? level1Name;
  String? level2Name;
  String? level3Name;
  String? clientName;

  Clientdtails(
      {this.brandName,
        this.productName,
        this.level1Name,
        this.level2Name,
        this.level3Name,
        this.clientName});

  Clientdtails.fromJson(Map<String, dynamic> json) {
    brandName = json['brandName'];
    productName = json['productName'];
    level1Name = json['level1Name'];
    level2Name = json['level2Name'];
    level3Name = json['level3Name'];
    clientName = json['clientName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandName'] = this.brandName;
    data['productName'] = this.productName;
    data['level1Name'] = this.level1Name;
    data['level2Name'] = this.level2Name;
    data['level3Name'] = this.level3Name;
    data['clientName'] = this.clientName;
    return data;
  }
}