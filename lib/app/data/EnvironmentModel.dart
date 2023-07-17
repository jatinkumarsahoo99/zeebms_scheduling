class EnvironmentModel {
  String? appLoginUrl;
  String? apiLoginUrl;
  String? appCommonUrl;
  String? apiCommonUrl;
  String? appAdminUrl;
  String? apiAdminUrl;
  String? appProgrammingUrl;
  String? apiProgrammingUrl;
  String? appSchedulingUrl;
  String? apiSchedulingUrl;
  String? appClientId;
  String? appTenantId;
  String? appInsrtumentationKey;

  EnvironmentModel(
      {this.appLoginUrl,
        this.apiLoginUrl,
        this.appCommonUrl,
        this.apiCommonUrl,
        this.appAdminUrl,
        this.apiAdminUrl,
        this.appProgrammingUrl,
        this.apiProgrammingUrl,
        this.appSchedulingUrl,
        this.apiSchedulingUrl,
        this.appClientId,
        this.appTenantId,
        this.appInsrtumentationKey});

  EnvironmentModel.fromJson(Map<String, dynamic> json) {
    appLoginUrl = json['app-login-url'];
    apiLoginUrl = json['api-login-url'];
    appCommonUrl = json['app-common-url'];
    apiCommonUrl = json['api-common-url'];
    appAdminUrl = json['app-admin-url'];
    apiAdminUrl = json['api-admin-url'];
    appProgrammingUrl = json['app-programming-url'];
    apiProgrammingUrl = json['api-programming-url'];
    appSchedulingUrl = json['app-scheduling-url'];
    apiSchedulingUrl = json['api-scheduling-url'];
    appClientId = json['app-client-id'];
    appTenantId = json['app-tenant-id'];
    appInsrtumentationKey = json['app-insrtumentation-key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app-login-url'] = this.appLoginUrl;
    data['api-login-url'] = this.apiLoginUrl;
    data['app-common-url'] = this.appCommonUrl;
    data['api-common-url'] = this.apiCommonUrl;
    data['app-admin-url'] = this.appAdminUrl;
    data['api-admin-url'] = this.apiAdminUrl;
    data['app-programming-url'] = this.appProgrammingUrl;
    data['api-programming-url'] = this.apiProgrammingUrl;
    data['app-scheduling-url'] = this.appSchedulingUrl;
    data['api-scheduling-url'] = this.apiSchedulingUrl;
    data['app-client-id'] = this.appClientId;
    data['app-tenant-id'] = this.appTenantId;
    data['app-insrtumentation-key'] = this.appInsrtumentationKey;
    return data;
  }
}
