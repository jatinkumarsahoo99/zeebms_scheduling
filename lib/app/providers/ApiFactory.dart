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
  static String Enviroment = const String.fromEnvironment('ENV', defaultValue: 'dev');
  // static String SERVER_URL = "https://bmswebfrontend-uat.azurewebsites.net";
  static String WEB_URL = Enviroment.toLowerCase() == "uat" ? "https://app-admin-bms-uat.zeeconnect.in" : "https://app-admin-bms-dev.zeeconnect.in";
  static String WEB_URL_COMMON =
      Enviroment.toLowerCase() == "uat" ? "https://app-common-bms-uat.zeeconnect.in" : "https://app-common-bms-dev.zeeconnect.in";

  static String BASE_URL = Enviroment.toLowerCase() == "uat" ? "https://api-admin-bms-uat.zeeconnect.in" : "https://api-admin-bms-dev.zeeconnect.in";
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

  ////////////////////// SEARCH ////////////////////////////
  ///
  ///

  static String SEARCH_SEND_NAME(
    String mail,
    String pageName,
  ) {
    var currentDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateTime.now());
    return "$BASE_URL_COMMON/api/MDI/SaveApplicationPagesFootprintData?UserName=$mail&PageName=$pageName&AccessDate=$currentDate";
  }

  static String SEARCH_VARIANCE({required String viewName, required String screenName, required String loginCode}) {
    // return BASE_URL + "/api/$screenName/SearchVariance/$viewName";
    return "$BASE_URL_COMMON/api/CommonSearch/SearchVariance/$viewName";
  }

  static String SEARCH_BINDGRID({required String viewName, required String screenName, required String code}) {
    // return BASE_URL + "/api/$screenName/BindGrid/$viewName,$code";
    return "$BASE_URL_COMMON/api/CommonSearch/BindGrid/$viewName,$code";
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
    return "$BASE_URL_COMMON/api/CommonSearch/TextSearch?name=$name&valuecolumnname=$valuecolumnname&TableName=$TableName&chkLikeNotLike=$chkLikeNotLike&searchvalue=$searchvalue";
  }

  static String SEARCH_EXECUTE_SEARCH({
    required String strViewName,
    required String loginCode,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/SearchExecute?strViewName=$strViewName";
    return "$BASE_URL_COMMON/api/CommonSearch/SearchExecute?strViewName=$strViewName";
  }

  // static String SEARCH_PIVOT({required String screenName,}) => BASE_URL + "/api/$screenName/SearchPivot";
  static String SEARCH_PIVOT({
    required String screenName,
  }) =>
      "$BASE_URL_COMMON/api/CommonSearch/SearchPivot";

  // static String SEARCH_EXCUTE_PIVOT({required String screenName, required String strViewname,}) => BASE_URL + "/api/$screenName/SearchExecutePivot?strViewName=$strViewname";
  static String SEARCH_EXCUTE_PIVOT({
    required String screenName,
    required String strViewname,
  }) =>
      "$BASE_URL_COMMON/api/CommonSearch/SearchExecutePivot?strViewName=$strViewname";

  static String ADD_SEARCH_VARIANCE({
    required String strViewName,
    required String loginCode,
    required String screenName,
    required String sVariant,
    // required String pivotTemplate,
  }) {
    // return BASE_URL + "/api/$screenName/InsertSearchVariance?strViewName=$strViewName&sVariant=$sVariant";
    return "$BASE_URL_COMMON/api/CommonSearch/InsertSearchVariance?strViewName=$strViewName&sVariant=$sVariant";
  }

  static String DELETE_SEARCH_VARIANCE({
    required String varianceId,
    required String loginCode,
    required String screenName,
  }) {
    // return BASE_URL + "/api/$screenName/DeleteSearchVariance?VarianceId=$varianceId";
    return "$BASE_URL_COMMON/api/CommonSearch/DeleteSearchVariance?VarianceId=$varianceId";
  }

  /////////////////////////////////////////////////////////
  //////////////////////////// Link Song To Program Template /////////////////////////////////

  static String LINK_PROGRAM_TO_SONG_GET_LOCATION = "$BASE_URL/api/LinkProgramToSongTemplate/GetLocationListForUser";

  static String LINK_PROGRAM_TO_SONG_GET_CHANNEL({
    required String locationCode,
  }) {
    return "$BASE_URL/api/LinkProgramToSongTemplate/GetChannelListForUserAndLocation?LocationCode=$locationCode";
  }

  static String LINK_PROGRAM_TO_SONG_GetProgramSongTemplate({
    required String locationCode,
    required String channelCode,
    required String fromDate,
    required String toDate,
  }) {
    return "$BASE_URL/api/LinkProgramToSongTemplate/GetProgramSongTemplate?LocationCode=$locationCode&ChannelCode=$channelCode&FromDate=$fromDate&ToDate=$toDate";
  }

  static String LINK_PROGRAM_TO_SONG_SAVE = "$BASE_URL/api/LinkProgramToSongTemplate/Save";

///////////////////////////////////////////////////////////////////////////////////////////
////////////////////////// Create Break Pattern ///////////////////////////////////////////
  static String CREATE_BREAK_PATTERN_INIT = "$BASE_URL/api/CreateBreakPattern/Initialize";

  static String CREATE_BREAK_PATTERN_GET_CHANNEL({
    required String locationCode,
  }) {
    return "$BASE_URL/api/CreateBreakPattern/GetChannelListForUserAndLocation?locationCode=$locationCode";
  }

  static String CREATE_BREAK_PATTERN_GET_DATA({
    required String locationCode,
    required String channelCode,
    required String fromDate,
    required String toDate,
  }) {
    return "$BASE_URL/api/CreateBreakPattern/OnToDateSelected?LocationCode=$locationCode&ChannelCode=$channelCode&FromDate=$fromDate&ToDate=$toDate";
  }

  static String CREATE_BREAK_PATTERN_UPDATE_TRANSTIME({
    required String dayStart,
    required int? commercialTime,
    required bool updateStatus,
  }) {
    return "$BASE_URL/api/CreateBreakPattern/UpdateTransmissionTime?DayStart=$dayStart&CommercialTime=${commercialTime ?? ""}&UpdateStatus=$updateStatus";
  }

  static String CREATE_BREAK_PATTERN_MultiAggregate = "$BASE_URL/api/CreateBreakPattern/MultiAggregate";
  static String CREATE_BREAK_PATTERN_SAVE_SEGMENTS = "$BASE_URL/api/CreateBreakPattern/SaveSegment";
  static String CREATE_BREAK_PATTERN_SAVE_BREAK_PATTERN = "$BASE_URL/api/CreateBreakPattern/Save";

  static String CREATE_BREAK_PATTERN_BREAK_FILE({
    required String locationCode,
    required String channelCode,
    required String fromDate,
    required String toDate,
  }) {
    return "$BASE_URL/api/CreateBreakPattern/Break?LocationCode=$locationCode&ChannelCode=$channelCode&FromDate=$fromDate&ToDate=$toDate";
  }

//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////Pending TC & Technical Check: UI: Sanjaya Jena API: Patta Nigam////////////////////////////////////////////////////////////////////////

  static String PENDING_TC_MASTER = "$BASE_URL/api/TechnicalCheck/PendingTCInfo?PersonnelNo=";

  static String PENDING_TC_LIST({required String frmDt, required String toDt, required String contentType, String? branchCode}) {
    return "$BASE_URL/api/TechnicalCheck/PendingTCList/$frmDt,$toDt,$contentType,$branchCode";
  }

  static String TECHNICAL_CHECK_MASTER = "$BASE_URL/api/TechnicalCheck/GetInfoLoad/0";

// START --> Contnet Inward

  static String CI_DASHBOARD_INTIAL_DATA = "$BASE_URL/api/cidashboard/GetInit?PersonnelNo=";

  static String CI_DASHBOARD_PROGRAM_SEARCH = "$BASE_URL/api/cidashboard/GetProgram?search=";

  static String CI_DASHBOARD_PROGRAM_SEARCH1 = "$BASE_URL/api/cidashboard/GetProgram1?search=";

  static String CI_DASHBOARD_REPORT = "$BASE_URL/api/cidashboard/GetReport";

  static String CI_INWARD_INTIAL_DATA = "$BASE_URL/api/ciInward/Initialise";

  static String CI_INWARD_DATA = "$BASE_URL/api/ciInward/GetInwardDetails?InwardCode=";
  static String TECHNICAL_CHECK_SAVE = "$BASE_URL/api/TechnicalCheck/TCSave";

  static String TECHNICAL_CHECK_GET_TC_DATA = "$BASE_URL/api/TechnicalCheck/TCNoSelect";

  static String TECHNICAL_CHECK_GET_FAULTDESC = "$BASE_URL/api/TechnicalCheck/FaultCategorySelect";

  static String TECHNICAL_CHECK_MASTER1(
      {required String programName, required String contentType, required String epNo, required String inWardCode}) {
    return "$BASE_URL/api/TechnicalCheck/InfoPopulate?ProgramName=$programName&ContentType=$contentType&EpisodeNumber=$epNo&InwardCode=$inWardCode";
  }

////////////////////////////////////////////////////End Pending TC & Technical Check//////////////////////////////////////////////////////////

  static String CI_BMS_PH_DATA = "$BASE_URL/api/ciInward/GetPHAndBMSProgram?ProgramCode=";

  static String CI_DASHBOARD_SENDMAIL({
    required int tcNo,
    required String tcStatus,
    required bool resendmail,
  }) {
    return "${BASE_URL}api/cidashboard/SendEmail?TCNo=$tcNo&TCStatus=$tcStatus&ResendMail=$resendmail";
  }

  static String CI_SAVE_FORM = "$BASE_URL/api/ciInward/Save";

// END --> Contnet Inward

  /////////////////////////////////////////////////////////////////////////////////////////

  ////////////////Operatonal FPC Page: UI-> Shreesh Tiwari API-> Ram P Kubde//////////////

  static String OPERATIONAL_FPC_INITIAL_DATA({required String loginId}) {
    return "$BASE_URL/api/DailyFPCReport/DailyFPCInitialise?Userid=$loginId";
  }

  static String OPERATIONAL_FPC_GET_CHANNELS_ON_LOCATION_SELECT({required String loginCode, required String location}) {
    return "$BASE_URL/api/DailyFPCReport/GetChannelAfterLoctionLoad?Userid=$loginCode&LocationCode=$location";
  }

  static String OPERATIONAL_FPC_PROGRAM_SEARCH = "$BASE_URL/api/DailyFPCReport/ProgramSearch?SearchText=";

  static String OPERATIONAL_FPC_DAILY_FPC_LIST({required String locationCode, required String channelCode, required String date}) {
    return '$BASE_URL/api/dailyfpcreport/DailyFpcByDateString?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date';
  }

  static String OPERATIONAL_FPC_SEGMENT_LIST({required String locationCode, required String channelCode, required String fpcDuration}) {
    return '$BASE_URL/api/dailyfpcreport/GetBarbDefaultSegment?LocationCode=$locationCode&ChannelCode=$channelCode&FPCDuration=$fpcDuration';
  }

  // static String OPERATIONAL_FPC_SEGMENT_LIST1(
  //     {required String locationCode, required String channelCode, required String date, required DailyFPCModel model}) {
  //   return '$BASE_URL/api/dailyfpcreport/GetSegmentDetails?ProgramCode=${model.programCode}&ExporttapeCode=${model.tapeid}&EpisodeNumber=${model.epsNo.toString()}&OriginalRepeatCode=${model.oriRepCode}&LocationCode=$locationCode&ChannelCode=$channelCode&StartTime=${model.fpcTime}&TelecastDate=$date';
  // }

  // epg API
  static String OPERATIONAL_FPC_GET_EPG({required String locationCode, required String channelCode, required String programCode}) {
    return '$BASE_URL/api/dailyfpcreport/GetEpgProgramList?LocationCode=$locationCode&ChannelCode=$channelCode&ProgramCode=$programCode';
  }

  static String OPERATIONAL_FPC_GET_DEFAULT_SEGMENT_LIST_LC({required String locationCode}) {
    return '$BASE_URL/api/dailyfpcreport/GetEuropeDetails?Location=$locationCode';
  }

  static String OPERATIONAL_FPC_GET_DEFAULT_SEGMENT_LIST_EUROPE_DETAILS(
      {required String locationCode, required String channelCode, required String fpcDuration}) {
    return '$BASE_URL/api/dailyfpcreport/GetEuropeDetailsInfo?LocationCode=$locationCode&ChannelCode=$channelCode&FPCDuration=$fpcDuration';
  }

  static String OPERATIONAL_FPC_SAVE_FPC(
      {required String locationCode,
      required String channelCode,
      // required String fpcDuration,
      required String date,
      required bool isStandby,
      required String programCode,
      required String episodeNumber,
      required String tapeId,
      required String fpcTime,
      required String endTime,
      required String oriRepCode,
      required String isModified}) {
    // return BASE_URL + '/api/dailyfpcreport/SaveDailyFPC?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date&ModifiedBy=$userId&StandBy=$isStandby&ProgramCode=$programCode&EpisodeNumber=$episodeNumber&TapeID=$tapeId&FPCTime=$fpcTime:00&EndTime=$endTime:00&OriginalRepeatCode=$oriRepCode&Modifed=$isModified';
    return '$BASE_URL/api/dailyfpcreport/saveDailyFPC_Data?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date&ModifiedBy=$userId&StandBy=${isStandby ? "Y" : "N"}&ProgramCode=$programCode&EpisodeNumber=$episodeNumber&TapeID=$tapeId&FPCTime=$fpcTime:00&EndTime=$endTime:00&OriginalRepeatCode=$oriRepCode&Modifed=$isModified';
  }

  static String OPERATIONAL_FPC_SAVE_SEGMENT(
      {required String programCode,
      required String originalRepCode,
      required String tapeId,
      required String segNo,
      required String segCaption,
      required String segDuration,
      required String som}) {
    return '$BASE_URL/api/dailyfpcreport/DefaultSegmentSave?ProgramCode=$programCode&OriginalRepeatCode=$originalRepCode&ExporttapeCode=$tapeId&ModifiedBy=$userId&SegmentNumber=$segNo&ExportTapeCaption=$segCaption&SOM=$som:00&SegmentDuration=$segDuration';
  }

  static String OPERATIONAL_FPC_GetDataAfterProgLoad({required String locationCode, required String channelCode, required String programCode}) {
    return '$BASE_URL/api/dailyfpcreport/GetDataAfterProgLoad?LocationCode=$locationCode&ChannelCode=$channelCode&ProgramCode=$programCode';
  }

  static String OPERATIONAL_FPC_NEXT_EP(
      {required String locationCode,
      required String channelCode,
      required String teleDate,
      required String orgRepCode,
      required String programCode}) {
    return '$BASE_URL/api/dailyfpcreport/GetNextEpisodeNumber?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$teleDate&ProgramCode=$programCode&OrgRepCode=$orgRepCode';
  }

  static String OPERATIONAL_FPC_GET_TAPE_ID({required int ep, required String orgRepCode, required String programCode}) {
    return '$BASE_URL/api/dailyfpcreport/GetTapeId?ProgramCode=$programCode&EpisodeNo=$ep&OrgRepCode=$orgRepCode';
  }

  static String OPERATIONAL_FPC_SEGMENT_DETAILS(
      {required String locationCode,
      required String channelCode,
      required String date,
      required String epsNo,
      required String programCode,
      required String originalRepCode,
      required String tapeId,
      required String som}) {
    return '$BASE_URL/api/dailyfpcreport/GetSegmentDetails?ProgramCode=$programCode&ExporttapeCode=$tapeId&EpisodeNumber=$epsNo&OriginalRepeatCode=$originalRepCode&LocationCode=$locationCode&ChannelCode=$channelCode&StartTime=$som&TelecastDate=$date';
  }

  static String OPERATIONAL_FPC_DELETE_SEGMENTS({
    required String programCode,
  }) {
    return '$BASE_URL/api/dailyfpcreport/DeleteDefaultSegmentDetails?ProgramCode=$programCode';
  }

  static String OPERATIONAL_FPC_VALIDATE_ON_SAVE({
    required String locationCode,
    required String channelCode,
    required String date,
  }) {
    return '$BASE_URL/api/dailyfpcreport/GetValidateSaveData?LocationCode=$locationCode&ChannelCode=$channelCode&TelecastDate=$date';
  }

  static String OPERATIONAL_FPC_VALIDATE_ON_SAVE1({
    required String locationCode,
    required String channelCode,
    required String date,
  }) {
    return '$BASE_URL/api/DailyFPCReport/GetValidateFPCData';
  }

  static String OPERATIONAL_FPC_VALIDATE_ON_SAVE2({
    required String locationCode,
    required String channelCode,
    required String date,
    required String rowNo,
    required String progCode,
    required String langCode,
    required String orgRepCode,
    required String progTypCode,
    required String epsDur,
    required String fpcTime,
    required String endTime,
    required String progName,
    required String epsNo,
    required String tapeId,
    required String status,
    required String orgRep,
    required String wbs,
    required String caption,
    required String modified,
  }) {
    return '$BASE_URL/api/DailyFPCReport/GetValidateFPCData?locationCode=$locationCode&channelCode=$channelCode&telecastDate=$date&RowNo=$rowNo&ProgramCode=$progCode&LanguageCode=$langCode&OriginalRepeatCode=$orgRepCode&ProgramTypeCode=$progTypCode&EpisodeDuration=$epsDur&FpcTime=$fpcTime&endtime=$endTime&ProgramName=$progName&EpsNo=$epsNo&Tapeid=$tapeId&Status=$status&OriRep=$orgRep&WBS=$wbs&Caption=$caption&Modifed=$modified&OriRepCode=$orgRepCode';
  }

  ////////////////////////////////////////////////////End Operational FPC Page//////////////////////////////////////////////////////////
  ////////////////////////////// START OF ZONE MASTER API///////////////////////////////////
  static String get ZONE_MASTER_INITALIZE => "$BASE_URL/api/ZoneMaster/ZoneMasterInitialise";

  static String ZONE_MASTER_SAVE(
    String zoneCode,
    String zoneName,
    String shortName,
    String startSeries,
    String bShortName,
    String sapSales,
  ) =>
      "$BASE_URL/api/ZoneMaster/SaveZoneMaster?ZoneCode=$zoneCode&ZoneName=$zoneName&ShortName=$shortName&StartSeries=$startSeries&BShortName=$bShortName&SAPSales=$sapSales";
  ////////////////////////////// END OF ZONE MASTER API///////////////////////////////////

  ////////////////////////////// START ZONE WISE COMMERCIAL TIME ALLOCATION/////////////
  static String get ZONE_WISE_COMMERCIAL_TIME_ALLOC_LOCATION_LOAD => "$BASE_URL/api/ZonewiseCommercialTimeAllocation/Location_Load";

  static String get ZONE_WISE_COMMERCIAL_TIME_ALLOC_GET_ALL_CHANNELS => "$BASE_URL/api/ZonewiseCommercialTimeAllocation/Channel_Load";

  static String ZONE_WISE_COMMERCIAL_TIME_ALLOC_GET_CHANNELS_ON_LEAVE(String locationCode, String loggedUser) =>
      "$BASE_URL/api/ZonewiseCommercialTimeAllocation/Locations_Leave?LocationCode=$locationCode&LoggedUser=$loggedUser";

  static String ZONE_WISE_COMMERCIAL_TIME_ALLOC_GET_ALL_DISPLAY_RECORD(String locationCode, String channelCode) =>
      "$BASE_URL/api/ZonewiseCommercialTimeAllocation/DisplayRecord?LocationCode=$locationCode&ChannelCode=$channelCode";

  static String ZONE_WISE_COMMERCIAL_TIME_ALLOC_SAVE_DATA(String locationCode, String channelCode) =>
      "$BASE_URL/api/ZonewiseCommercialTimeAllocation/SaveRecord?LocationCode=$locationCode&ChannelCode=$channelCode";
  ////////////////////////////// END ZONE WISE COMMERCIAL TIME ALLOCATION//////////////
  ///
  ///
  ///////////////////////////// START LOCATION MASTER API///////////////////
  static String LOCATION_MASTER_INITALIZE_CURRENCY = "$BASE_URL/api/LocationMaster/FillCurrencyTypeMaster";
  static String LOCATION_MASTER_INITALIZE_TERRITORY = "$BASE_URL/api/LocationMaster/FillTerritoryMaster";
  static String LOCATION_MASTER_FETCH_LOCATION(String keyword) => "$BASE_URL/api/LocationMaster/LocationName_leave?LocationName=$keyword";

  // static String LOCATION_MASTER_FETCH_SHORT_NAME({String? locationCode, required String keyword}) =>
  //     "$BASE_URL/api/LocationMaster/ShortName_Leave?ShortName=$keyword${locationCode != null ? "&TextBoxShortName=$locationCode" : ""}";

  static String LOCATION_MASTER_FETCH_SHORT_NAME(String shortName) => "$BASE_URL/api/LocationMaster/ShortName_Leave?ShortName=$shortName";

  // static String LOCATION_MASTER_FETCH_SAP_OFFICE({String? locationCode, required String keyword}) =>
  //     "$BASE_URL/api/LocationMaster/SAPSalesOffice_Leave?SAPSalesOffice=$keyword${locationCode != null ? "&LocationCode=$locationCode" : ""}";

  static String LOCATION_MASTER_FETCH_SAP_OFFICE(String sapSales) => "$BASE_URL/api/LocationMaster/SAPSalesOffice_Leave?SAPSalesOffice=$sapSales";

  static String LOCATION_MASTER_SAVE({
    String? locationCode,
    required String locationName,
    required String locationShortName,
    required String currencyCode,
    required int territorycode,
    required String sapSalesOffice,
    required String loginCode,
  }) =>
      "$BASE_URL/api/LocationMaster/LocationSaveRecords?LocationCode=${locationCode ?? ""}&LocationName=$locationName&LocationShortName=$locationShortName&CurrencyCode=$currencyCode&Territorycode=$territorycode&SAPSalesOffice=$sapSalesOffice&ModifiedBy=$loginCode";
  ///////////////////////////// END LOCATION MASTER API///////////////////
  ///
  ///
  //////////////////////////// START ZONE GROUPING API///////////////////
  static String get ZONE_GROUPING_LOCATION => "$BASE_URL/api/ZoneGrouping/Location_Load";
  static String ZONE_GROUPING_CHANNELS(String locationCode) => "$BASE_URL/api/ZoneGrouping/Channel_Load?LocationCode=$locationCode";
  static String ZONE_GROUPING_GET_ALL_GROUPS(String locationCode, String channelCode) =>
      "$BASE_URL/api/ZoneGrouping/PopulateGroup?LocationCode=$locationCode&ChannelCode=$channelCode";
  static String ZONE_GROUPING_GET_LEFT_DATATABLE(String lc, String cc, String gc) =>
      "$BASE_URL/api/ZoneGrouping/PopulateGroupedZone?LocationCode=$lc&ChannelCode=$cc&GroupCode=$gc";
  static String ZONE_GROUPING_GET_RIHGT_DATATABLE(String lc, String cc, String gc) =>
      "$BASE_URL/api/ZoneGrouping/PopulateGroupedZoneLeft?LocationCode=$lc&ChannelCode=$cc&GroupCode=$gc";
  static String ZONE_GROUPING_SAVE_DATA(String lc, String cc, String gc) =>
      "$BASE_URL/api/ZoneGrouping/SaveZoneGrouping?LocationCode=$lc&ChannelCode=$cc&GroupCode=$gc";
  //////////////////////////// END ZONE GROUPING API///////////////////
  ///
  ///
  ///
  ////////////////////////// START CHANNEL MASTER API//////////////////
  static String get CHANNEL_MASTER_GET_LOCATION => "$BASE_URL/api/ChannelMaster/Location_Load";
  static String get CHANNEL_MASTER_GET_CHANNELS => "$BASE_URL/api/ChannelMaster/Channel_Load";

  static String CHANNEL_MASTER_CHANNEL_EVENT_SPECI_LEFT_DATA(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/Get_ChannelSpecs?LocationCode=$lc&ChannelCode=$cc";
  static String CHANNEL_MASTER_CHANNEL_EVENT_SPECI_RIGHT_DATA(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/EventSpecification?LocationCode=$lc&ChannelCode=$cc";

  static String CHANNEL_MASTER_CREATE_NEW_CHANNEL_EXIT(String channelName, String shortName) {
    return "$BASE_URL/api/ChannelMaster/ShortNameLeave?strShortName=$shortName&ChannelMaster=$channelName";
  }

  static String get CHANNEL_MASTER_SAVE_CREATE_NEW_CHANNEL => "$BASE_URL/api/ChannelMaster/CreateNewChannel";

  static String CHANNEL_MASTER_CREATE_NEW_CHANNEL_GET_ALL_DATA(String channelNanme) =>
      "$BASE_URL/api/ChannelMaster/ChannelNameLeave?ChannelName=$channelNanme";

  static String CHANNEL_MASTER_LOG_LEFTDATATABLE_DATA(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/LogSpecificationGrid?LocationCode=$lc&ChannelCode=$cc";
  static String CHANNEL_MASTER_LOG_1ST_QUERY(String lc, String cc) => "$BASE_URL/api/ChannelMaster/Get_Excel?LocationCode=$lc&ChannelCode=$cc";
  static String CHANNEL_MASTER_LOG_2ND_QUERY(String lc, String cc) => "$BASE_URL/api/ChannelMaster/Get_ExcelOld?LocationCode=$lc&ChannelCode=$cc";
  static String CHANNEL_MASTER_LOG_3RD_QUERY(String lc, String cc) => "$BASE_URL/api/ChannelMaster/Get_ExcelNews?LocationCode=$lc&ChannelCode=$cc";

  static String CHANNEL_MASTER_CHANNEL_BAND_DATA(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/GetBandMaster?LocationCode=$lc&ChannelCode=$cc";

  static String get CHANNEL_MASTER_SAVE_DATA => "$BASE_URL/api/ChannelMaster/ChannelMasterSave";

  static String get CHANNel_MASTER_TIME_BAND_VALIDATION => "$BASE_URL/api/ChannelMaster/Validate";

  static String CHANNEL_MASTER_SAVE_CHANNELEVENTSPECF_RIGHT_TABLE(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/SaveEventSpecs?LocationCode=$lc&ChannelCode=$cc";

  static String CHANNEL_MASTER_SAVE_CHANNELEVENTSPECF_LEFT_TABLE(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/SaveChannelSpecs?LocationCode=$lc&ChannelCode=$cc";

  static String CHANNEL_MASTER_SAVE_LOGSPECF_LEFT_TABLE(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/SaveLogSpecs?LocationCode=$lc&ChannelCode=$cc";

  static String CHANNEL_MASTER_SAVE_LOGSPECF_3QUERY(String lc, String cc) =>
      "$BASE_URL/api/ChannelMaster/SaveExcelQuery?LocationCode=$lc&ChannelCode=$cc";

  static String CHANNEL_MASTER_SAVE_CHANNEL_BAND(String lc, String cc) => "$BASE_URL/api/ChannelMaster/SaveTimeBand?LocationCode=$lc&ChannelCode=$cc";

  ////////////////////////// END CHANNEL MASTER API//////////////////
  ///
  ///
  ///
  ///
  ////////////////////////// START LOGIN MASTER API ////////////////
  static String get LOGIN_MASTER_GET_LOCATION => "$BASE_URL/api/LoginMaster/GetLocation";

  static String LOGIN_MASTER_GET_LOGGEDUSERCHANNELS(String lc) {
    return "$BASE_URL/api/LoginMaster/GetLoggedUserChannels?LoginCode=$lc";
  }

  static String get LOGIN_MASTER_GET_MODULE => "$BASE_URL/api/LoginMaster/GetModule";
  static String get LOGIN_MASTER_GET_ZONE => "$BASE_URL/api/LoginMaster/GetZone";
  static String get LOGIN_MASTER_GET_BRANCH => "$BASE_URL/api/LoginMaster/GetBranch";
  static String get LOGIN_MASTER_GET_USER_DETAILS => "$BASE_URL/api/LoginMaster/GetUserDetails";
  static String get LOGIN_MASTER_GET_ZONE_1 => "$BASE_URL/api/LoginMaster/GetZoneName1";

  static String get LOGIN_MASTER_GET_USER_LIST => "$BASE_URL/api/LoginMaster/GetUserDetails?SearchValue=";

  static String LOGIN_MASTER_GET_USER_ALL_INFO(String ln,
          {String? lc, bool fromCopyRIghts = false, bool chkCopyTransactionRights = false, bool chkCopyLocationChannelZoneRights = false}) =>
      "$BASE_URL/api/LoginMaster/GetLoginInfo?LoginName=$lc&LoginCode=&iscopy=$fromCopyRIghts&chkCopyTransactionRights=$chkCopyTransactionRights&chkCopyLocationChannelZoneRights=$chkCopyLocationChannelZoneRights";

  static String LOGIN_MASTER_GET_EMPLOYEE_DETAILS(String sapID) => "$BASE_URL/api/LoginMaster/GetEmployeeDetails?SAPID=$sapID";
  static String get LOGIN_MASTER_GET_MODULE_FORM_DETAILS => "$BASE_URL/api/LoginMaster/GetModuleFormDetails";

  static String LOGIN_MASTER_LOCATION_CHANNEL_ZONE_RIGHT_ACTIVE_ZONE(String lc, String cd) =>
      "$BASE_URL/api/LoginMaster/GetActiveZoneDetails?LocationCode=$lc&ChannelCode=$cd";

  static String get LOGIN_MASTER_SAVE_ALL_CHANNELS_LOCATIONS_ZONE_RIGHTS => "$BASE_URL/api/LoginMaster/SaveAddChannelAndLocationRight";
  static String get LOGIN_MASTER_SAVE_BUDGET_EMPLOYEE_LOGIN => "$BASE_URL/api/LoginMaster/SaveBudgetEmployeeLogin";
  static String get LOGIN_MASTER_SAVE_TC_INWARD_USER_DETAILS => "$BASE_URL/api/LoginMaster/SaveInwardUserDtls";
  static String get LOGIN_MASTER_SAVE_LOGIN_MASTER => "$BASE_URL/api/LoginMaster/SaveLoginMaster";

  ////////////////////////// END LOGIN MASTER API ////////////////
  ///
  ///
  ///
  ///////////////////////// START MODULE FORM TRANSACTION API//////
  static String get MODULE_FORM_TRANSACTION_GET_MODULE_FORMS_LIST => "$BASE_URL/api/ModuleFormTransaction/Initialisation";

  static String get MODULE_FORM_TRANSACTION_ADD_MODULE_SAVE => "$BASE_URL/api/ModuleFormTransaction/SaveModuleData";
  static String get MODULE_FORM_TRANSACTION_ADD_FORM_SAVE => "$BASE_URL/api/ModuleFormTransaction/SaveFormData";
  static String get MODULE_FORM_TRANSACTION_FORM_DELETE_SAVE => "$BASE_URL/api/ModuleFormTransaction/SaveFormModuleMappingData";

  static String MODULE_FORM_TRANSACTION_GET_MODULE_LIST(String moduleCode) =>
      "$BASE_URL/api/ModuleFormTransaction/GetModuleFormDetails?ModuleCode=$moduleCode";
  ///////////////////////// END MODULE FORM TRANSACTION API//////
}
