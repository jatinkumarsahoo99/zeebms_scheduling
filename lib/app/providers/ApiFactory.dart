// ignore_for_file: non_constant_identifier_names

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'Const.dart';

// import '../modules/OperationalFPC/DailyFPCModel.dart';

class ApiFactory {
  static String userId = "";
  static String LOCAL_URL = "http://localhost:9999";
  static String Enviroment =
      const String.fromEnvironment('ENV', defaultValue: 'dev');

  /* static String WEB_URL = Enviroment.toLowerCase() == "uat"
      ? "https://app-admin-bms-uat.zeeconnect.in"
      : "https://app-admin-bms-dev.zeeconnect.in";
  static String WEB_URL_COMMON = Enviroment.toLowerCase() == "uat"
      ? "https://app-common-bms-uat.zeeconnect.in"
      : "https://app-common-bms-dev.zeeconnect.in";

  static String BASE_URL =
      Enviroment.toLowerCase() == "uat" ? "https://api-scheduling-bms-uat.zeeconnect.in" : "https://api-scheduling-bms-dev.zeeconnect.in";

  static String BASE_URL_COMMON = Enviroment.toLowerCase() == "uat"
      ? "https://api-common-bms-uat.zeeconnect.in"
      : "https://api-common-bms-dev.zeeconnect.in";
  static String BASE_URL_LOGIN = Enviroment.toLowerCase() == "uat"
      ? "https://api-login-bms-uat.zeeconnect.in"
      : "https://api-login-bms-dev.zeeconnect.in";*/

  static String WEB_URL = Const.getWebAdminUrl();
  static String WEB_URL_COMMON = Const.getWebCommonUrl();
  static String LOGIN_URL = Const.getWebLoginUrl();

  static String BASE_URL = Const.getBaseSchedulingAPIUrl();

  static String BASE_URL_COMMON = Const.getBaseCommonAPIUrl();
  static String BASE_URL_LOGIN = Const.getBaseLoginAPIUrl();

  ////////////////////// DOCS /////////////////////////////

  static String COMMON_DOCS_LOAD(String docKey) =>
      "$BASE_URL_COMMON/api/CommonDoc/loadDocument?DocumentKey=$docKey";
  static String COMMON_DOCS_VIEW(String docId) =>
      "$BASE_URL_COMMON/api/CommonDoc/ViewDocument?DocId=$docId";
  static String get COMMON_DOCS_ADD =>
      "$BASE_URL_COMMON/api/CommonDoc/AddDocument";
  static String COMMON_DOCS_DELETE(String docId) =>
      "$BASE_URL_COMMON/api/CommonDoc/DeleteDocument?DocumentID=$docId";
  static String USER_SETTINGS = "$BASE_URL_COMMON/api/MDI/SaveUserSettingData";
  static String FETCH_USER_SETTING = "$BASE_URL_COMMON/api/MDI/GetUserSetting";

  ////////////////////// SEARCH ////////////////////////////

  static String SEARCH_SEND_NAME(
    String mail,
    String pageName,
  ) {
    var currentDate =
        DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateTime.now());
    return BASE_URL_COMMON +
        "/api/MDI/SaveApplicationPagesFootprintData?UserName=$mail&PageName=$pageName&AccessDate=$currentDate";
  }

  static String SEARCH_VARIANCE(
      {required String viewName,
      required String screenName,
      required String loginCode}) {
    // return BASE_URL + "/api/$screenName/SearchVariance/$viewName";
    return BASE_URL_COMMON + "/api/CommonSearch/SearchVariance/$viewName";
  }

  static String SEARCH_BINDGRID(
      {required String viewName,
      required String screenName,
      required String code}) {
    // return BASE_URL + "/api/$screenName/BindGrid/$viewName,$code";
    return BASE_URL_COMMON + "/api/CommonSearch/BindGrid/$viewName,$code";
  }

  static String SEARCH_MASTER_SEARCH({
    required String name,
    required String valuecolumnname,
    required String TableName,
    required bool chkLikeNotLike,
    required String searchvalue,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/TextSearch?name=$name&valuecolumnname=$valuecolumnname&TableName=$TableName&chkLikeNotLike=$chkLikeNotLike&searchvalue=$searchvalue";
    return BASE_URL_COMMON +
        "/api/CommonSearch/TextSearch?name=$name&valuecolumnname=$valuecolumnname&TableName=$TableName&chkLikeNotLike=$chkLikeNotLike&searchvalue=$searchvalue";
  }

  static String SEARCH_EXECUTE_SEARCH({
    required String strViewName,
    required String loginCode,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/SearchExecute?strViewName=$strViewName";
    return BASE_URL_COMMON +
        "/api/CommonSearch/SearchExecute?strViewName=$strViewName";
  }

  // static String SEARCH_PIVOT({required String screenName,}) => BASE_URL + "/api/$screenName/SearchPivot";
  static String SEARCH_PIVOT({
    required String screenName,
  }) =>
      BASE_URL_COMMON + "/api/CommonSearch/SearchPivot";

  // static String SEARCH_EXCUTE_PIVOT({required String screenName, required String strViewname,}) => BASE_URL + "/api/$screenName/SearchExecutePivot?strViewName=$strViewname";
  static String SEARCH_EXCUTE_PIVOT({
    required String screenName,
    required String strViewname,
  }) =>
      BASE_URL_COMMON +
      "/api/CommonSearch/SearchExecutePivot?strViewName=$strViewname";

  static String ADD_SEARCH_VARIANCE({
    required String strViewName,
    required String loginCode,
    required String screenName,
    required String sVariant,
    // required String pivotTemplate,
  }) {
    // return BASE_URL + "/api/$screenName/InsertSearchVariance?strViewName=$strViewName&sVariant=$sVariant";
    return BASE_URL_COMMON +
        "/api/CommonSearch/InsertSearchVariance?strViewName=$strViewName&sVariant=$sVariant";
  }

  static String DELETE_SEARCH_VARIANCE({
    required String varianceId,
    required String loginCode,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/DeleteSearchVariance?VarianceId=$varianceId";
    return BASE_URL_COMMON +
        "/api/CommonSearch/DeleteSearchVariance?VarianceId=$varianceId";
  }

  /////////////////////////////////////////////////////////

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
  static String CONVERT_TO_PDF =
      "$BASE_URL_COMMON/api/Common/ConvertTableToPDF";
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

/////////////////////////////////////End FPC Mismatch////////////////////////////////////////////////////

//////////////////////////////////////////Log Additions API: Deven UI: Sanjaya///////////////////////////////////////////////
  static String LOG_ADDITION_LOCATION =
      BASE_URL + "/api/Additions/GetLoadLocation";
  static String LOG_ADDITION_CHANNEL =
      BASE_URL + "/api/Additions/GetLocationSelect?Locationcode=";

  static String LOG_ADDITION_PREVIOUS_ADDITION(
    String locName,
    String chnlName,
    String date,
    String aditionNo,
  ) =>
      BASE_URL +
      "/api/Additions/GetDisplayPreviousAdditon?locationName=$locName&channelName=${Uri.encodeComponent(chnlName)}&Date=$date&additionnumber=$aditionNo";

  static String LOG_ADDITION_SHOW_DETAILS(
          DropDownValue locDetail,
          DropDownValue chnlDetails,
          String date,
          bool isPrimary,
          bool checkStandBy,
          bool checkIgnore) =>
      BASE_URL +
      "/api/Additions/GetShowDetails?Locationcode=${locDetail.key}&locationName=${Uri.encodeComponent(locDetail.value ?? "")}&channelcode=${chnlDetails.key}&channelName=${Uri.encodeComponent(chnlDetails.value ?? "")}&logdate=$date&optPrimary=$isPrimary&chkStandby=$checkStandBy&chkIgnore=$checkIgnore";

  static String LOG_ADDITION_GET_ADDITIONS(
          DropDownValue locDetail, DropDownValue chnlDetails, String date) =>
      BASE_URL +
      "/api/Additions/GetPopulateAdditions?Locationcode=${locDetail.key}&channelcode=${chnlDetails.key}&Date=$date";

  static String LOG_ADDITION_SAVE_ADDITION() =>
      BASE_URL + "/api/Additions/PostAddition";

  //////////////////////////////////////////End Log Addition///////////////////////////////////////////////

//////////////// Import Digitex Run Order: UI:SHOEB SHAIKH, API: INDRESH ///////////////

  static String IMPORT_DIGITEX_RUN_ORDER_LOCATION =
      "$BASE_URL/api/ImportDigitexRunOrder/GetLocations";

  static String IMPORT_DIGITEX_RUN_ORDER_CHANNEL(locationCode) =>
      "$BASE_URL/api/ImportDigitexRunOrder/GetChannels/$locationCode";
  static String IMPORT_DIGITEX_RUN_ORDER_AGENCY =
      "$BASE_URL/api/ImportDigitexRunOrder/GetAgencyMasters/";
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

  static String IMPORT_DIGITEX_RUN_ORDER_FILE_FORMAT(
          locationCode, channelCode, date) =>
      "$BASE_URL/api/ImportDigitexRunOrder/FileFormat?LocationCode=$locationCode&ChannelCode=$channelCode&Date=$date";

//////////////// Filler: UI:VISHAL GORE, API: INDRESH ///////////////
  static String FILLER_LOCATION = "$BASE_URL/api/FillerScheduling/GetLocations";
  static String FILLER_SAVE = "$BASE_URL/api/FillerScheduling/GetLocations";
  static String FILLER_CHANNEL(locationCode) =>
      "$BASE_URL/api/FillerScheduling/GetChannels?LocationCode=$locationCode";
  static String FILLER_CAPTION =
      "$BASE_URL/api/FillerScheduling/GetFillerCaption/";
  static String get FILLER_IMPORT_EXCEL =>
      "$BASE_URL/api/FillerScheduling/ImportFillerExcel";
  static String get FILLER_IMPORT_FILLERS =>
      "$BASE_URL/api/FillerScheduling/SaveImportExistingFillers";

  /// to Search Caption in dropdown
  static String FILLER_VALUE_BY_CAPTION(fillerCaption) =>
      "$BASE_URL/api/FillerScheduling/GetFillerCaption/$fillerCaption";

  static String FILLER_VALUES_BY_FILLER_CODE(fillerCode) =>
      "$BASE_URL/api/FillerScheduling/GetFillerValuesByFillerCode/$fillerCode";

  static String FILLER_VALUES_BY_TAPE_CODE(tapeCode) =>
      "$BASE_URL/api/FillerScheduling/GetFillerValuesByTapeCode/$tapeCode";
  static String FILLER_IMPORT_FILE =
      "$BASE_URL/api/FillerScheduling/ImportFillerExcel";
  static String FILLER_SAVE_IMPORT_FILLERS =
      "$BASE_URL/api/FillerScheduling/SaveImportFillers";

  static String FPC_DETAILS(locationCode, channelCode, date) =>
      "$BASE_URL/api/FillerScheduling/GetFpcDetails?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date";

  static String SEGMENT_DETAILS(programCode, exportTapeCode, episodeNumber,
          originalRepeatCode, locationCode, channelCode, startTime, date) =>
      "$BASE_URL/api/FillerScheduling/GetSegmentDetails?ProgramCode=$programCode&ExportTapeCode=$exportTapeCode&EpisodeNumber=$episodeNumber&OriginalRepeatCode=$originalRepeatCode&LocationCode=$locationCode&ChannelCode=$channelCode&StartTime=$startTime&StartDate=$date";

  //////////////// Filler: UI: VISHAL G,API: DEVEN ///////////////

  static String COMMERCIAL_LOCATION =
      "$BASE_URL/api/CommercialScheduling/csload";

  static String COMMERCIAL_CHANNEL(locationCode) =>
      "$BASE_URL/api/CommercialScheduling/GetLocationSelect?Locationcode=$locationCode";

  static String COMMERCIAL_SHOW_FPC_SCHEDULLING_DETAILS(
          locationCode, channelCode, date) =>
      "$BASE_URL/api/CommercialScheduling/GetShowDetails?Locationcode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date";

  static String COMMERCIAL_SHOW_ON_TAB_DETAILS() =>
      "$BASE_URL/api/CommercialScheduling/GetTabChange";

  static String get SAVE_COMMERCIAL_DETAILS =>
      "$BASE_URL/api/CommercialScheduling/PostSave";

//////// RO CANCELLATION ///////
  static String RO_CANCELLATION_LOCATION =
      "$BASE_URL/api/ROCancellation/GetCboLocation";

  static String RO_CANCELLATION_CHANNNEL(locationCode) =>
      "$BASE_URL/api/ROCancellation/OnLeaveLocation?LocationCode=$locationCode";

  static String RO_CANCELLATION_BOOKINGNO_LEAVE =
      "$BASE_URL/api/ROCancellation/OnLeaveBookingNumbers";
  static String RO_CANCELLATION_CANCEL_LEAVE =
      "$BASE_URL/api/ROCancellation/OnLeaveCancelNumber";
  static String RO_CANCELLATION_SAVE =
      "$BASE_URL/api/ROCancellation/SaveRoCancellation";
  static String RO_CANCELLATION_IMPORT =
      "$BASE_URL/api/ROCancellation/ImportExcel";
  static String RO_CANCELLATION_ADD_DOC =
      "$BASE_URL/api/ROCancellation/AddingDocument";
  static String RO_CANCELLATION_VIEW_DOC(id) =>
      "$BASE_URL/api/ROCancellation/ViewDocument?DocId=$id";
  static String RO_CANCELLATION_LOAD_DOC(docKey) =>
      "$BASE_URL/api/ROCancellation/loadDocument?DocumentKey=$docKey";

  static String RO_CANCELLATION_LIST_DOC =
      "$BASE_URL/api/ROCancellation/AddingDocument";

  ////////////////////////////// MAM WORK ORDERS API START////////////////////////////////////////////////
  static String get MAM_WORK_ORDER_INITIALIZE =>
      "$BASE_URL/api/MAMWorkOrder/OnLoadWorkOrder";

  /////////////////////////////////// 1st tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_NON_FPC_LOCATION_LEAVE(String? locationCode) {
    return "$BASE_URL/api/MAMWorkOrder/OnLeaveLocation${(locationCode == null || locationCode.isEmpty) ? '' : '?LocationCode=$locationCode'}";
  }

  static String get MAM_WORK_ORDER_NON_FPC_BMS_SEARCH =>
      "$BASE_URL/api/MAMWorkOrder/OnLoadBMSProgram?Search=";

  static String get MAM_WORK_ORDER_NON_FPC_GETTXID =>
      "$BASE_URL/api/MAMWorkOrder/GetTxId";
  static String MAM_WORK_ORDER_NON_FPC_SegmentsPerEps(String nMaxEpsGap) =>
      "$BASE_URL/api/MAMWorkOrder/GetMaxEpisodeNoGap?nMaxEpsGap=$nMaxEpsGap";
  static String MAM_WORK_ORDER_NON_FPC_GETSEGMENTSOn_TELECAST_LEAVE(
    bool chkWithTXId,
    String BMSPrograms,
    String TelecastType,
    String FromEpiNo,
    String ToEpiNo,
    String nMaxEpsGap,
    String TXId,
    String SegmentsPerEps,
  ) =>
      "$BASE_URL/api/MAMWorkOrder/GetTelecastType?chkWithTXId=$chkWithTXId&BMSPrograms=$BMSPrograms&TelecastType=$TelecastType&FromEpiNo=$FromEpiNo&ToEpiNo=$ToEpiNo&nMaxEpsGap=$nMaxEpsGap&TXId=$TXId&SegmentsPerEps=$SegmentsPerEps";

  static String get MAM_WORK_ORDER_NON_FPC_RMS_SEARCH =>
      "$BASE_URL/api/MAMWorkOrder/OnLoadcboProgram?Search=";

  static String MAM_WORK_ORDER_NON_FPC_ON_BMS_LEAVE(String? val) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveBMSPrograms?BMSProgramCode=$val";

  static String get MAM_WORK_ORDER_NON_FPC_GET_DATA =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveProgram";

  static String get MAM_WORK_ORDER_NON_FPC_SAVE_DATA =>
      "$BASE_URL/api/MAMWorkOrder/SaveWorkOrder";

  /////////////////////////////////// 2nd tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_WO_ADFPC_GET_CHANNEL(
          String locationCode, String loginCode) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveLocationFPC?LocationCode=$locationCode&LoginCode=$loginCode";

  static String get MAM_WORK_ORDER_WO_ADFPC_GET_DATATABLE_DATA =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveTelecastDate";

  static String get MAM_WORK_ORDER_WO_ADFPC_SAVE_DATA =>
      "$BASE_URL/api/MAMWorkOrder/SaveWOsFPC";

  /////////////////////////////////// 3rd tab api //////////////////////////////////////////
  static String get MAM_WORK_ORDER_WO_RE_PUSH_GET_DATA =>
      "$BASE_URL/api/MAMWorkOrder/OnLoadRepush";

  static String get MAM_WORK_ORDER_WO_RE_PUSH_GET_JSON =>
      "$BASE_URL/api/MAMWorkOrder/dgvRepushWorkOrderCell";

  static String get MAM_WORK_ORDER_WO_RE_PUSH_SAVE_DATA =>
      "$BASE_URL/api/MAMWorkOrder/RepushReloadWorkService";

  /////////////////////////////////// 4th tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_WO_CANCEL_GET_CHANNEL(
          String locationCode, String loginCode) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveLocationWOCanc?LocationCode=$locationCode&LoginCode=$loginCode";

  static String get MAM_WORK_ORDER_WO_CANCEL_PROGRAM_SEARCH =>
      "$BASE_URL/api/MAMWorkOrder/OnLoadCancelProgram?Search=";

  static String get MAM_WORK_ORDER_WO_CANCEL_SHOW_DATA =>
      "$BASE_URL/api/MAMWorkOrder/ShowWorkOrder";

  static String get MAM_WORK_ORDER_WO_CANCEL_CANCEL_DATA =>
      "$BASE_URL/api/MAMWorkOrder/CancelWorkOrder";

  /////////////////////////////////// 5th tab api //////////////////////////////////////////
  static String MAM_WORK_ORDER_WO_HISTORY_GET_CHANNEL(
          String locationCode, String loginCode) =>
      "$BASE_URL/api/MAMWorkOrder/OnLeaveLocationWOHistory?LocationCode=$locationCode&LoginCode=$loginCode";

  static String get MAM_WORK_ORDER_WO_HISTORY_PROGRAM_SEARCH =>
      "$BASE_URL/api/MAMWorkOrder/OnLoadProgramWOHistory?Search=";

  static String get MAM_WORK_ORDER_WO_HISTORY_SHOW_DATA =>
      "$BASE_URL/api/MAMWorkOrder/GetShowWorkOrderHistory";

  ////////////////////////////// MAM WORK ORDERS API END////////////////////////////////////////////////

  ////////////////////////////// Spot Priority | Sanjaya :UI | Deven Bhole : API ////////////////////////

  static String SPOT_PRIORITY_LOCATION() =>
      "$BASE_URL/api/SetSpotPriority/GetInitial";

  static String SPOT_PRIORITY_CHANNEL() =>
      "$BASE_URL/api/SetSpotPriority/GetChannelList?LocationCode=";

  static String SPOT_PRIORITY_SAVE() =>
      "$BASE_URL/api/SetSpotPriority/PostSave";

  static String SPOT_PRIORITY_SHOW_DETAILS(
          String loc, String chnlCode, String frmDt, String toDt) =>
      "$BASE_URL/api/SetSpotPriority/GetShowDetails?LocationCode=$loc&Channelcode=$chnlCode&FromDate=$frmDt&ToDate=$toDt";

//////// RO CANCELLATION ///////
  static String RO_RESCHEDULE_INIT =
      "$BASE_URL/api/RoReschedule/OnLoad_Reschedule";

  static String RO_RESCHEDULE_CHANNNEL(locationCode) =>
      "$BASE_URL/api/RoReschedule/OnLeave_Location?LocationCode=$locationCode";
  static String RO_RESCHEDULE_BOOKINGNO_LEAVE =
      "$BASE_URL/api/RoReschedule/OnLeave_BookingNumber";

  static String RO_RESCHEDULE_DGVGRID_DOUBLECLICK =
      "$BASE_URL/api/RoReschedule/OnDoubleClick_dgvViewRO";
  static String RO_RESCHEDULE_SCHEDULENO_LEAVE =
      "$BASE_URL/api/RoReschedule/OnLeave_ReschedulingNo";
  static String RO_RESCHEDULE_MODIFY =
      "$BASE_URL/api/RoReschedule/OnClick_Modify";
  static String RO_RESCHEDULE_ADDSPOT =
      "$BASE_URL/api/RoReschedule/OnClick_AddSpots";
  static String RO_RESCHEDULE_SAVE =
      "$BASE_URL/api/RoReschedule/OnSave_Rescheduling";

  static String RO_RESCHEDULE_SELECTED_INDEX_CHNAGE_TAPEID =
      "$BASE_URL/api/RoReschedule/SelectedIndexChanged_TapeID";

////////////////////////////////End Spot Priority ////////////////////////

////////////////////////////// Transmission Log | Sanjaya :UI | Deven Bhole : API ////////////////////////

  static String TRANSMISSION_LOG_LOCATION() =>
      "$BASE_URL/api/Transmissionlog/GetLoadLocation";

  static String TRANSMISSION_LOG_CHANNEL(String locId) =>
      "$BASE_URL/api/Transmissionlog/GetLocationSelect?Locationcode=$locId";

  static String TRANSMISSION_LOG_RETRIVE() =>
      "$BASE_URL/api/Transmissionlog/PostLoadSavedLog";

  static String TRANSMISSION_LOG_CHANNEL_SPEC_SETTING(
          String locId, String channelId) =>
      "$BASE_URL/api/Transmissionlog/GetChannelSpecsSettings?Locationcode=$locId&ChannelCode=$channelId";

  static String TRANSMISSION_LOG_COLOR_LIST(
          String locId, String channelId, String telcastDt) =>
      "$BASE_URL/api/Transmissionlog/GetLoadColours?locationcode=$locId&channelcode=$channelId&telecastdate=$telcastDt";

  static String TRANSMISSION_LOG_AUTO(String locId, String channelId,
          String telecastDt, bool isPromoReq, bool chkTxComm) =>
      "$BASE_URL/api/Transmissionlog/GetAutoClick?Locationcode=$locId&channelcode=$channelId&telecastdate=$telecastDt&addpromosAuto=$isPromoReq&chkTxCommercial=$chkTxComm";

  static String TRANSMISSION_LOG_COMMERCIAL_CLICK(
          String locId, String channelId, String telecastDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetCommercialsClick?locationcode=$locId&channelcode=$channelId&Date=$telecastDt&standbyLog=$standBy";

  static String TRANSMISSION_LOG_UPDATED_CLICK(
          String locId, String channelId, String telecastDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetUpdatedLogClick?Locationcode=$locId&channelcode=$channelId&Date=$telecastDt&standbyLog=$standBy";

  static String TRANSMISSION_LOG_VERIFY_CLICK(
          String locId, String channelId, String telecastDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetbtnVerifyClick?locationcode=$locId&channelcode=$channelId&txtDate=$telecastDt&chkStandBy=$standBy";

  static String TRANSMISSION_LOG_POST_VERIFY() =>
      "$BASE_URL/api/Transmissionlog/PostVerifyTime";

  static String TRANSMISSION_LOG_SEARCH_INSERT(
          String locId,
          String channelId,
          String telecastDt,
          bool isMine,
          String eventType,
          String txId,
          String caption) =>
      "$BASE_URL/api/Transmissionlog/GetFastInsertsearchClick?locationcode=$locId&channelcode=$channelId&telecastdate=$telecastDt&mine=$isMine&eventType=$eventType&TxID=$txId&Caption=$caption";

  static String TRANSMISSION_LOG_BUTTON_VERIFY(
          String locId, String channelId, String telecastDt, bool isStandBy) =>
      "$BASE_URL/api/Transmissionlog/GetbtnVerifyClick?locationcode=$locId&channelcode=$channelId&txtDate=$telecastDt&chkStandBy=$isStandBy";

  static String TRANSMISSION_LOG_BUTTON_DETAILS_VERIFY(
          String locId, String channelId, String telecastDt) =>
      "$BASE_URL/api/Transmissionlog/GetbtnDetailClick?locationcode=$locId&channelcode=$channelId&txtDate=$telecastDt";

  static String TRANSMISSION_LOG_EVENT_LIST() =>
      "$BASE_URL/api/Transmissionlog/GetLoadFastInsertEventType";

  static String TRANSMISSION_LOG_POST_PIVOT_LOG() =>
      "$BASE_URL/api/Transmissionlog/PostPivotLog";
  static String TRANSMISSION_LOG_POST_SAVE_LOG() =>
      "$BASE_URL/api/Transmissionlog/PostSaveTransmissionlog";

  static String TRANSMISSION_LOG_POST_TS() =>
      "$BASE_URL/api/Transmissionlog/PostTsCalc";
  static String TRANSMISSION_LOG_GET_BACKTOBACK_PRODUCT() =>
      "$BASE_URL/api/Transmissionlog/GetCheckBackToBackProducts";
  static String TRANSMISSION_LOG_EXPORT_CLICK(
          String locId,
          String chnlId,
          String txtDt,
          String chnlNm,
          String locName,
          int expRowno,
          String exportTime,
          bool secEvnt,
          String apiCallVal) =>
      "$BASE_URL/api/Transmissionlog/GetbtnExportDataClick?Locationcode=$locId&Txtdate=$txtDt&channelName=$chnlNm&LocationName=$locName&ExportRowNumber=$expRowno&ExportTime=$exportTime&AddSecondaryEvents=$secEvnt&ApiCallValue=$apiCallVal&ChannelCode=$chnlId";

  static String TRANSMISSION_LOG_WRITE_EXCEL(
          String locId, String chnlId, String txtDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetWriteExcel?locationcode=$locId&channelcode=$chnlId&TxtDate=$txtDt&chkStandBy=$standBy";
  static String TRANSMISSION_LOG_WRITE_VIZRT(
          String locId, String chnlId, String txtDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetExportVizrt?locationcode=$locId&channelcode=$chnlId&TxtDate=$txtDt&chkStandBy=$standBy";
  static String TRANSMISSION_LOG_WRITE_OLDEXCEL(String locId, String chnlId,
          String txtDt, bool standBy, String fileName, String type) =>
      "$BASE_URL/api/Transmissionlog/GetWriteOLDExcel?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt&chkStandBy=$standBy&type=$type&FileName=$fileName";
  static String TRANSMISSION_LOG_WRITE_DSERIES(
          String locId,
          String chnlId,
          String txtDt,
          bool standBy,
          bool addSecondaryEvent,
          bool chkPartialLog,
          String fromTime,
          String toTime) =>
      "$BASE_URL/api/Transmissionlog/GetWriteDSeriesLog?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt&chkStandBy=$standBy&AddSecondaryEvent=$addSecondaryEvent&chkPartialLog=$chkPartialLog&FromTime=$fromTime&ToTime=$toTime";
  static String TRANSMISSION_LOG_WRITE_LST(
          String locId,
          String chnlId,
          String txtDt,
          bool standBy,
          bool chkPartialLog,
          String fromTime,
          String toTime,
          String fileName) =>
      "$BASE_URL/api/Transmissionlog/GetWriteLst?locationcode=$locId&channelcode=$chnlId&telecastdate=$txtDt&standbyLog=$standBy&chkPartialLog=$chkPartialLog&FromTime=$fromTime&ToTime=$toTime&FileName=$fileName";
  static String TRANSMISSION_LOG_WRITE_LST_NOIDA(
          String locId,
          String chnlId,
          String txtDt,
          bool standBy,
          bool addSecondaryEvent,
          bool chkPartialLog,
          String fromTime,
          String toTime,
          String fileName) =>
      "$BASE_URL/api/Transmissionlog/GetWriteLst?locationcode=$locId&channelcode=$chnlId&telecastdate=$txtDt&standbyLog=$standBy&chkPartialLog=$chkPartialLog&FromTime=$fromTime&ToTime=$toTime&AddSecondaryEvents=$addSecondaryEvent&Noida=true&fileName=$fileName";
  static String TRANSMISSION_LOG_WRITE_GRASS_VALLEY(
    String locId,
    String chnlId,
    String txtDt,
    bool standBy,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetGVLog?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt&chkStandBy=$standBy";
  static String TRANSMISSION_LOG_WRITE_VIDEOCON_GV(
    String locId,
    String chnlId,
    String txtDt,
    bool standBy,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetWriteVideoconGV?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt&chkStandBy=$standBy";
  static String TRANSMISSION_LOG_WRITE_PLAYBOX(
    String locId,
    String chnlId,
    String txtDt,
    bool standBy,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetWritePlaybox?locationcode=$locId&channelcode=$chnlId&TxtDate=$txtDt&chkStandBy=$standBy";
  static String TRANSMISSION_LOG_WRITE_COMMERCIAL_REPLACE(
    String locId,
    String chnlId,
    String txtDt,
    String fileName,
    String channelName,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetWriteCommercialReplacement?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt&FileName=$fileName&ChannelName=$channelName";
  static String TRANSMISSION_LOG_WRITE_VZRT(
    String locId,
    String chnlId,
    String txtDt,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetWriteExcelevzrt?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt";
  static String TRANSMISSION_LOG_WRITE_ITX(String locId, String chnlId,
          String txtDt, String chnlName, String fileName) =>
      "$BASE_URL/api/Transmissionlog/GetExportITX?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt&ChannelName=$chnlName&filename=$fileName";

  static String TRANSMISSION_LOG_EXPORT_FPC_TIME(
          String loc, String chnl, String txtDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetExportClick?locationcode=$loc&channelcode=$chnl&txtDate=$txtDt&chkStandBy=$standBy";

  static String TRANSMISSION_LOG_LAST_SAVEDLOG(
    String locId,
    String chnlId,
    String txtDt,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetbtnLastSavedLogClick?locationcode=$locId&channelcode=$chnlId&txtDate=$txtDt";
  static String TRANSMISSION_LOG_TS_GET_HIGHLIGHT(
    String locId,
    String chnlId,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetHighlightTSGrid?Locationcode=$locId&ChannelCode=$chnlId";
  static String TRANSMISSION_LOG_SEGMENT_PROGRAM_SEARCH() =>
      "$BASE_URL/api/Transmissionlog/GetProgramSearch?TextSourceProgram=";
  static String TRANSMISSION_LOG_POST_RESCHEDULE() =>
      "$BASE_URL/api/Transmissionlog/PostRescheduleSpotsClick";
  static String TRANSMISSION_LOG_PROF_LEAVE(
    String progCode,
    String epNo,
  ) =>
      "$BASE_URL/api/Transmissionlog/GettxtInsProgpisodeNoLeave?programcode=$progCode&EpisodeNo=$epNo";
  static String TRANSMISSION_LOG_SEARCH_SEGMENT(
          String progCode, String epNo, String tapeCode, bool defaultSeg) =>
      "$BASE_URL/api/Transmissionlog/GetinsProgSearchClick?programcode=$progCode&episodenumber=$epNo&tapecode=$tapeCode&Defaultsegments=$defaultSeg";

  static String TRANSMISSION_LOG_CHECK_PROMOTAGS(
          String loc, String chnl, String telecaseDt, bool standBy) =>
      "$BASE_URL/api/Transmissionlog/GetCheckPromoTags?locationcode=$loc&channelcode=$chnl&telecastdate=$telecaseDt&standbyLog=$standBy";

  static String TRANSMISSION_LOG_MARK_AS_ERROR(
    String locId,
    String chnlId,
    String bookNo,
    String bookCode,
    String date,
    String eventType,
  ) =>
      "$BASE_URL/api/Transmissionlog/GetRemoveAndMarkAsError?locationcode=$locId&channelcode=$chnlId&BookingNumber=$bookNo&BookingDetailCode=$bookCode&txtDate=$date&EventType=$eventType";

  /////////////////////////// RO DISTRIBUTION START/////////////////////
  static String get RO_DISTRIBUTION_GET_LOCATION =>
      "$BASE_URL/api/RosDistribution/GetRosDistribution";
  static String get RO_DISTRIBUTION_GET_RETRIVE_DATA =>
      "$BASE_URL/api/RosDistribution/GetView";
  static String get RO_DISTRIBUTION_GET_EMPTY_DATA =>
      "$BASE_URL/api/RosDistribution/GetEmptyList";
  static String get RO_DISTRIBUTION_GET_UN_DATA =>
      "$BASE_URL/api/RosDistribution/GetUnalloacted";
  static String get RO_DISTRIBUTION_GET_SERVICE_DATA =>
      "$BASE_URL/api/RosDistribution/GetServices";
  static String get RO_DISTRIBUTION_GET_ALLOCATION_DATA =>
      "$BASE_URL/api/RosDistribution/GetAllocateClick";
  static String get RO_DISTRIBUTION_GET_DEALLOCATE_DATA =>
      "$BASE_URL/api/RosDistribution/GetRollback";
  static String get RO_DISTRIBUTION_GET_FPC_DOUBLE_CLICK_DATA =>
      "$BASE_URL/api/RosDistribution/GetFpcCellDoubleClick";
  static String get RO_DISTRIBUTION_GET_OPENDEAL_FILTER_DATA =>
      "$BASE_URL/api/RosDistribution/GetOpenDealFilter";
  static String get RO_DISTRIBUTION_GET_ALLOCATE_FPC_DATA =>
      "$BASE_URL/api/RosDistribution/GetAllocateFPC";
  static String get RO_DISTRIBUTION_GET_DEALLOCATE_FPC_DATA =>
      "$BASE_URL/api/RosDistribution/GetDeallocateFPC";
  static String get RO_DISTRIBUTION_GET_INCLUDE_ROS_FILTER_FPC_DATA =>
      "$BASE_URL/api/RosDistribution/GetIncludeROSFilter";
  static String get RO_DISTRIBUTION_GET_OPEN_DEAL_FILTER_FPC_DATA =>
      "$BASE_URL/api/RosDistribution/GetOpenDealFilter";
  static String get RO_DISTRIBUTION_GET_MOVE_SPOT_FILTER_FPC_DATA =>
      "$BASE_URL/api/RosDistribution/GetOpenDealFilter";

  static String RO_DISTRIBUTION_GET_CHANNEL(String locId) =>
      "$BASE_URL/api/RosDistribution/cboLocationCode_Leave?LocationCode=$locId";
  static String RO_DISTRIBUTION_SHOW_DATA(
          String locId, String channelID, String date) =>
      "$BASE_URL/api/RosDistribution/GetShowBucket?LocationCode=$locId&ChannelCode=$channelID&Date=$date";

  /////////////////////////// RO DISTRIBUTION END/////////////////////
////
  ///
  ///
  ///
  ///
  ///
  ///
////////////////////////////// SLIDE-MASTER-API-START//////////////////////////////////////////////
  static String SLIDE_MASTER_GET_CHANNEL(String locationCode) =>
      "$BASE_URL/api/SlideMaster/onLeaveLocation?LocationCode=$locationCode";
  static String get SLIDE_MASTER_TAPE_ID_LEAVE =>
      "$BASE_URL/api/SlideMaster/TapeID_Leave";
  static String get SLIDE_MASTER_ON_LOAD =>
      "$BASE_URL/api/SlideMaster/SlideMasteronLoad";
  static String get SLIDE_MASTER_TAPE_SEG_NO_LEAVE =>
      "$BASE_URL/api/SlideMaster/SegNo_Leave";
  static String get SLIDE_MASTER_TAPE_SAVE_DATA =>
      "$BASE_URL/api/SlideMaster/SaveRecord";
  static String get SLIDE_MASTER_GET_RETRIVE_DATA =>
      "$BASE_URL/api/SlideMaster/RetriveRecord";
  static String get SLIDE_MASTER_TAPE_HOUSE_ID_LEAVE =>
      "$BASE_URL/api/SlideMaster/HouseID_Leave";
////////////////////////////// SLIDE-MASTER-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
////////////////////////////// SALES-AUDIT-EXTRA-SPOTS-API-START//////////////////////////////////////////////
  static String get SALES_AUDIT_EXTRA_SPOTS_ON_LOAD =>
      "$BASE_URL/api/SalesAuditExtraSR/GetextraspotsreportLoad";
  static String get SALES_AUDIT_EXTRA_SPOTS_GENERATE =>
      "$BASE_URL/api/SalesAuditExtraSR/GetGenrate";
////////////////////////////// SALES-AUDIT-EXTRA-SPOTS-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ////////////////////////////// FINAL-AUDIT-MASTER-AT-API-START  ////////////////////////////////////////////
  static String get FINAL_REPORT_AT_INITAIL =>
      "$BASE_URL/api/FinalAuditReportAT/ZoneWiseInventoryLoad";
  static String get FINAL_REPORT_AT_GET_DATA =>
      "$BASE_URL/api/FinalAuditReportAT/GenrateClick";
  static String FINAL_REPORT_AT_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/FinalAuditReportAT/GetChannel?LocationCode=$lc";
  ////////////////////////////// FINAL-AUDIT-MASTER-AT-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ////////////////////////////// SECONDARY-EVENT-MASTER-API-START  ////////////////////////////////////////////
  static String get SECONDARY_EVENT_MASTER_INITAIL =>
      "$BASE_URL/api/SecondaryEventMaster/FormLoad";
  static String get SECONDARY_EVENT_MASTER_SAVE_DATA =>
      "$BASE_URL/api/SecondaryEventMaster/Save";
  static String SECONDARY_EVENT_MASTER_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/SecondaryEventMaster/Getlistchannel?LocationCode=$lc";
  static String SECONDARY_EVENT_MASTER_DISPLAY_DATA(String txid) =>
      "$BASE_URL/api/SecondaryEventMaster/DisplaySecondaryEvent?TXid=$txid";
  ////////////////////////////// SECONDARY-EVENT-MASTER-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ////////////////////////////// PROMO-API-START  ////////////////////////////////////////////
  static String get PROMOS_GET_LOCATION =>
      "$BASE_URL/api/PromoScheduling/GetLocations";
  static String get PROMOS_SAVE_AUTO_PROMO =>
      "$BASE_URL/api/PromoScheduling/SaveAutoPromo";
  static String get PROMOS_SAVE =>
      "$BASE_URL/api/PromoScheduling/SavePromoScheduling";
  static String get PROMOS_IMPORT_EXCEL_VALIDATE =>
      "$BASE_URL/api/PromoScheduling/ImportExcelValidate";
  static String get PROMOS_IMPORT_EXCEL =>
      "$BASE_URL/api/PromoScheduling/ImportExcel";
  static String get PROMOS_LEFT_2ND_GET_DATA =>
      "$BASE_URL/api/PromoScheduling/ProgramSegaments";
  static String get PROMOS_SEARCH =>
      "$BASE_URL/api/PromoScheduling/FastInsertSearch";
  static String PROMOS_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/PromoScheduling/GetChannels?LocationCode=$lc";
  static String PROMOS_SHOW_DETAILS(
          String lc, String channelCode, String teleCasteDate) =>
      "$BASE_URL/api/PromoScheduling/GetPromoSchDetails?LocationCode=$lc&ChannelCode=$channelCode&TelecastDate=$teleCasteDate";
  static String PROMOS_DELETE(
          String lc, String channelCode, String teleCasteDate) =>
      "$BASE_URL/api/PromoScheduling/DeletePromoSchDetails?LocationCode=$lc&ChannelCode=$channelCode&TelecastDate=$teleCasteDate";

  ////////////////////////////// PROMO-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ////////////////////////////// EVENT-SECONDARY-API-START  ////////////////////////////////////////////
  static String get EVENT_GET_LOCATION =>
      "$BASE_URL/api/ScheduleSecondayEvents/GetLocations";
  static String get EVENT_SAVE =>
      "$BASE_URL/api/ScheduleSecondayEvents/EventSave";
  // static String get EVENT_IMPORT_EXCEL_VALIDATE => "$BASE_URL/api/ScheduleSecondayEvents/ImportExcelValidate";
  // static String get EVENT_IMPORT_EXCEL => "$BASE_URL/api/ScheduleSecondayEvents/ImportExcel";
  // static String get EVENT_LEFT_2ND_GET_DATA => "$BASE_URL/api/ScheduleSecondayEvents/ProgramSegaments";
  static String get EVENT_SEARCH =>
      "$BASE_URL/api/ScheduleSecondayEvents/EventSearch";
  static String EVENT_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/ScheduleSecondayEvents/GetChannels?LocationCode=$lc";
  static String get EVENT_SHOW_DETAILS =>
      "$BASE_URL/api/ScheduleSecondayEvents/ShowDetails";
  static String get EVENT_PREVIOUS_DETAILS =>
      "$BASE_URL/api/ScheduleSecondayEvents/PreviousEvent";
  static String EVENT_DELETE_ALL(
          String lc, String channelCode, String teleCasteDate) =>
      "$BASE_URL/api/ScheduleSecondayEvents/DeletePromoSchDetails?LocationCode=$lc&ChannelCode=$channelCode&TelecastDate=$teleCasteDate";

  ////////////////////////////// EVENT-SECONDARY-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ////////////////////////////// SLIDE-API-START  ////////////////////////////////////////////
  static String get SLIDE_GET_LOCATION =>
      "$BASE_URL/api/ScheduleSlides/GetSlideSchedulingLoad";
  static String get SLIDE_SAVE => "$BASE_URL/api/ScheduleSlides/PostSave";
  static String get SLIDE_GET_DATA =>
      "$BASE_URL/api/ScheduleSlides/GetLstDailyFPC";
  static String SLIDE_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/ScheduleSlides/GetLocationLeave?LocationCode=$lc";
  ////////////////////////////// SLIDE-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ////////////////////////////// FINAL-AUDIT-MASTER-BT-API-START  ////////////////////////////////////////////
  static String get FINAL_REPORT_BT_INITAIL =>
      "$BASE_URL/api/FinalAuditReportBT/FormLoad";
  static String get FINAL_REPORT_BT_GET_DATA =>
      "$BASE_URL/api/FinalAuditReportBT/DateLeave";
  static String FINAL_REPORT_BT_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/FinalAuditReportBT/GetChannel?LocationCode=$lc";
  //////////////////////////// FINAL-AUDIT-MASTER-BT-API-END  //////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ////////////////////////////// STILL-MASTER-API-START  ////////////////////////////////////////////
  static String get STILL_MASTER_FORM_LOAD =>
      "$BASE_URL/api/StillMaster/GetPageLoad";
  static String get STILL_MASTER_TAPE_ID_LEAVE =>
      "$BASE_URL/api/StillMaster/TapeIDLeave";
  static String get STILL_MASTER_TAPE_SEG_NO_LEAVE =>
      "$BASE_URL/api/StillMaster/SegNoLeave";
  static String get STILL_MASTER_TAPE_HOUSE_ID_LEAVE =>
      "$BASE_URL/api/StillMaster/HouseIDLeave";
  static String get STILL_MASTER_TAPE_SAVE_DATA =>
      "$BASE_URL/api/StillMaster/SaveRecord";
  // static String get FINAL_REPORT_BT_GET_DATA => "$BASE_URL/api/FinalAuditReportBT/DateLeave";
  static String STILL_MASTER_GET_CHANNELS(String lc) =>
      "$BASE_URL/api/StillMaster/ListMyChannels?LocationCode=$lc";
  static String STILL_MASTER_GET_PROGRAM_DATA(String lc, String cc) =>
      "$BASE_URL/api/StillMaster/GetProgramPicker?locationcode=$lc&channelcode=$cc";
  static String get STILL_MASTER_GET_RETRIVE_DATA =>
      "$BASE_URL/api/StillMaster/GetRetrieveRecord";
  static String get STILL_MASTER_PROGRAM_SEARCH =>
      "$BASE_URL/api/StillMaster/GetSourceProgramSearch?TextSourceProgram=";
  //////////////////////////// STILL-MASTER-API-END  //////////////////////////////////////////////
  ///
  ///
  ///

  ///////////////// RO BOOKING START //////////////////////////
  static String RO_BOOKING_INIT = "$BASE_URL/api/ROBooking/RoBookingOnLoad";
  static String RO_BOOKING_CHANNNEL(locationCode) =>
      "$BASE_URL/api/ROBooking/Location_Leave?LocationCode=$locationCode";

  static String RO_BOOKING_EFFDT_LEAVE(
          String locId, String channelId, String effDt) =>
      "$BASE_URL/api/ROBooking/EffectiveDate_Leave?LocationCode=$locId&ChannelCode=$channelId&EffectiveDate=$effDt";
  static String RO_BOOKING_CLIENT_LEAVE(
          String locId, String channelId, String clientCode) =>
      "$BASE_URL/api/ROBooking/ClientInfo?LocationCode=$locId&ChannelCode=$channelId&ClientCode=$clientCode";

  static String RO_BOOKING_BOOKING_NO_LEAVE =
      "$BASE_URL/api/ROBooking/OnLeaveBookingNumber";
  static String RO_BOOKING_BOOKING_SEARCH_TAPE_ID(tapeID) =>
      "$BASE_URL/api/ROBooking/SearchTapeId?ExportTapeCode=$tapeID";
  static String RO_BOOKING_GET_SpotsNotVerified =
      "$BASE_URL/api/ROBooking/SpotsNotVerified";
  static String RO_BOOKING_RefreshPDC = "$BASE_URL/api/ROBooking/RefreshPDC";
  static String RO_BOOKING_OnLeaveDealNumber =
      "$BASE_URL/api/ROBooking/OnLeaveDealNumber";
  static String RO_BOOKING_OnAgencyLeave =
      "$BASE_URL/api/ROBooking/OnAgencyLeave";
  static String RO_BOOKING_GET_DISPLAY = "$BASE_URL/api/ROBooking/GetDisplay";
  static String RO_BOOKING_GetSegment = "$BASE_URL/api/ROBooking/GetSegment";
  static String RO_BOOKING_GetTapeIdLostFocus =
      "$BASE_URL/api/ROBooking/GetTapeIdLostFocus";
  static String RO_BOOKING_DEAL_DOUBLE_CLICK =
      "$BASE_URL/api/ROBooking/OndgvDealDetailCellDouble";
  static String RO_BOOKING_GetClientLeave(
          String locationCode, String channelCode, String clientCode) =>
      "$BASE_URL/api/ROBooking/GetClientLeave?LocationCode=$locationCode&ChannelCode=$channelCode&ClientCode=$clientCode";
  static String RO_BOOKING_GetSetVerify =
      "$BASE_URL/api/ROBooking/GetSetVerify";
  static String RO_BOOKING_BRAND_LEAVE = "$BASE_URL/api/ROBooking/GetBrand";
  static String RO_BOOKING_GetSpotNotVerified(
    String locationCode,
    String channelCode,
    String bookingMonth,
    String loggedUser,
  ) =>
      "$BASE_URL/api/ROBooking/SpotsNotVerified?LocationCode=$locationCode&ChannelCode=$channelCode&BookingMonth=$bookingMonth&LoggedUser=$loggedUser";
  static String RO_BOOKING_SPOT_DBL_CLICK =
      "$BASE_URL/api/ROBooking/SpotsNVerified_CellDoubleClick";

  static String RO_BOOKING_ImportAndMark =
      "$BASE_URL/api/ROBooking/ImportAndMark";
  static String RO_BOOKING_cboPDCSelectedIndexChanged =
      "$BASE_URL/api/ROBooking/cboPDCSelectedIndexChanged";

  static String RO_BOOKING_SearchTapeIdLeave(exportCode) =>
      "$BASE_URL/api/ROBooking/SearchTapeId?ExportTapeCode=$exportCode";

  static String RO_BOOKING_cboTapeIdLeave =
      "$BASE_URL/api/ROBooking/cboTapeIdLeave";
  static String RO_BOOKING_SaveClientPdc =
      "$BASE_URL/api/ROBooking/SaveClientPdc";
  static String RO_BOOKING_cboTapeIdFocusLost =
      "$BASE_URL/api/ROBooking/GetTapeIdLostFocus";
  static String RO_BOOKING_AddSpot = "$BASE_URL/api/ROBooking/OnAddSpots";
  static String RO_BOOKING_OnSaveData = "$BASE_URL/api/ROBooking/OnSaveData";
  static String RO_BOOKING_GetClientPDC =
      "$BASE_URL/api/ROBooking/GetClientPDC";
  static String RO_BOOKING_OnSave_Check =
      "$BASE_URL/api/ROBooking/OnSaveData_CheckTapeId";

  //////////////////////////////// RO BOOKING END /////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////// FILLER-MASTER-API-START /////////////////////////////////

  static String FILLER_MASTER_ON_LOAD =
      "$BASE_URL/api/FillerMaster/FillerMasterOnLoad";
  static String FILLER_MASTER_ON_LEAVE_LOCATION(String code) =>
      "$BASE_URL/api/FillerMaster/onLeaveLocation?LocationCode=$code";
  static String FILLER_MASTER_BANNER_SEARCH =
      "$BASE_URL/api/FillerMaster/GetSourceBannerSearch?TextSourceBanner=";
  static String FILLER_MASTER_SAVE = "$BASE_URL/api/FillerMaster/SaveRecord";
  static String FILLER_MASTER_RETRIVE_RECORDS =
      "$BASE_URL/api/FillerMaster/RetriveRecords";
  static String FILLER_MASTER_SEGNO_LEAVE =
      "$BASE_URL/api/FillerMaster/SegNoLeave";
  static String FILLER_MASTER_GET_EVENT =
      "$BASE_URL/api/FillerMaster/GetEvent?text=";
  static String FILLER_MASTER_TAPE_ID_LEAVE =
      "$BASE_URL/api/FillerMaster/TapeIDLeave";

  //////////////////////////////// FILLER-MASTER-API-END /////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////// R-O-IMPORT-API-START /////////////////////////////////

  static String R_O_IMPORT_ON_LOAD = "$BASE_URL/api/ROImport/OnRoImportLoad";
  static String R_O_IMPORT_ON_LEAVE_LOCATION(String code) =>
      "$BASE_URL/api/ROImport/OnLeaveLocation?LocationCode=$code";
  static String R_O_IMPORT_IMPORT_CLICK = "$BASE_URL/api/ROImport/ImportClick";
  static String R_O_IMPORT_IMPORT_SAVE =
      "$BASE_URL/api/ROImport/SaveROImportData";
  // static String FILLER_MASTER_BANNER_SEARCH = "$BASE_URL/api/FillerMaster/GetSourceBannerSearch?TextSourceBanner=";
  // static String FILLER_MASTER_RETRIVE_RECORDS = "$BASE_URL/api/FillerMaster/RetriveRecords";
  // static String FILLER_MASTER_SEGNO_LEAVE = "$BASE_URL/api/FillerMaster/SegNoLeave";
  // static String FILLER_MASTER_GET_EVENT = "$BASE_URL/api/FillerMaster/GetEvent?text=";
  // static String FILLER_MASTER_TAPE_ID_LEAVE = "$BASE_URL/api/FillerMaster/TapeIDLeave";

  //////////////////////////////// R-O-IMPORT-API-END /////////////////////////////////
  ///
  ///
  ///
  ///
  //////////////////////////////// PROMO-MASTER-API-START /////////////////////////////////

  static String get PROMO_MASTER_ON_LOAD =>
      "$BASE_URL/api/PromoMaster/PromoMasterOnLoad";
  static String PROMO_MASTER_ON_LEAVE_LOCATION(String code) =>
      "$BASE_URL/api/PromoMaster/onLeaveLocation?LocationCode=$code";
  static String get PROMO_MASTER_COMPANY_SEARCH =>
      "$BASE_URL/api/PromoMaster/GetSourceCompanySearch?TextSourceCompany=";
  static String get PROMO_MASTER_PROGRAM_SEARCH =>
      "$BASE_URL/api/PromoMaster/GetSourceProgramSearch?TextSourceProgram=";
  static String get PROMO_MASTER_GET_PROGRAM_PICKER =>
      "$BASE_URL/api/PromoMaster/GetProgramPicker";
  static String PROMO_MASTER_GET_PROMO_TYPE(String code) =>
      "$BASE_URL/api/PromoMaster/GetPromoType?PromoCategoryCode=$code";
  static String get PROMO_MASTER_EVENT_SEARCH =>
      "$BASE_URL/api/PromoMaster/GetEvent?text=";
  static String get PROMO_MASTER_RETRIVE_RECORDS =>
      "$BASE_URL/api/PromoMaster/GetRetrieveRecord";
  static String get PROMO_MASTER_TX_NO_LEAVE =>
      "$BASE_URL/api/PromoMaster/GetCartNo_Leave";
  static String get PROMO_MASTER_SAVE_RECORD =>
      "$BASE_URL/api/PromoMaster/SaveRecord";
  static String PROMO_MASTER_BLANK_TAPE_ID_LEAVE(String code) =>
      "$BASE_URL/api/PromoMaster/OnLeaveBlankTapeId?BlankTapeId=$code";
  // static String PROMO_MASTER_BANNER_SEARCH = "$BASE_URL/api/FillerMaster/GetSourceBannerSearch?TextSourceBanner=";
  // static String PROMO_MASTER_SAVE = "$BASE_URL/api/FillerMaster/SaveRecord";
  // static String PROMO_MASTER_SEGNO_LEAVE = "$BASE_URL/api/FillerMaster/SegNoLeave";
  // static String PROMO_MASTER_GET_EVENT = "$BASE_URL/api/FillerMaster/GetEvent?text=";

  //////////////////////////////// PROMO-TYPE-MASTER-API-END /////////////////////////////////

  static String PROMO_TYPE_MASTER_GET_RECORD(promoName, promoCode) =>
      "$BASE_URL/api/PromoTypeMaster/GetRetrieveRecord?PromoTypeCode=$promoCode&PromoTypeName=$promoName";
  static String PROMO_TYPE_MASTER_SAVE =
      "$BASE_URL/api/PromoTypeMaster/PostValidateAndSaveRecord";
  static String get PROMO_TYPE_MASTER_GET_CATEGORY =>
      "$BASE_URL/api/PromoTypeMaster/GetPromoCategory";
  static String PROMO_TYPE_MASTER_VALIDATE_SAVE_RECORD =
      "$BASE_URL/api/PromoTypeMaster/ValidationPopUp";

  //////////////////////////////// ASRUN IMPORT /////////////////////////////////
  static String AsrunImport_GetLoadLocation =
      "$BASE_URL/api/AsrunImport/GetLoadLocation";
  static String AsrunImport_GetLocationSelect(locationCode) =>
      "$BASE_URL/api/AsrunImport/GetLocationSelect?Locationcode=$locationCode";
  static String AsrunImport_LoadFPCData(
          locationCode, channelCode, telecastDate) =>
      "$BASE_URL/api/AsrunImport/LoadFPCData?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$telecastDate";
  static String AsrunImport_UpdateFPCMismatch(
          locationCode, channelCode, telecastDate) =>
      "$BASE_URL/api/AsrunImport/UpdateProgramMismatch?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$telecastDate";
  static String AsrunImport_LoadRunData(
          locationCode, channelCode, telecastDate) =>
      "$BASE_URL/api/AsrunImport/LoadAsRunData?LocationCode=$locationCode&ChannelCode=$channelCode&LogDate=$telecastDate";
  static String AsrunImport_UpdateFPCTime =
      "$BASE_URL/api/AsrunImport/UpdateFPCTime";
  static String AsrunImport_GetChannelCode =
      "$BASE_URL/api/AsrunImport/GetChannelCode";
  static String AsrunImport_LoadImportSpecifications(
          String locationCode, String channelCode) =>
      "$BASE_URL/api/AsrunImport/LoadImportSpecifications?LocationCode=$locationCode&ChannelCode=$channelCode";

  static String AsrunImport_CheckSapBillingStatus(
          String locationCode, String channelCode, String telecastDate) =>
      "$BASE_URL/api/AsrunImport/CheckSapBillingStatus?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$telecastDate";

  static String AsrunImport_CheckMissingAsRun =
      "$BASE_URL/api/AsrunImport/CheckMissingAsRun";
  static String AsrunImport_GetAsrunProgramList =
      "$BASE_URL/api/AsrunImport/GetAsrunProgramList?ProgramName=";
  static String AsrunImport_GetDeleteStatus =
      "$BASE_URL/api/AsrunImport/GetDeleteStatus";
  static String AsrunImport_SaveAsrunDetail =
      "$BASE_URL/api/AsrunImport/SaveAsrunDetail";
  static String AsrunImport_SaveTempDetail =
      "$BASE_URL/api/AsrunImport/SaveTempDetail";
  static String AsrunImport_AsunOnImport =
      "$BASE_URL/api/AsrunImport/AsrunOnImport";
  static String AsrunImport_CheckProgramSequence =
      "$BASE_URL/api/AsrunImport/CheckProgramSequence";
  static String GFKCheck = "$BASE_URL/api/AsrunImport/GFKCheck";
  static String AsrunImport_FileFormat(locationCode, channelCode, date) =>
      "$BASE_URL/api/AsrunImport/FileFormat?LocationCode=$locationCode&ChannelCode=$channelCode&LogDate=$date";
  ////////////////////////////// Audit Status ////////////////////////////////////////
  static String NewBookingActivityReport_GetLoadLocation =
      "$BASE_URL/api/NewBookingActivityReport/location";
  static String NewBookingActivityReport_cbolocationLeave(
          String locationCode) =>
      "$BASE_URL/api/NewBookingActivityReport/cbolocation_Leave?LocationCode=$locationCode";
  static String NewBookingActivityReport_Getshowdeal =
      "$BASE_URL/api/NewBookingActivityReport/Getshowdeal";
  static String NewBookingActivityReport_GetShowEbooking =
      "$BASE_URL/api/NewBookingActivityReport/GetShowEbooking";
  static String NewBookingActivityReport_CancelDisplayDetails =
      "$BASE_URL/api/NewBookingActivityReport/CancelDisplayDetails";
  static String NewBookingActivityReport_GetShowECancel =
      "$BASE_URL/api/NewBookingActivityReport/GetShowECancel";
  static String NewBookingActivityReport_RescheduleDisplay =
      "$BASE_URL/api/NewBookingActivityReport/RescheduleDisplay";
  static String NewBookingActivityReport_ShowEReschedule =
      "$BASE_URL/api/NewBookingActivityReport/ShowEReschedule";

  static String NewBookingActivityReport_BtnShow =
      "$BASE_URL/api/NewBookingActivityReport/BtnShow";
  static String NewBookingActivityReport_Refresh =
      "$BASE_URL/api/NewBookingActivityReport/Refresh";

  /*static String RO_BOOKING_GetClientPDC =
      "$BASE_URL/api/ROBooking/GetClientPDC";*/

  //////////////////////////////////////// Commercial Tape Master //////////////////////////////

  static String COMMERCIAL_MASTER_ALLDROPDOWN =
      BASE_URL + "/api/CommercialTapeMaster/PageOnLoadData";
  static String COMMERCIAL_MASTER_GETSECTYPE =
      BASE_URL + "/api/CommercialTapeMaster/GetSecType?RevenueCode=";
  static String COMMERCIAL_MASTER_GETCLIENTDETAILS =
      BASE_URL + "/api/CommercialTapeMaster/ClientDetails?clientName=";
  static String COMMERCIAL_MASTER_GETAGENCYBRAND = BASE_URL +
      "/api/CommercialTapeMaster/AgencyBrandTypeForClient?clientCode=";
  static String COMMERCIAL_MASTER_GETLEVELSDETAILS =
      BASE_URL + "/api/CommercialTapeMaster/LevelsDetails?BrandCode=";
  static String COMMERCIAL_MASTER_GETLEVENT =
      BASE_URL + "/api/CommercialTapeMaster/Events?Event=";
  static String COMMERCIAL_MASTER_VALIDATE_TXNO =
      BASE_URL + "/api/CommercialTapeMaster/ValidateTxNo";
  static String COMMERCIAL_MASTER_GET_AGENCYDETAILS =
      BASE_URL + "/api/CommercialTapeMaster/AgencyDetails";
  static String COMMERCIAL_MASTER_GET_TAPID(
          String revenueCode, String secTypeId) =>
      "$BASE_URL/api/CommercialTapeMaster/GetTapeId?RevenueCode=$revenueCode&SecTypeId=$secTypeId";
  static String COMMERCIAL_MASTER_GET_COMMERCIALTAPEMASTER =
      BASE_URL + "/api/CommercialTapeMaster/CommercialTapeMasterData";
  static String COMMERCIAL_MASTER_SAVE_COMMERCIALTAPE =
      BASE_URL + "/api/CommercialTapeMaster/CommercialTapeSave";

//////////////////////////////// Sales Audit Not Select Report ///////////////////////////////////////////

  static String SALESAUDIT_NOT_TELECASTLOAD =
      BASE_URL + "/api/SalesAuditNotTR/SalesauditnottelecastLoad";
  static String SALESAUDIT_NOT_TELECAST_GETGENERATE =
      BASE_URL + "/api/SalesAuditNotTR/GetGenrate";

  /////////////////////////////////// Sales Audit New ////////////////////////////////

  static String SALESAUDIT_NEW_LOAD =
      BASE_URL + "/api/SalesAduitNew/GetLocations";
  static String SALESAUDIT_NEW_GETCHANNEL =
      BASE_URL + "/api/SalesAduitNew/GetChannels?LocationCode=";
  static String SALESAUDIT_NEW_SAVEDATA =
      BASE_URL + "/api/SalesAduitNew/PostSalesAduit";
  static String SALESAUDIT_NEW_GETRETRIEVE(
          String locationCode, String channelCode, String scheduleDate) =>
      BASE_URL +
      "/api/SalesAduitNew/GetRetrieve?Locationcode=$locationCode&channelcode=$channelCode&date=$scheduleDate";

  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////DSeries Specification/////////////////////////
  static String DSERIES_SPECIFICATION_LOAD =
      BASE_URL + "/api/DSeriesSpecification/GetDSeriesSpecsLoad";
  static String DSERIES_SPECIFICATION_CHANNEL(String locId) =>
      BASE_URL + "/api/DSeriesSpecification/GetChannelList?LocationCode=$locId";
  static String DSERIES_SPECIFICATION_CHANNEL_LEAVE(
          String locId, String chnlId) =>
      BASE_URL +
      "/api/DSeriesSpecification/GetChannelsLeave?LocationCode=$locId&channelcode=$chnlId";
  static String DSERIES_SPECIFICATION_SAVE =
      BASE_URL + "/api/DSeriesSpecification/postSave";
  static String DSERIES_SPECIFICATION_SEARCH =
      BASE_URL + "/api/DSeriesSpecification/Search";
  ////////////////////////DSeries Specification- END/////////////////////////

  // ////////////////////Europe Commercial Import Status/////////////////////////
  static String EUROPE_COMMERCIAL_GENERATE(String date) =>
      BASE_URL +
      "/api/EuropeCommercialImportStatus/GetGenrate?effectivedate=$date";
  ////////////////////////Europe Commercial Import Status- END/////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  // ////////////////////LANGAUGE-MASTER-START/////////////////////////
  static String LANGAUGE_MASTER_LANGAUGE_NAME_LEAVE =
      "$BASE_URL/api/LanguageMaster/GetRetrieveRecord";
  static String LANGAUGE_MASTER_SAVE_RECORD =
      "$BASE_URL/api/LanguageMaster/PostValidateAndSaveRecord";
  ////////////////////////LANGAUGE-MASTER-END/////////////////////////
  ///
  ///
  ///
  // ////////////////////INVENTORY-STATUS-REPORT/////////////////////////
  static String get INVENTORY_STATUS_REPORT_ON_LOAD =>
      "$BASE_URL/api/InventoryStatusReport/GetInventoryutilizationLoad";
  static String INVENTORY_STATUS_REPORT_GENERATE =
      "$BASE_URL/api/InventoryStatusReport/GetGenrate";
  ////////////////////////INVENTORY-STATUS-REPORT/////////////////////////
  ///
  ///
  ///
  ///
  ///
  // ////////////////////MANAGE-CHANNEL-INVENTORY/////////////////////////
  static String get MANAGE_CHANNEL_INV_ON_LOAD =>
      "$BASE_URL/api/ManageChannelInventory/GetLocation";
  static String get MANAGE_CHANNEL_INV_SAVE_TODAY_ALL_DATA =>
      "$BASE_URL/api/ManageChannelInventory/SaveTodayAndAllData";
  static String get MANAGE_CHANNEL_INV_PROGRAM_SEARCH =>
      "$BASE_URL/api/ManageChannelInventory/ProgramSearch";
  static String get MANAGE_CHANNEL_INV_SAVE_SPECIAL =>
      "$BASE_URL/api/ManageChannelInventory/SaveSpecial";
  static String MANAGE_CHANNEL_INV_LEAVE_LOCATION(
          String locationCode, String loginCode) =>
      "$BASE_URL/api/ManageChannelInventory/GetChannel?LocationCode=$locationCode&LoginCode=$loginCode";
  static String MANAGE_CHANNEL_INV_DISPLAY_DATA(
          String locationCode, String channelCode, String date) =>
      "$BASE_URL/api/ManageChannelInventory/Display?LocationCode=$locationCode&ChannelCode=$channelCode&EffectiveDate=$date";
  ////////////////////////MANAGE-CHANNEL-INVENTORY/////////////////////////
  ///
  ///
  ///
  ///
  // ////////////////////EXTRA-SPOT-WITH-REMARK/////////////////////////
  static String get EXTRA_SPOT_WITH_REVIEW_ON_LOAD =>
      "$BASE_URL/api/ExtraSpotsReport/ExtraspotswithremarkLoad";
  static String EXTRA_SPOT_WITH_REVIEW_REPORT_GENERATE(
          String? location, String? channel, String fromDate, String toDate) =>
      "$BASE_URL/api/ExtraSpotsReport/Getbtngenrate?locationcode=$location&channelcode=$channel&fdate=$fromDate&tdate=$toDate";
  ////////////////////////EXTRA-SPOT-WITH-REMARK/////////////////////////
  ///
  ///
  ///
  ///
  ///
  //////////////////////// SearchTapeCode //////////////////
  static String SearchTapeCode(exportTapeCode, programName, epsCaption) =>
      BASE_URL +
      "/api/SearchTapeCode/GetbtnShowClick?ExportTapeCode=$exportTapeCode&ProgramName=$programName&EpsCaption=$epsCaption";
  //////////////////////// Spot Position Type Master ///////////////

  static String SpotPositionTypeInit =
      BASE_URL + "/api/SpotPositionType/GetTypeMasterLoad";
  static String SpotPositionTypeGetRecord(sponserCode, sponserName) =>
      BASE_URL +
      "/api/SpotPositionType/GetRetrieveRecord?SpotPositionTypeCode=$sponserCode&SpotPositionTypeName=$sponserName";
  static String SpotPositionTypeSaveRecord =
      BASE_URL + "/api/SpotPositionType/PostSaveRecord";

  ////////////////////// SecondaryEventTemplateMaster ///////////////////////////////////
  static String SponserTypeMasterGetRecord(sponserCode, sponserName) =>
      BASE_URL +
      "/api/SponsorTypeMaster/GetRetrieveRecord?SponsorTypeCode=$sponserCode&SponsorTypeName=$sponserName";
  static String SponserTypeMasterSaveRecord =
      BASE_URL + "/api/SponsorTypeMaster/PostSave";
  ////////////////////// SecondaryEventTemplateMaster ///////////////////////////////////

  static String SecondaryEventTemplateMasterInitData =
      BASE_URL + "/api/SecondaryEventTemplateMaster/GetInitialisation";
  static String SecondaryEventTemplateMasterGetChannel(
    locCode,
  ) =>
      BASE_URL +
      "/api/SecondaryEventTemplateMaster/GetLocationSelect?LocationCode=$locCode";
  static String SecondaryEventTemplateMasterProgSearch = BASE_URL +
      "/api/SecondaryEventTemplateMaster/GetSourceProgramSearch?TextSourceProgram=";
  static String SecondaryEventTemplateMasterGetCopy(
          locCode, channelCode, progCode) =>
      BASE_URL +
      "/api/SecondaryEventTemplateMaster/GetCopy?locationcode=$locCode&channelcode=$channelCode&ProgramCode=$progCode";
  static String SecondaryEventTemplateMasterGetProgramPicker(
          locCode, channelCode) =>
      BASE_URL +
      "/api/SecondaryEventTemplateMaster/GetProgramPicker?locationcode=$locCode&channelcode=$channelCode";
  static String SecondaryEventTemplateMasterGetProgramLeave(
          locCode, channelCode, progCode) =>
      BASE_URL +
      "/api/SecondaryEventTemplateMaster/GetProgramLeave?locationcode=$locCode&channelcode=$channelCode&ProgramCode=$progCode";
  static String SecondaryEventTemplateMasterFastProgSearch =
      BASE_URL + "/api/SecondaryEventTemplateMaster/PostFastInsertsearch";
  static String SecondaryEventTemplateMasterSave =
      BASE_URL + "/api/SecondaryEventTemplateMaster/PostSave";

  ///////////////////////////////////////////////////////////

  ///////////////////////Europe Drop Spots////////////////////
  static String EUROPE_DROP_SPOTS_INITIAL() =>
      BASE_URL + "/api/EuropeDropSpots/GetInitial";
  static String EUROPE_DROP_SPOTS_UPDATE_DETAILS() =>
      BASE_URL + "/api/EuropeDropSpots/Updatedtail";
  static String EUROPE_DROP_SPOTS_GETRUNDATE(
          String loc, String chanl, String bookEffectDt) =>
      BASE_URL +
      "/api/EuropeDropSpots/Getrundate?locationcode=$loc&channelcode=$chanl&BookingEffectiveDate=$bookEffectDt";
  static String EUROPE_DROP_SPOTS_POST_REMOVE_FILE() =>
      BASE_URL + "/api/EuropeDropSpots/PostRemovefile";
  static String EUROPE_DROP_SPOTS_CHANNEL(String loc, String chnl) =>
      BASE_URL +
      "/api/EuropeDropSpots/GetChannel?locationcode=$loc&channelcode=$chnl";
  static String EUROPE_DROP_SPOTS_CLIENT(
          String loc, String chnl, String client) =>
      BASE_URL +
      "/api/EuropeDropSpots/GetClient?locationcode=$loc&channelcode=$chnl&clientcode=$client";
  static String EUROPE_DROP_SPOTS_GENERATE() =>
      BASE_URL + "/api/EuropeDropSpots/Getgenerate";
  static String EUROPE_DROP_SPOTS_LOCATION(String loc) =>
      BASE_URL + "/api/EuropeDropSpots/cbolocation?LocationCode=$loc";
  static String EUROPE_DROP_SPOTS_DELETE() =>
      BASE_URL + "/api/EuropeDropSpots/Deletecommercial";
  //////////////////////////End Drop Spots/////////////////////////////////

  //////////////////////////////// ComingUpNextMaster ///////////////////////////////////////

  static String COMINGUPNEXTMASTER_NEW_LOAD =
      BASE_URL + "/api/ComingUpNextMaster/GetLocationSelect";
  static String COMINGUPNEXTMASTER_GET_CHANNEL =
      BASE_URL + "/api/ComingUpNextMaster/GetChannel?LocationCode=";
  static String COMINGUPNEXTMASTER_GET_RETRIVE_RECORD =
      BASE_URL + "/api/ComingUpNextMaster/RetrieveRecord";
  static String COMINGUPNEXTMASTER_SAVE =
      BASE_URL + "/api/ComingUpNextMaster/SaveComingUpNext";
  static String COMINGUPNEXTMASTER_TAPEIDLEAVE =
      BASE_URL + "/api/ComingUpNextMaster/TapeIDLeave";
  static String COMINGUPNEXTMASTER_SEGNOLEAVE =
      BASE_URL + "/api/ComingUpNextMaster/SegNoLeave";
  static String COMINGUPNEXTMASTER_HOUSEIDLEAVE =
      BASE_URL + "/api/ComingUpNextMaster/HouseIDLeave";
  static String COMINGUPNEXTMASTER_PROGRAMSEARCH = BASE_URL +
      "/api/ComingUpNextMaster/GetSourceProgramSearch?TextProgramCompany=";

  //////////////////////////// ComingUpTomorrowMenu ////////////////////////////////

  static String COMINGUPTOMORROWMASTER_LOAD =
      BASE_URL + "/api/ComingUpTomorrowMenu/ComingUpTomorrowOnload";
  static String COMINGUPTOMORROWMASTER_GETCHANNEL_LIST =
      BASE_URL + "/api/ComingUpTomorrowMenu/GetChannelSelect?LocationCode=";
  static String COMINGUPTOMORROWMASTER_RETRIVERECORD =
      BASE_URL + "/api/ComingUpTomorrowMenu/GetCTRetriveRecord";
  static String COMINGUPTOMORROWMASTER_TAPEIDLEAVE =
      BASE_URL + "/api/ComingUpTomorrowMenu/TapeIDOnLeave";
  static String COMINGUPTOMORROWMASTER_SEGNOLEAVE =
      BASE_URL + "/api/ComingUpTomorrowMenu/GetSegNoOnLeave";
  static String COMINGUPTOMORROWMASTER_HOUSEIDLEAVE =
      BASE_URL + "/api/ComingUpTomorrowMenu/GetHouseIDOnLeave";
  static String COMINGUPTOMORROWMASTER_SAVE =
      BASE_URL + "/api/ComingUpTomorrowMenu/SaveComingUpTomorrowData";
  static String COMINGUPTOMORROWMASTER_PROGRAMTYPELOSTFOCUS = BASE_URL +
      "/api/ComingUpTomorrowMenu/GetcboProgramTypeLostFocus?ProgramTypeCode=";

  ////////////////////////////// ComingUpMenuMaster ////////////////////////////////
  static String COMING_UP_MENU_MASTER_LOAD =
      BASE_URL + "/api/ComingUpMenuMaster/LocationLoad";
  static String COMING_UP_MENU_MASTER_CHANNELLIST =
      BASE_URL + "/api/ComingUpMenuMaster/ChannelLoad?LocationCode=";
  static String COMING_UP_MENU_MASTER_GET_RETRIVERECORD =
      BASE_URL + "/api/ComingUpMenuMaster/RetriveRecord";
  static String COMING_UP_MENU_MASTER_SAVE =
      BASE_URL + "/api/ComingUpMenuMaster/PostComingUpMenu";
  static String COMING_UP_MENU_MASTER_TAPEIDLEAVE =
      BASE_URL + "/api/ComingUpMenuMaster/GetTapeIDLeave";
  static String COMING_UP_MENU_MASTER_SEGLNOLEAVE =
      BASE_URL + "/api/ComingUpMenuMaster/GetSegNoLeave";
  static String COMING_UP_MENU_MASTER_HOUSEIDLEAVE =
      BASE_URL + "/api/ComingUpMenuMaster/GetHouseIDLeave";

  ////////////////////////////////////////// DateWiseFillers ////////////////////////////

  static String DATEWISEFILLER_LOAD =
      BASE_URL + "/api/DatewiseFillerReport/GetInit";
  static String DATEWISEFILLER_GENERATE =
      BASE_URL + "/api/DatewiseFillerReport/GetGenrate";

  /////////////////////////////////////// DateWiseErrorSpots ////////////////////////////
  static String DATEWISEERROR_LOAD =
      BASE_URL + "/api/DatewiseErrorSpots/GetInit";
  static String DATEWISEERROR_GENERATE =
      BASE_URL + "/api/DatewiseErrorSpots/GetGenrateErrors";

  //////////////////////////////////////////////// BRANDMASTER /////////////////////////

  static String BRANDMASTER_GETCLIENT =
      BASE_URL + "/api/BrandMaster/GetClientSearch?TextSourceClient=";
  static String BRANDMASTER_GETPRODUCT =
      BASE_URL + "/api/BrandMaster/GetProductSearch?TextSourceProduct=";
  static String BRANDMASTER_GETBRAND =
      BASE_URL + "/api/BrandMaster/RetriveRecords?BrandName=";
  static String BRANDMASTER_GETCLIENTDETAILS =
      BASE_URL + "/api/BrandMaster/GetClientDetails?clientname=";
  static String BRANDMASTER_GETPRODUCTDETAILS =
      BASE_URL + "/api/BrandMaster/GetProduct?productcode=";
  static String BRANDMASTER_SAVE = BASE_URL + "/api/BrandMaster/PostBrandAdd";
  static String BRANDMASTER_ONLOAD =
      BASE_URL + "/api/BrandMaster/GetBrandonLoad";
  ///////////////////////////////// New Short Content Form /////////////////////////////////////
  static String NEW_SHORT_CONTENT_INIT =
      "$BASE_URL/api/ShortCode/OnLoadShortCode";
  static String NEW_SHORT_CONTENT_GetVignetee =
      "$BASE_URL/api/ShortCode/GetVigneteeTypeMaster";
  static String NEW_SHORT_CONTENT_GetStillTypeMaster =
      "$BASE_URL/api/ShortCode/GetStillTypeMaster";
  static String NEW_SHORT_CONTENT_GetSlideTypeMaster =
      "$BASE_URL/api/ShortCode/GetSlideTypeMaster";

  static String NEW_SHORT_CONTENT_LOCATION_LEAVE(locationCode) =>
      "$BASE_URL/api/ShortCode/OnLeaveLocation?LocationCode=$locationCode";
  static String NEW_SHORT_CONTENT_Type_LEAVE(formCode) =>
      "$BASE_URL/api/ShortCode/OnLeaveType?FormCode=$formCode";
  static String NEW_SHORT_CONTENT_Program_Search =
      "$BASE_URL/api/ShortCode/OnFillComboProgram?TextSourceProgram=";
  static String NEW_SHORT_CONTENT_HOUSEID_LEAVE(
          houseCode, ShortName, StrCode) =>
      "$BASE_URL/api/ShortCode/HouseIDOnLeave?HouseID=$houseCode&TextBoxShortName=$ShortName&strCode=$StrCode";
  static String NEW_SHORT_CONTENT_SAVE = "$BASE_URL/api/ShortCode/SaveRecords";
  static String NEW_SHORT_CONTENT_RETRIEVE(
          locationCode, channelCode, formCode, houseId, segmentNumber) =>
      "$BASE_URL/api/ShortCode/GetRetrivedRecords?LocationCode=$locationCode&ChannelCode=$channelCode&FormCode=$formCode&HouseId=$houseId&SegmentNumber=$segmentNumber";

  ////////////////////////////////////////////////////////////////////////////////////////
}
