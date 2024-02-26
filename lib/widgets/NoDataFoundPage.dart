import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import '../app/providers/ApiFactory.dart';
import '../app/providers/Utils.dart';

class NoDataFoundPage extends StatelessWidget {
  const NoDataFoundPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/lost.png",
              height: size.width * 0.3,
              width: size.width * 0.4,
            ),
            /*Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "This is wrong route",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ),
            ),
            MaterialButton(
              onPressed: () {
                js.context.callMethod('fromFlutter', ['Flutter is calling upon JavaScript!']);
              },
              child: Text("GO TO HOME", style: TextStyle(color: Colors.white)),
              elevation: 10,
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            )*/
        (html.window.top != html.window.self)
            ? Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                'You are not authorized to access this page. Please contact support team.',
                // style: Theme.of(context).textTheme.bodyLarge,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 5,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                '',
                // style: Theme.of(context).textTheme.bodyLarge,
                style: TextStyle(fontSize: 18),
                children: <InlineSpan>[
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: LinkButton(
                        urlLabel: "Click here",
                        context: context,
                        function: () {
                          // js.context.callMethod('fromFlutter', ['Flutter is calling upon JavaScript!']);
                          print("Click here to exit");
                          if (html.window.location.href.contains("loginCode")) {
                            Utils.callJSToExit(param: "exit|${Utils.getFormName()}");
                          }
                        }),
                  ),
                  TextSpan(
                    text: ' to go home',
                  ),
                ],
              ),
            ),
          ],
        )
            : RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
            'You are not authorized to access this page. Please ',
            // style: Theme.of(context).textTheme.bodyLarge,
            style: TextStyle(fontSize: 18),
            children: <InlineSpan>[
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: LinkButton(
                    urlLabel: "click here",
                    context: context,
                    function: () {
                      // js.context.callMethod('fromFlutter', ['Flutter is calling upon JavaScript!']);
                      html.window.open(ApiFactory.LOGIN_URL, "_self");
                    }),
              ),
              TextSpan(
                text: ' to login',
              ),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget LinkButton({context, urlLabel, Function? function}) {
    return TextButton(
      style: TextButton.styleFrom(
        // padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          minimumSize: const Size(0, 0),
          textStyle: TextStyle(fontSize: 18),
          padding:EdgeInsets.only(top: 5)
        // textStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      onPressed: () {
        if (function != null) {
          function();
        }
        // _launchUrl(url);
      },
      child: Text(urlLabel),
    );
  }
}
