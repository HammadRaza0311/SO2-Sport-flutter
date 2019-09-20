
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:so2_app/controllers/home.dart';

class WebViewPage extends StatefulWidget {
    String url = "";

  @override
  WebViewPageState createState() {
    WebViewPageState state = WebViewPageState();
    state.url = this.url;
    return state;
  }

}

class WebViewPageState extends State<WebViewPage> {
  String url;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("Current URL: $url");
        if(url.contains("login")){
          Home page = new Home();
          Route route = MaterialPageRoute(builder: (context) => page);
          Navigator.pushReplacement(context, route);
        }
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("WEBVIEW URL" + url);

    return WebviewScaffold(
        url: url,
        hidden: true,
        appBar: PreferredSize(
          child: Container(),
          preferredSize: Size(0.0, 0.0),
        ));
  }
}