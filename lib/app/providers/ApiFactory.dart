// ignore_for_file: non_constant_identifier_names

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// import '../modules/OperationalFPC/DailyFPCModel.dart';

class ApiFactory {
  // Developing R & D URLS
  // https://web-bms-qa.azurewebsites.net/
  // https://api-bms-qa.azurewebsites.net/

  //RELEASE WORK URLS
  //https://bmswebfrontend-uat.azurewebsites.net
  //https://api-bms-dev.azurewebsites.net

  ////AKS
  // http://bms-api-common.bms-api-ns.svc.cluster.local/weatherforecast
  // http://bms-api-programming.bms-api-ns.svc.cluster.local/weatherforecast
  // http://bms-api-login.bms-api-ns.svc.cluster.local/weatherforecast

  static String userId = "";
  static String LOCAL_URL = "http://localhost:9999";
  static String Enviroment = const String.fromEnvironment('ENV', defaultValue: 'dev');

  // static String SERVER_URL = "https://bmswebfrontend-uat.azurewebsites.net";
  static String WEB_URL = Enviroment.toLowerCase() == "uat" ? "https://app-admin-bms-uat.zeeconnect.in" : "https://app-admin-bms-dev.zeeconnect.in";
  static String WEB_URL_COMMON =
      Enviroment.toLowerCase() == "uat" ? "https://app-common-bms-uat.zeeconnect.in" : "https://app-common-bms-dev.zeeconnect.in";

  static String BASE_URL =
      Enviroment.toLowerCase() == "uat" ? "https://api-scheduling-bms-uat.zeeconnect.in" : "https://api-scheduling-bms-dev.zeeconnect.in";

  static String BASE_URL_COMMON =
      Enviroment.toLowerCase() == "uat" ? "https://api-common-bms-uat.zeeconnect.in" : "https://api-common-bms-dev.zeeconnect.in";
  static String BASE_URL_LOGIN =
      Enviroment.toLowerCase() == "uat" ? "https://api-login-bms-uat.zeeconnect.in" : "https://api-login-bms-dev.zeeconnect.in";

  // api-login-bms-dev.zeeconnect.in
  // api-common-bms-dev.zeeconnect.in
  // api-programming-bms-dev.zeeconnect.in

  static String AZURE_REDIRECT_UI = "${kReleaseMode ? WEB_URL : LOCAL_URL}/dashboard";
  static String NOTIFY_URL = (kReleaseMode ? WEB_URL_COMMON : LOCAL_URL);
  static String SPLIT_CLEAR_PAGE = (kReleaseMode ? "in/" : "92/");

  static String MS_TOKEN = "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/token";

  static String LOGIN_API = "$BASE_URL_LOGIN/api/Login/GetLogin?";
  static String LOGOUT_API = "$BASE_URL_LOGIN/api/Login/GetLogout?PersonnelNo=";
  static String USER_INFO = "$BASE_URL_LOGIN/api/Login/GetUserinfo";
  static String PERMISSION_API = "$BASE_URL_COMMON/api/MDI/GetAllFormDetailsAndPermission?Userid=";
  static String MS_PROFILE = "$BASE_URL_LOGIN/api/Login/PostUserProfile";
  static String MS_TOKEN_BACKEND = "$BASE_URL_LOGIN/api/Login/PostApiToken";

  static String MS_TOKEN1 = "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/v2.0/token";
  static String MS_AUTH = "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/v2.0/token";

  // static String MS_GRAPH_USER_DETAILS = "https://graph.microsoft.com/v1.0/me?\$select=employeeId,mail,givenName";
  static String MS_GRAPH_USER_DETAILS =
      "https://graph.microsoft.com/v1.0/me?\$select=employeeId,mail,givenName,jobTitle,givenName,id,mobilePhone,displayName";
  static String MS_LOGOUT = "https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri=";

  /*static String PERMISSION_API =
      BASE_URL + "/api/MDI/GetAllFormDetailsAndPermission?Userid=";
*/
///////////////////////XML Download API////////////////////////
  static String EXPORT_TO_XML = "$BASE_URL_COMMON/api/Common/ConvertTableToXml";
  static String OPERATIONAL_FPC_PROGRAM_SEARCH = "$BASE_URL/api/DailyFPCReport/ProgramSearch?SearchText=";
  static String MOVIE_PLANNER_GET_LOCATIONS = BASE_URL + "/api/MoviePlanner/GetSchedulerLoadLocation";

  static String MOVIE_PLANNER_GET_DATA_ON_LOCATION_SELECT({required location, required userId}) {
    return BASE_URL + '/api/MoviePlanner/GetLocationSelect?Locationcode=$location&logincode=$userId';
  }

  //////////////////// FPC MISMATCH - UI: Sanjaya Jena API: PATTA NIGAM ////////////////
  static String FPC_MISMATCH_LOCATION = BASE_URL + "/api/FpcMismatch/GetLocations";

  static String FPC_MISMATCH_CHANNEL(String userId, String locCode) => BASE_URL + "/api/FpcMismatch/GetChannelMaster/$locCode";

  static String FPC_MISMATCH(String location, String channelCode, String dt) =>
      // BASE_URL + "/api/FpcMismatch/BindFPCMismatchGrid/$location,$channelCode,$dt";
      BASE_URL + "/api/FpcMismatch/BindFPCMismatchGrid?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_ERROR(String location, String channelCode, String dt) =>
      BASE_URL +
      // "/api/FpcMismatch/BindFPCMismatchGridError/$location,$channelCode,$dt";
      "/api/FpcMismatch/BindFPCMismatchGridError?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_ALL(String location, String channelCode, String dt) =>
      BASE_URL +
      // "/api/FpcMismatch/BindFPCMismatchGridAll/$location,$channelCode,$dt";
      "/api/FpcMismatch/BindFPCMismatchGridAll?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_PROGRAM(String location, String channelCode, String dt) =>
      // BASE_URL + "/api/FpcMismatch/BindWebFPCGrid/$location,$channelCode,$dt";
      BASE_URL + "/api/FpcMismatch/BindWebFPCGrid?LocationCode=$location&ChannelCode=$channelCode&TelecastDate=$dt";

  static String FPC_MISMATCH_MARK_ERROR = BASE_URL + "/api/FpcMismatch/UpdateRecordError";

  static String FPC_MISMATCH_MARK_UNDO_ERROR = BASE_URL + "/api/FpcMismatch/UpdateUndoError";

  static String FPC_MISMATCH_SAVE = BASE_URL + "/api/FpcMismatch/UpdateRecord";

/////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////Log Additions API: Deven UI: Sanjaya///////////////////////////////////////////////
  static String LOG_ADDITION_LOCATION = BASE_URL + "/api/Additions/GetLoadLocation";
  static String LOG_ADDITION_CHANNEL = BASE_URL + "/api/Additions/GetLocationSelect?Locationcode=";

  static String LOG_ADDITION_PREVIOUS_ADDITION(
    String locName,
    String chnlName,
    String date,
    String aditionNo,
  ) =>
      BASE_URL + "/api/Additions/GetDisplayPreviousAdditon?locationName=$locName&channelName=$chnlName&Date=$date&additionnumber=$aditionNo";

  static String LOG_ADDITION_SHOW_DETAILS(
          DropDownValue locDetail, DropDownValue chnlDetails, String date, bool isPrimary, bool checkStandBy, bool checkIgnore) =>
      BASE_URL +
      "/api/Additions/GetShowDetails?Locationcode=${locDetail.key}&locationName=${locDetail.value}&channelcode=${chnlDetails.key}&channelName=${chnlDetails.value}&logdate=$date&optPrimary=$isPrimary&chkStandby=$checkStandBy&chkIgnore=$checkIgnore";

  static String LOG_ADDITION_GET_ADDITIONS(DropDownValue locDetail, DropDownValue chnlDetails, String date) =>
      BASE_URL + "/api/Additions/GetPopulateAdditions?Locationcode=${locDetail.key}&channelcode=${chnlDetails.key}&Date=$date";
  static String LOG_ADDITION_SAVE_ADDITION() => BASE_URL + "/api/Additions/PostAddition";

//////////////// Import Digitex Run Order: UI:SHOEB SHAIKH, API: INDRESH ///////////////

  static String IMPORT_DIGITEX_RUN_ORDER_LOCATION = "$BASE_URL/api/ImportDigitexRunOrder/GetLocations";
  static String IMPORT_DIGITEX_RUN_ORDER_CHANNEL(locationCode) => "$BASE_URL/api/ImportDigitexRunOrder/GetChannels/$locationCode";
  static String IMPORT_DIGITEX_RUN_ORDER_AGENCY = "$BASE_URL/api/ImportDigitexRunOrder/GetAgencyMasters/Sky/";
  static String IMPORT_DIGITEX_RUN_ORDER_CLIENT = "$BASE_URL/api/ImportDigitexRunOrder/GetClientMasters/";
  static String IMPORT_DIGITEX_RUN_ORDER_MAP_CLIENT = "$BASE_URL/api/ImportDigitexRunOrder/SaveMissingClientMaster";
  static String IMPORT_DIGITEX_RUN_ORDER_MAP_AGENCY = "$BASE_URL/api/ImportDigitexRunOrder/SaveMissingAgencyMaster";

  static String IMPORT_DIGITEX_RUN_ORDER_IMPORT(locationCode, channelCode) =>
      "$BASE_URL/api/ImportDigitexRunOrder/LoadDigitexRunOrder?LocationCode=$locationCode&ChannelCode=$channelCode";
  static String IMPORT_DIGITEX_RUN_ORDER_SAVE(locationCode, channelCode, date) =>
      "$BASE_URL/api/ImportDigitexRunOrder/SaveRunOrder?LocationCode=$locationCode&ChannelCode=$channelCode&BookingDate=$date";

  ////////////////////////////// MAM WORK ORDERS API START////////////////////////////////////////////////
  static String get MAM_WORK_ORDER_INITIALIZE => "$BASE_URL/api/MAMWorkOrder/OnLoadWorkOrder";

  static String MAM_WORK_ORDER_NON_FPC_LOCATION_LEAVE(String? locationCode) {
    return "$BASE_URL/api/MAMWorkOrder/OnLeaveLocation${(locationCode == null || locationCode.isEmpty) ? '' : '?LocationCode=$locationCode'}";
  }

  static String get MAM_WORK_ORDER_NON_FPC_BMS_SEARCH => "$BASE_URL/api/MAMWorkOrder/OnLoadBMSProgram?Search=";

  static String get MAM_WORK_ORDER_NON_FPC_RMS_SEARCH => "$BASE_URL/api/MAMWorkOrder/OnLoadcboProgram?Search=";

  static String get MAM_WORK_ORDER_NON_FPC_GET_DATA => "$BASE_URL/api/MAMWorkOrder/OnLeaveProgram";

  ////////////////////////////// MAM WORK ORDERS API END////////////////////////////////////////////////
}
