import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'dart:convert';

import 'package:so2_app/controllers/webview.dart';

TextEditingController _passwordController = TextEditingController()  ;
TextEditingController _useridController = TextEditingController();


class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Video Example',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<LoginPage> {
  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  void initState() {
    super.initState();

    createVideo();
    if (playerController != null) {
      playerController.play();
    }

    listener = () {
      setState(() {});
    };
  }

  void createVideo() {
    if (playerController == null) {
      playerController = VideoPlayerController.asset("assets/intro.mp4")
        ..addListener(listener)
        ..setVolume(1.0)
        ..setLooping(true)
        ..initialize()
        ..play();
      super.initState();
    }
  }

  _makePostRequest(String idText, String passwordText) async {

//  idText = "1003";
//  passwordText = "20rje5rgfokm";

    if (idText.length == 0){
      _showDialog("ID can't be blank");
    }else if (passwordText.length == 0){
      _showDialog("Password can't be blank");
    }else{
      // set up POST request arguments
      String url = 'https://my.synergyo2.com/api/v1/login';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = "{\"member_id\":\"" +idText+ "\",\"password\":\"" +passwordText+"\"}";

      debugPrint(json);
      // make POST request
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      // this API passes back the id of the new item added to the body
      String body = response.body;


      Map<String, dynamic> map = jsonDecode(body);

      String token = map['response'][0]['token'];

      debugPrint(body);

      if (token != null){
        WebViewPage page = new WebViewPage();
        page.url =  "https://my.synergyo2.com/login/"+token;
        Route route = MaterialPageRoute(builder: (context) => page);
        Navigator.pushReplacement(context, route);

//        Navigator.of(context).push(
//            MaterialPageRoute<Null>(builder: (BuildContext context) {
//              return new WebViewWebPage(url: "https://my.synergyo2.com/login/"+token);
//            }));
      }else{
        _showDialog("Invalid Credentials! Please enter credentials correctly.");
      }
    }


  }

  void _showDialog(String text) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("SO2 App"),
          content: new Text(text),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void deactivate() {
    playerController.setVolume(0.5);
    playerController.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      child: (playerController != null
                          ? VideoPlayer(
                        playerController,
                      )
                          : Container()),
                    ))),
            new SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                        child: new TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _useridController,

                          decoration: new InputDecoration(
                              hintText: "User ID",
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              prefixIcon: Icon(Icons.person, color: Colors.white)),
                        ),
                      ),
                      new SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                        child: new TextField(


                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          controller: _passwordController,


                          decoration: new InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.white, width: 0.0),
                              ),
                              prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.white)),


                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 30.0),
                              child: GestureDetector(
                                onTap: () {
                                  debugPrint("usr id ---- "+_useridController.value.text);

//                                  Route route = MaterialPageRoute(builder: (context) => new WebViewPage());
//                                  Navigator.pushReplacement(context, route);


                                  _makePostRequest(_useridController.value.text, _passwordController.value.text);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: new Container(
                                    alignment: Alignment.center,
                                    height: 55.0,
                                    decoration: new BoxDecoration(
                                        color: Color.fromRGBO(247, 119, 32, 1.0),
                                        borderRadius: new BorderRadius.circular(40.0)),
                                    child: new Text("Access",
                                        style: new TextStyle(
                                            fontSize: 20.0, color: Colors.white))),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                left: 80.0,
                                top: 8.0,
                                right: 5.0,
                              ),
                              child: Divider(
                                color: Colors.white,
                                height: 36,
                              )),
                        ),
                        Text("OR",
                            style: new TextStyle(fontSize: 14.0, color: Colors.white)),
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 5.0, top: 8.0, right: 80.0),
                              child: Divider(
                                color: Colors.white,
                                height: 36,
                              )),
                        ),
                      ]),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 5.0, top: 0.0),
                                child: new Text("Recover your access data",
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        fontSize: 14.0, color: Colors.white))),
                          )
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 5.0, top: 25.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 0.0),
                                  child: new TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: new InputDecoration(
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 0.0),
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 0.0),
                                        ),
                                        prefixIcon: Icon(Icons.contact_mail,
                                            color: Colors.white),
                                        hintText: "Business email",
                                        hintStyle: TextStyle(color: Colors.grey)),
                                  ),
                                )),
                          )
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 30.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: new Container(
                                    alignment: Alignment.center,
                                    height: 55.0,
                                    decoration: new BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: Color.fromRGBO(247, 119, 32, 0.0),
                                        borderRadius: new BorderRadius.circular(40.0)),
                                    child: new Text("Request",
                                        style: new TextStyle(
                                            fontSize: 20.0, color: Colors.white))),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
