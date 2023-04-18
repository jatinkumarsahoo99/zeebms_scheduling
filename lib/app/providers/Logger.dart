import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../controller/MainController.dart';
import 'Const.dart';

class Logger {
  static void write(String log, {bool isError = false}) {
    Future.microtask(() {
      sendTrace(trace: log);
    });
  }

  static Future<void> sendError(
      {required error, StackTrace? stackTrace, Severity? severity}) async {
    print('Sending telemetry...');

    try {
      final client = Client();
      final processor = BufferedProcessor(
        next: TransmissionProcessor(
          instrumentationKey: Const.instrumentationKey,
          httpClient: client,
          timeout: const Duration(seconds: 10),
        ),
      );
      final telemetryClient = TelemetryClient(
        processor: processor,
      );
      telemetryClient.context.applicationVersion = Const.appVersion;
      telemetryClient.context.user.id =
          Get.find<MainController>().user?.employeeId ?? "";
      telemetryClient.context.properties['Module'] = 'Admin';
      telemetryClient.context.properties['UserName'] =
          Get.find<MainController>().user?.employeeName ?? "";
      telemetryClient.context.properties['PersonalNo'] =
          Get.find<MainController>().user?.personnelNo ?? "";
      telemetryClient.context.properties['JobTitle'] =
          Get.find<MainController>().user?.jobTitle ?? "";
      telemetryClient.context.properties['LoginName'] =
          Get.find<MainController>().user?.loginName ?? "";
      telemetryClient.context.properties['MailId'] =
          Get.find<MainController>().user?.mailId ?? "";

      telemetryClient.trackError(
        severity: severity ?? Severity.error,
        stackTrace: stackTrace ?? null,
        error: error,
        additionalProperties: <String, Object>{
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      await telemetryClient.flush();

      client.close();

      print('...sent!');
    } on Object catch (e) {
      print('...failed! $e');
    }
  }

  static Future<void> sendRequest({required Map<String,dynamic> map}) async {
    print('Sending telemetry...');

    try {
      final client = Client();
      final processor = BufferedProcessor(
        next: TransmissionProcessor(
          instrumentationKey: Const.instrumentationKey,
          httpClient: client,
          timeout: const Duration(seconds: 10),
        ),
      );
      final telemetryClient = TelemetryClient(
        processor: processor,
      );
      telemetryClient.context.applicationVersion = Const.appVersion;
      telemetryClient.context.user.id =
          Get.find<MainController>().user?.employeeId ?? "";
      telemetryClient.context.properties['Module'] = 'Admin';
      telemetryClient.context.properties['UserName'] =
          Get.find<MainController>().user?.employeeName ?? "";
      telemetryClient.context.properties['PersonalNo'] =
          Get.find<MainController>().user?.personnelNo ?? "";
      telemetryClient.context.properties['JobTitle'] =
          Get.find<MainController>().user?.jobTitle ?? "";
      telemetryClient.context.properties['LoginName'] =
          Get.find<MainController>().user?.loginName ?? "";
      telemetryClient.context.properties['MailId'] =
          Get.find<MainController>().user?.mailId ?? "";

      telemetryClient.trackRequest(
        id: "Test",
        duration: Duration(seconds: 20),
        additionalProperties: <String, Object>{
          'timestamp': DateTime.now().toIso8601String(),
        },
        responseCode: '200',
      );

      await telemetryClient.flush();

      client.close();

      print('...sent!');
    } on Object catch (e) {
      print('...failed! $e');
    }
  }

  static Future<void> sendEvent({required String event}) async {
    print('Sending telemetry...');

    try {
      final client = Client();
      final processor = BufferedProcessor(
        next: TransmissionProcessor(
          instrumentationKey: Const.instrumentationKey,
          httpClient: client,
          timeout: const Duration(seconds: 10),
        ),
      );
      final telemetryClient = TelemetryClient(
        processor: processor,
      );
      telemetryClient.context.applicationVersion = Const.appVersion;
      telemetryClient.context.user.id =
          Get.find<MainController>().user?.employeeId ?? "";
      telemetryClient.context.properties['Module'] = 'Admin';
      telemetryClient.context.properties['UserName'] =
          Get.find<MainController>().user?.employeeName ?? "";
      telemetryClient.context.properties['PersonalNo'] =
          Get.find<MainController>().user?.personnelNo ?? "";
      telemetryClient.context.properties['JobTitle'] =
          Get.find<MainController>().user?.jobTitle ?? "";
      telemetryClient.context.properties['LoginName'] =
          Get.find<MainController>().user?.loginName ?? "";
      telemetryClient.context.properties['MailId'] =
          Get.find<MainController>().user?.mailId ?? "";

      telemetryClient.trackEvent(
        name: event,
        additionalProperties: <String, Object>{
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      await telemetryClient.flush();
      client.close();
      print('...sent!');
    } on Object catch (e) {
      print('...failed! $e');
    }
  }

  static Future<void> sendPageView(
      {required String pageView, Severity? trace}) async {
    print('Sending telemetry...');

    try {
      final client = Client();
      final processor = BufferedProcessor(
        next: TransmissionProcessor(
          instrumentationKey: Const.instrumentationKey,
          httpClient: client,
          timeout: const Duration(seconds: 10),
        ),
      );
      final telemetryClient = TelemetryClient(
        processor: processor,
      );
      telemetryClient.context.applicationVersion = Const.appVersion;
      telemetryClient.context.user.id =
          Get.find<MainController>().user?.employeeId ?? "";
      telemetryClient.context.properties['Module'] = 'Admin';
      telemetryClient.context.properties['UserName'] =
          Get.find<MainController>().user?.employeeName ?? "";
      telemetryClient.context.properties['PersonalNo'] =
          Get.find<MainController>().user?.personnelNo ?? "";
      telemetryClient.context.properties['JobTitle'] =
          Get.find<MainController>().user?.jobTitle ?? "";
      telemetryClient.context.properties['LoginName'] =
          Get.find<MainController>().user?.loginName ?? "";
      telemetryClient.context.properties['MailId'] =
          Get.find<MainController>().user?.mailId ?? "";
      telemetryClient.trackPageView(
        name: pageView,
        additionalProperties: <String, Object>{
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      await telemetryClient.flush();
      client.close();
      print('...sent!');
    } on Object catch (e) {
      print('...failed! $e');
    }
  }

  static Future<void> sendTrace({required String trace, Severity? type}) async {
    print('Sending telemetry...');

    try {
      final client = Client();
      final processor = BufferedProcessor(
        next: TransmissionProcessor(
          instrumentationKey: Const.instrumentationKey,
          httpClient: client,
          timeout: const Duration(seconds: 10),
        ),
      );
      final telemetryClient = TelemetryClient(
        processor: processor,
      );
      telemetryClient.context.applicationVersion = Const.appVersion;
      telemetryClient.context.user.id =
          Get.find<MainController>().user?.employeeId ?? "";
      telemetryClient.context.properties['Module'] = 'Admin';
      telemetryClient.context.properties['UserName'] =
          Get.find<MainController>().user?.employeeName ?? "";
      telemetryClient.context.properties['PersonalNo'] =
          Get.find<MainController>().user?.personnelNo ?? "";
      telemetryClient.context.properties['JobTitle'] =
          Get.find<MainController>().user?.jobTitle ?? "";
      telemetryClient.context.properties['LoginName'] =
          Get.find<MainController>().user?.loginName ?? "";
      telemetryClient.context.properties['MailId'] =
          Get.find<MainController>().user?.mailId ?? "";

      telemetryClient.trackTrace(
        severity: type ?? Severity.verbose,
        message: trace,
        additionalProperties: <String, Object>{
          'timestamp': DateTime.now().toIso8601String(),
        },
        // timestamp: DateTime.now()
      );

      await telemetryClient.flush();
      client.close();
      print('...sent!');
    } on Object catch (e) {
      print('...failed! $e');
    }
  }

  static Future<void> sendTelemetry({String? error}) async {
    print('Sending telemetry...');

    try {
      final client = Client();

      // Create a processor that will handle the telemetry items. In this case, we're buffering telemetry items and then
      // forwarding them on for transmission.
      final processor = BufferedProcessor(
        next: TransmissionProcessor(
          instrumentationKey: Const.instrumentationKey,
          // You can inject your own HTTP middleware to adjust the behavior of HTTP communications, such as automatically
          // retrying or caching failed requests.
          httpClient: client,
          // ingestionEndpoint: "https://centralindia-0.in.applicationinsights.azure.com/",
          timeout: const Duration(seconds: 10),
        ),
      );

      // Then we create a telemetry client that uses the processor.
      final telemetryClient = TelemetryClient(
        processor: processor,
      );

      // You can set properties in two places and in two ways.
      //
      // The first place, demonstrated here, is directly against the telemetry client's context. Any properties set here
      // will be attached to all telemetry items created by the telemetry client. The second place is in each call to add
      // a telemetry item, and this is demonstrated further below.
      //
      // This is also an example of the first way of setting properties, which is to use the various helpers
      // (applicationVersion and user, in this case) that are on the context object. These helpers correspond to
      // "well-known" (though apparently not well documented!) properties that Application Insights displays by default
      // depending on the event type. For example, when you query traces, by default you will see the application version
      // specified below, but not the user ID. However, the user ID will still be present inside the customDimensions
      // for each trace event.
      /*telemetryClient.context
        ..applicationVersion = '1.0.1'
        ..user.id = 'Sanjaya';
*/
      telemetryClient.context.applicationVersion = Const.appVersion;
      telemetryClient.context.user.id =
          Get.find<MainController>().user?.employeeId ?? "";
      telemetryClient.context.properties['Module'] = 'Admin';
      telemetryClient.context.properties['UserName'] =
          Get.find<MainController>().user?.employeeName ?? "";
      telemetryClient.context.properties['PersonalNo'] =
          Get.find<MainController>().user?.personnelNo ?? "";
      telemetryClient.context.properties['JobTitle'] =
          Get.find<MainController>().user?.jobTitle ?? "";
      telemetryClient.context.properties['LoginName'] =
          Get.find<MainController>().user?.loginName ?? "";
      telemetryClient.context.properties['MailId'] =
          Get.find<MainController>().user?.mailId ?? "";
      // All the above helper properties do is provide a convenient means of setting key/value pairs inside
      // context.properties, which is the second way to set properties and is demonstrated here.
      // telemetryClient.context.properties['custom'] = 'a custom property value';

      // Now we can send telemetry of various kinds. Here is a simple trace.
      telemetryClient.trackTrace(
        severity: Severity.information,
        message: 'Hello from Dart! Sanjaya',
      );

      telemetryClient.trackPageView(name: "FLUTTER ERROR SANJAYA");

      // You can include additional properties with any telemetry items, which is the second way of including properties.
      // In this case, the properties you provide are only attached to this particular telemetry item (in addition to those
      // on the telemetry client's context).
      telemetryClient.trackTrace(
        severity: Severity.verbose,
        message: 'Here is a trace with additional properties',
        additionalProperties: <String, Object>{
          'answer': 42,
        },
      );
      telemetryClient.trackError(
        severity: Severity.verbose,
        additionalProperties: <String, Object>{
          'answer': 42,
        },
        error: error ?? "Sanjaya Error Test",
      );

      // Here is an event with different properties.
      telemetryClient.trackEvent(
        name: 'started',
        additionalProperties: <String, Object>{
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // You can automatically submit HTTP traffic as request telemetry by using a TelemetryHttpClient. This will include
      // the duration of the request. Check the requests events inside Application Insights to see the details of the below
      // request.
      //
      // NOTE: do NOT pass a TelemetryHttpClient into TelemetryClient itself! This will cause the submission of telemetry
      // to itself result in telemetry, meaning you'll have recursive telemetry submission.
      /* final telemetryHttpClient = TelemetryHttpClient(
        telemetryClient: telemetryClient,
        inner: client,
      );
       await telemetryHttpClient.get(Uri.parse('https://kent-boogaart.com/'));*/

      // Because we're about to exit, we need to flush the telemetry client to force it to process all items.
      await telemetryClient.flush();

      // Just being a good Dart citizen.
      client.close();

      print('...sent!');
    } on Object catch (e) {
      print('...failed! $e');
    }
  }
}
