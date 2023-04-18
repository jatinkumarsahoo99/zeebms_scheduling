class TokenData {
  String? tokenType;
  String? scope;
  int? expiresIn;
  int? extExpiresIn;
  String? accessToken;
  String? refreshToken;
  String? idToken;

  TokenData(
      {this.tokenType,
        this.scope,
        this.expiresIn,
        this.extExpiresIn,
        this.accessToken,
        this.refreshToken,
        this.idToken});

  TokenData.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    scope = json['scope'];
    expiresIn = json['expires_in'];
    extExpiresIn = json['ext_expires_in'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    idToken = json['id_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = this.tokenType;
    data['scope'] = this.scope;
    data['expires_in'] = this.expiresIn;
    data['ext_expires_in'] = this.extExpiresIn;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['id_token'] = this.idToken;
    return data;
  }
}
