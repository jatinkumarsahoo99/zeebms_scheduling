// ignore_for_file: non_constant_identifier_names

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
  static String Enviroment =
      const String.fromEnvironment('ENV', defaultValue: 'dev');

  // static String SERVER_URL = "https://bmswebfrontend-uat.azurewebsites.net";
  static String WEB_URL = Enviroment.toLowerCase() == "uat"
      ? "https://app-scheduling-bms-uat.zeeconnect.in"
      : "https://app-scheduling-bms-dev.zeeconnect.in";
  static String WEB_URL_COMMON = Enviroment.toLowerCase() == "uat"
      ? "https://app-common-bms-uat.zeeconnect.in"
      : "https://app-common-bms-dev.zeeconnect.in";

  static String BASE_URL = Enviroment.toLowerCase() == "uat"
      ? "https://api-scheduling-bms-uat.zeeconnect.in"
      : "https://api-scheduling-bms-dev.zeeconnect.in";
  static String BASE_URL_COMMON = Enviroment.toLowerCase() == "uat"
      ? "https://api-common-bms-uat.zeeconnect.in"
      : "https://api-common-bms-dev.zeeconnect.in";
  static String BASE_URL_LOGIN = Enviroment.toLowerCase() == "uat"
      ? "https://api-login-bms-uat.zeeconnect.in"
      : "https://api-login-bms-dev.zeeconnect.in";

  // api-login-bms-dev.zeeconnect.in
  // api-common-bms-dev.zeeconnect.in
  // api-programming-bms-dev.zeeconnect.in

  static String AZURE_REDIRECT_UI =
      "${kReleaseMode ? WEB_URL : LOCAL_URL}/dashboard";
  static String NOTIFY_URL = (kReleaseMode ? WEB_URL_COMMON : LOCAL_URL);
  static String SPLIT_CLEAR_PAGE = (kReleaseMode ? "in/" : "92/");

  static String MS_TOKEN =
      "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/token";

  static String LOGIN_API = "$BASE_URL_LOGIN/api/Login/GetLogin?";
  static String LOGOUT_API = "$BASE_URL_LOGIN/api/Login/GetLogout?PersonnelNo=";
  static String USER_INFO = "$BASE_URL_LOGIN/api/Login/GetUserinfo";
  static String PERMISSION_API =
      "$BASE_URL_COMMON/api/MDI/GetAllFormDetailsAndPermission?Userid=";
  static String MS_PROFILE = "$BASE_URL_LOGIN/api/Login/PostUserProfile";
  static String MS_TOKEN_BACKEND = "$BASE_URL_LOGIN/api/Login/PostApiToken";

  static String MS_TOKEN1 =
      "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/v2.0/token";
  static String MS_AUTH =
      "https://login.microsoftonline.com/56bd48cd-f312-49e8-b6c7-7b5b926c03d6/oauth2/v2.0/token";

  // static String MS_GRAPH_USER_DETAILS = "https://graph.microsoft.com/v1.0/me?\$select=employeeId,mail,givenName";
  static String MS_GRAPH_USER_DETAILS =
      "https://graph.microsoft.com/v1.0/me?\$select=employeeId,mail,givenName,jobTitle,givenName,id,mobilePhone,displayName";
  static String MS_LOGOUT =
      "https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri=";

  /*static String PERMISSION_API =
      BASE_URL + "/api/MDI/GetAllFormDetailsAndPermission?Userid=";
*/
///////////////////////XML Download API////////////////////////
  static String EXPORT_TO_XML = "$BASE_URL_COMMON/api/Common/ConvertTableToXml";
  static String OPERATIONAL_FPC_PROGRAM_SEARCH =
      "$BASE_URL/api/DailyFPCReport/ProgramSearch?SearchText=";
  static String MOVIE_PLANNER_GET_LOCATIONS =
      BASE_URL + "/api/MoviePlanner/GetSchedulerLoadLocation";

  static String MOVIE_PLANNER_GET_DATA_ON_LOCATION_SELECT(
      {required location, required userId}) {
    return BASE_URL +
        '/api/MoviePlanner/GetLocationSelect?Locationcode=$location&logincode=$userId';
  }

  //////////////////// FPC MISMATCH - UI: Sanjaya Jena API: PATTA NIGAM ////////////////
  static String FPC_MISMATCH_LOCATION =
      BASE_URL + "/api/FpcMismatch/GetLocations";

  static String FPC_MISMATCH_CHANNEL(String userId, String locCode) =>
      BASE_URL + "/api/FpcMismatch/GetChannelMaster?locationCode=$locCode";

  static String FPC_MISMATCH(String location, String channelCode, String dt) =>
      // BASE_URL + "/api/FpcMismatch/BindFPCMismatchGrid/$location,$channelCode,$dt";
      BASE_URL +
      "/api/FpcMismatch/BindFPCMismatchGrid?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_ERROR(
          String location, String channelCode, String dt) =>
      BASE_URL +
      // "/api/FpcMismatch/BindFPCMismatchGridError/$location,$channelCode,$dt";
      "/api/FpcMismatch/BindFPCMismatchGridError?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_ALL(
          String location, String channelCode, String dt) =>
      BASE_URL +
      // "/api/FpcMismatch/BindFPCMismatchGridAll/$location,$channelCode,$dt";
      "/api/FpcMismatch/BindFPCMismatchGridAll?LocationCode=$location&ChannelCode=$channelCode&EffectiveDate=$dt";

  static String FPC_MISMATCH_PROGRAM(
          String location, String channelCode, String dt) =>
      // BASE_URL + "/api/FpcMismatch/BindWebFPCGrid/$location,$channelCode,$dt";
      BASE_URL +
      "/api/FpcMismatch/BindWebFPCGrid?LocationCode=$location&ChannelCode=$channelCode&TelecastDate=$dt";

  static String FPC_MISMATCH_MARK_ERROR =
      BASE_URL + "/api/FpcMismatch/UpdateRecordError";

  static String FPC_MISMATCH_MARK_UNDO_ERROR =
      BASE_URL + "/api/FpcMismatch/UpdateUndoError";

  static String FPC_MISMATCH_SAVE = BASE_URL + "/api/FpcMismatch/UpdateRecord";

/////////////////////////////////////////////////////////////////////////////////////////

//////////////// Import Digitex Run Order: UI:SHOEB SHAIKH, API: INDRESH ///////////////

  static String IMPORT_DIGITEX_RUN_ORDER_LOCATION =
      "$BASE_URL/api/ImportDigitexRunOrder/GetLocations";
  static String IMPORT_DIGITEX_RUN_ORDER_CHANNEL(locationCode) =>
      "$BASE_URL/api/ImportDigitexRunOrder/GetChannels/$locationCode";
  static String IMPORT_DIGITEX_RUN_ORDER_AGENCY =
      "$BASE_URL/api/ImportDigitexRunOrder/GetAgencyMasters/Sky/";
  static String IMPORT_DIGITEX_RUN_ORDER_CLIENT =
      "$BASE_URL/api/ImportDigitexRunOrder/GetClientMasters/";
  static String IMPORT_DIGITEX_RUN_ORDER_MAP_CLIENT =
      "$BASE_URL/api/ImportDigitexRunOrder/SaveMissingClientMaster";
  static String IMPORT_DIGITEX_RUN_ORDER_MAP_AGENCY =
      "$BASE_URL/api/ImportDigitexRunOrder/SaveMissingAgencyMaster";

  static String IMPORT_DIGITEX_RUN_ORDER_IMPORT(locationCode, channelCode) =>
      "$BASE_URL/api/ImportDigitexRunOrder/LoadDigitexRunOrder?LocationCode=$locationCode&ChannelCode=$channelCode";
  static String IMPORT_DIGITEX_RUN_ORDER_SAVE(
          locationCode, channelCode, date) =>
      "$BASE_URL/api/ImportDigitexRunOrder/SaveRunOrder?LocationCode=$locationCode&ChannelCode=$channelCode&BookingDate=$date";

//////////////// Filler: UI:VISHAL GORE, API: INDRESH ///////////////

  static String FILLER_LOCATION =
      "$BASE_URL/api/FillerScheduling/GetLocations";

  static String FILLER_CHANNEL(locationCode) =>
      "$BASE_URL/api/FillerScheduling/GetChannels/$locationCode";

  static String FILLER_CAPTION =
      "$BASE_URL/api/FillerScheduling/GetFillerCaption/";

  /// to Search Caption in dropdown
  static String FILLER_VALUE_BY_CAPTION(fillerCaption) =>
      "$BASE_URL/api/FillerScheduling/GetFillerCaption/$fillerCaption";

  static String FILLER_VALUES_BY_FILLER_CODE(fillerCode) =>
      "$BASE_URL/api/FillerScheduling/GetFillerValuesByFillerCode/$fillerCode";

  static String FILLER_VALUES_BY_TAPE_CODE(tapeCode) =>
      "$BASE_URL/api/FillerScheduling/GetFillerValuesByTapeCode/$tapeCode";

  static String FPC_DETAILS(
      locationCode, channelCode, date) =>
      //"$BASE_URL/api/FillerScheduling/GetFpcDetails/$locationCode/$channelCode/$date";
      //"$BASE_URL/api/FillerScheduling/GetFpcDetails/ZAZEE00001/ZAMUS00004/01-01-2023";
      //"$BASE_URL/api/FillerScheduling/GetFpcDetails?LocationCode=ZAZEE00001&ChannelCode=ZAMUS00004&TelecastDate=4-3-2023";
      "$BASE_URL/api/FillerScheduling/GetFpcDetails?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date";

  static String SEGMENT_DETAILS(
      programCode, exportTapeCode, episodeNumber, originalRepeatCode, locationCode, channelCode, startTime, date) =>
      "$BASE_URL/api/FillerScheduling/GetSegmentDetails?ProgramCode=$programCode&ExportTapeCode=$exportTapeCode&EpisodeNumber=$episodeNumber&OriginalRepeatCode=$originalRepeatCode&LocationCode=$locationCode&ChannelCode=$channelCode&StartTime=$startTime&StartDate=$date";
      //"$BASE_URL/api/FillerScheduling/GetSegmentDetails?ProgramCode=ZAZIN02069&ExportTapeCode=ZNG3160&EpisodeNumber=145&OriginalRepeatCode=ZAORI00001&LocationCode=ZAZEE00001&ChannelCode=ZAMUS00004&StartTime=01%3A00%3A00%3A00&StartDate=4%2F3%2F2023";

}
