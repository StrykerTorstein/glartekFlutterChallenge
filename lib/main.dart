import 'package:flutter/material.dart';
import 'package:flutter_unity/flutter_unity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'forecast_data.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glartek Challenge - Samuel Martins'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            //Navigator.push(context,MaterialPageRoute(builder: (context) => UnityViewPage()));
            showWeather("Leiria");
          },
          child: Text('Leiria'),
        ),
      ),
    );
  }

 */

  String getCity(index){
    switch(index){
      case 0: return "Leiria";
      case 1: return "Lisboa";
      case 2: return "Coimbra";
      case 3: return "Porto";
      case 4: return "Faro";
    }
    return "Leiria";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Glartek Challange - Samuel Martins')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return RaisedButton(
            onPressed: () {
              print(index);
              try {
                showWeather(getCity(index));
              } on Exception catch (e) {
                showAlertDialog(context,e.toString());
              }
            },
            child: Text(getCity(index)),
          );
        },
      ),
    );
  }

  Future<String> showWeather(String city) async{
    String appID = "511678d160e046c731f64a543e97e5a1";
    int cityCode = getCityCode(city);
    String url = 'http://api.openweathermap.org/data/2.5/forecast?id=$cityCode&appid=$appID';
    http.Response response = await http.get(
        Uri.encodeFull(url),
        headers:{
          "Accept" : "application/json"
        }
    );
    if(response.statusCode == 200){
      print("RECEIVED VALID DATA!");
    }else{
      int code = response.statusCode;
      showAlertDialog(context,'Error Code: $code');
      return "";
    }

    Map<String, dynamic> map = jsonDecode(response.body);
    int cnt = map["cnt"];
    var out = map['cnt'];
    print('out: $out');
    List<dynamic> data = map["list"];
    List<ForecastSimple> lst = new List<ForecastSimple>();
    for(int i = 0; i < cnt ; i++){
      int timestamp = data[i]["dt"];
      double temperatureKelvin = double.parse(data[i]["main"]["temp"].toString())-272.15;
      List<dynamic> weather = data[i]["weather"];
      String clouds = weather[0]["main"]; //Rain, Clear, Clouds...
      //var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      lst.add(ForecastSimple(timestamp,clouds,temperatureKelvin.round()));
      //print(lst[i]);
    }
    if(lst == null || lst.length == 0){
      showAlertDialog(context,'Error, no data received.');
    }
    var json = jsonEncode(lst);
    print(json);
    Navigator.push(context,MaterialPageRoute(builder: (context) => UnityViewPage(city.toUpperCase(),lst)));
    return "";
  }

  int getCityCode(String cityName){
    String city = cityName.toUpperCase();
    switch(city){
      case "LISBOA ": return 2267056;
      case "LEIRIA": return 2267094;
      case "COIMBRA ": return 2740636;
      case "PORTO": return 2735941;
      case "FARO": return 2268337;
    }
    return -1;
  }

  showAlertDialog(BuildContext context,String msg)
  {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true)
            .pop(); // dismisses only the dialog and returns nothing
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("It seems there was a problem... :("),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class UnityViewPage extends StatefulWidget {
  final String city;
  final List<ForecastSimple> forecastList;
  const UnityViewPage(this.city,this.forecastList);

  @override
  _UnityViewPageState createState() => _UnityViewPageState();
}

class _UnityViewPageState extends State<UnityViewPage> {
  UnityViewController unityViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glartek - UNITY'),
      ),
      body: UnityView(
        onCreated: onUnityViewCreated,
        onReattached: onUnityViewReattached,
        onMessage: onUnityViewMessage,
      ),
    );
  }

  void onUnityViewCreated(UnityViewController controller) {
    print('onUnityViewCreated');
    unityViewController = controller;

    //print(json);
    String timestampMillis = DateTime.now().millisecondsSinceEpoch.toString();
    //print(timestampMillis);

    ForecastMessage forecastMessage = new ForecastMessage(widget.city, timestampMillis, widget.forecastList);
    String message = jsonEncode(forecastMessage);
    print(message);
    controller.send('UIController','SetForecastData', message);
  }

  void onUnityViewReattached(UnityViewController controller) {
    print('onUnityViewReattached');
  }

  void onUnityViewMessage(UnityViewController controller, String message) {
    print('onUnityViewMessage');

    print(message);
  }
}
