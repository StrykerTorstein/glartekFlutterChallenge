import 'dart:convert';

class ForecastSimple {
  final int timestamp;
  final String weather;
  final int temperature;

  ForecastSimple(this.timestamp, this.weather, this.temperature);

  @override
  String toString() {
    return 'ForecastSecondAttempt{timestamp: $timestamp, weather: $weather, temperature: $temperature}';
  }

  Map<String, dynamic> toJson() =>
      {
        'timestamp': timestamp,
        'weather': weather,
        'temperature' : temperature,
      };
}

class ForecastMessage {
  final String city;
  final String timestamp;
  final List<ForecastSimple> forecastList; //Encoded List<ForecastSimple>

  ForecastMessage(this.city,this.timestamp,this.forecastList);

  Map<String, dynamic> toJson() =>
      {
        'city': city,
        'timestamp': timestamp,
        'forecastList' : forecastList,
      };
}


//Code bellow is deprecated and overcomplicated.

class ForecastData {

  final String auxStuff;
  //final List<ForecastSecondAttempt> forecasts;

  ForecastData(this.auxStuff);

  factory ForecastData.fromJson(var json){
    int cnt = json['cnt'];
    String kek = "";
    List<dynamic> lst = jsonDecode(json['list']);
    for(int i = 0; i < cnt; i++){
      kek += lst.elementAt(i)['dt'];
  }
    return new ForecastData(kek);
  }

  @override
  String toString() {
    return 'ForecastData{auxStuff: $auxStuff}';
  }

/*
  final String cod;
  final int message;
  final int cnt;
  final List<Forecast> list;
  final City city;

  ForecastData(this.cod, this.message, this.cnt, this.list, this.city);

  factory ForecastData.fromJson(var json){
    List<Forecast> aux = new List<Forecast>();
    if(json['list'] != null){
      for(var t in json['list']){
        aux.add(Forecast.fromJson(t));
      }
    }
    List<Forecast> forecastList = aux;
    return new ForecastData(json['cod'],json['message'],json['cnt'],forecastList,City.fromJson(json['city']));
  }

  @override
  String toString() {
    return 'ForecastData{cod: $cod, message: $message, cnt: $cnt, list: $list, city: $city}';
  }
*/
/*
  @override
  String toString() {
    var first = list[0];
    var temp = first.main.temp;
    return 'Temperature: $temp';
  }
   */


}

class Forecast {
  int dt;
  Main main;
  List<Weather> weather;
  Clouds clouds;
  Wind wind;
  int visibility;
  int pop;
  Sys sys;
  String dt_txt;

  Forecast(this.dt, this.main, this.weather, this.clouds, this.wind,
      this.visibility, this.pop, this.sys, this.dt_txt);
/*
  Forecast.fromJson(Map<String, dynamic> json)
      : dt = json['dt'],
        main = Main.fromJson(json['main']),
        weather = getWeatherListFromMap(json['weather']),
        clouds = Clouds.fromJson(json['clouds']),
        wind = Wind.fromJson(json['wind']),
        visibility = json['visibility'],
        pop = json['pop'],
        sys = Sys.fromJson(json['sys']),
        dt_txt = json['dt_txt'];
  */

  factory Forecast.fromJson(Map<String, dynamic> json){
    int dt = json['dt'];
    Main main = Main.fromJson(json['main']);
    List<Weather> aux = new List<Weather>();
    for(var t in json['weather']){
      aux.add(Weather.fromJson(t));
    }
    List<Weather> weather = aux;
    Clouds clouds = Clouds.fromJson(json['clouds']);
    Wind wind = Wind.fromJson(json['wind']);
    int visibility = json['visibility'];
    int pop = json['pop'];
    Sys sys = Sys.fromJson(json['sys']);
    String dt_txt = json['dt_txt'];
    return new Forecast(dt,main,weather,clouds,wind,visibility,pop,sys,dt_txt);
  }

  List<Weather> getWeatherListFromMap(List<dynamic> json){
    List<Weather> aux = new List<Weather>();
    for(var t in json){
      aux.add(Weather.fromJson(t));
    }
    return aux;
  }

  @override
  String toString() {
    return 'Forecast{dt: $dt, main: $main, weather: $weather, clouds: $clouds, wind: $wind, visibility: $visibility, pop: $pop, sys: $sys, dt_txt: $dt_txt}';
  }
}

class Main {
  double temp;
  double feels_like;
  double temp_min;
  double temp_max;
  int pressure;
  int sea_level;
  int grnd_level;
  int humidity;
  double temp_kf;

  Main.name(
      this.temp,
      this.feels_like,
      this.temp_min,
      this.temp_max,
      this.pressure,
      this.sea_level,
      this.grnd_level,
      this.humidity,
      this.temp_kf);

  Main.fromJson(Map<String, dynamic> json)
      : temp = double.parse(json['temp'].toString()),
        feels_like = double.parse(json['feels_like'].toString()),
        temp_min = double.parse(json['temp_min'].toString()),
        temp_max = double.parse(json['temp_max'].toString()),
        pressure = json['pressure'],
        sea_level = json['sea_level'],
        grnd_level = json['grnd_level'],
        humidity = json['humidity'],
        temp_kf = double.parse(json['temp_kf'].toString());

  @override
  String toString() {
    return 'Main{temp: $temp, feels_like: $feels_like, temp_min: $temp_min, temp_max: $temp_max, pressure: $pressure, sea_level: $sea_level, grnd_level: $grnd_level, humidity: $humidity, temp_kf: $temp_kf}';
  }
}

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather.name(this.id, this.main, this.description, this.icon);

  Weather.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        main = json['main'],
        description = json['description'],
        icon = json['icon'];

  @override
  String toString() {
    return 'Weather{id: $id, main: $main, description: $description, icon: $icon}';
  }
}

class Clouds {
  int all;

  Clouds.name(this.all);

  Clouds.fromJson(Map<String, dynamic> json)
      : all = json['all'];

  @override
  String toString() {
    return 'Clouds{all: $all}';
  }
}

class Wind {
  double speed;
  int deg;

  Wind.name(this.speed, this.deg);

  Wind.fromJson(Map<String, dynamic> json)
      : speed = json['speed'],
      deg = json['deg'];

  @override
  String toString() {
    return 'Wind{speed: $speed, deg: $deg}';
  }
}

class Sys {
  String pod;

  Sys.name(this.pod);

  Sys.fromJson(Map<String, dynamic> json)
      : pod = json['pod'];

  @override
  String toString() {
    return 'Sys{pod: $pod}';
  }
}

class Coord {
  double lat;
  double lon;

  Coord.name(this.lat, this.lon);

  Coord.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lon = json['lon'];

  @override
  String toString() {
    return 'Coord{lat: $lat, lon: $lon}';
  }
}

class City {
  int id;
  String name;
  Coord coord;
  String country;
  int timezone;
  int sunrise;
  int sunset;

  City.name(this.id, this.name, this.coord, this.country, this.timezone,
      this.sunrise, this.sunset);

  City.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        coord = Coord.fromJson(json['coord']),
        country = json['country'],
        timezone = json['timezone'],
        sunrise = json['sunrise'],
        sunset = json['sunset'];

  @override
  String toString() {
    return 'City{id: $id, name: $name, coord: $coord, country: $country, timezone: $timezone, sunrise: $sunrise, sunset: $sunset}';
  }
}
