import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../data/payData.dart';
import '../utility/urlList.dart';
import 'home_page.dart';
import 'payment_summery.dart';

class WebviewPageTest extends StatefulWidget {
  const WebviewPageTest({Key? key, this.data}) : super(key: key);
  final PaymentData? data;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPageTest> {
  bool loading = true;
  late InAppWebViewController _webViewController;
  InAppWebViewController? popupController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    mediaPlaybackRequiresUserGesture: false,
                    javaScriptEnabled: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useWideViewPort: false,
                    useHybridComposition: true,
                    loadWithOverviewMode: true,
                    domStorageEnabled: true,
                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,
                    enableViewportScale: true,
                    ignoresViewportScaleLimits: true,
                  ),
                ),
                initialData: InAppWebViewInitialData(
                  data: _loadHTML(),
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onCreateWindow: (controller, createWindowRequest) async {
                  print("Popup request received!");

                  if (createWindowRequest.request?.url == null) {
                    print("Popup request URL is NULL! The website might not be providing a URL.");
                    return false;
                  }

                  print("Popup URL: \${createWindowRequest.url}");

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(url: createWindowRequest.request?.url),

                          onWebViewCreated: (popup) {
                            popupController = popup;
                          },
                          onCloseWindow: (controller) {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                  return true;
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    loading = false;
                  });

                  if (url.toString() == widget.data?.cancelUrl || url.toString() == widget.data?.redirectUrl) {
                    var html = await controller.evaluateJavascript(
                      source: "window.document.getElementsByTagName('html')[0].outerHTML;",
                    );

                    String html1 = html.toString();
                    if (html1.contains('<body>')) {
                      html1 = html1.split('<body>')[1].split('</body>')[0];

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => PaymentStatus(resp: html1),
                        ),
                            (route) => false,
                      );
                    }
                  }
                },
              ),
              if (loading)
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Do you want to cancel this transaction?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  String _loadHTML() {
    final url = UrlList.ccAvenue_payment_url;
    final command = "initiateTransaction";
    final encRequest = widget.data?.encVal;
    final accessCode = widget.data?.accessCode;

    return """
    <html>
      <head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head>
      <body onload='document.f.submit();'>
        <form id='f' name='f' method='post' action='$url'>
          <input type='hidden' name='command' value='$command'/>
          <input type='hidden' name='encRequest' value='$encRequest'/>
          <input type='hidden' name='access_code' value='$accessCode'/>
        </form>
      </body>
    </html>
    """;
  }
}