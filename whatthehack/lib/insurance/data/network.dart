import 'package:whatthehack/insurance/data/dictionary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:whatthehack/insurance/data/statedictionary.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String BaseURL = "http://whatthehack.herokuapp.com/api";
Future<List<Map<String, dynamic>>> fetchCompleteData() async {
  final response = await http.get(BaseURL + '/dictionary');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    completeData = (jsonData as List)
        .map((e) => Map<String, dynamic>.from(e))
        .cast<Map<String, dynamic>>()
        .toList();
    data = completeData.sublist(0);
    return completeData;
  } else {
    throw Exception("Unable to fetch Data");
  }
}

Future<Map<String, dynamic>> fetchStateStats() async {
  final response = await http.get(BaseURL + '/stateStats');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    stateDictionary = Map<String, dynamic>.from(jsonData);
    return stateDictionary;
  } else {
    throw Exception("Unable to fetch Data");
  }
}

Future<String> convertCoordsToAddress(double lat, double long) async {
  final response =
      await http.get(BaseURL + '/coordsToName?lat=$lat&long=$long');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    String address = jsonData['address'];
    return address;
  } else {
    throw Exception("Address not found");
  }
}

class CrashDetail {
  String address;
  List<dynamic> damagedParts;
  String driver_direction;
  double lat;
  double long;
  String narrative;
  double repairCost;
  String time;

  CrashDetail(
      {this.address,
      this.damagedParts,
      this.driver_direction,
      this.lat,
      this.long,
      this.narrative,
      this.repairCost,
      this.time});
  factory CrashDetail.fromJson(Map<String, dynamic> detail) {
    return CrashDetail(
      address: detail['address'],
      driver_direction: detail['driver_direction'],
      lat: detail['lat'],
      long: detail['long'],
      narrative: detail['narrative'],
      repairCost: detail['repairCost'].toDouble(),
      time: detail['time'],
      damagedParts: (detail['damagedParts'] as List),
    );
  }
}

Future<List<CrashDetail>> fetchCrashDetails() async {
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  if (token?.isEmpty ?? true) {
    throw Exception('User not currently logged in');
  }
  final response = await http.get(BaseURL + '/details?token=$token');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    CrashDetail crashdetail = CrashDetail.fromJson(jsonData);
    return List.generate(5, (index) => crashdetail);
  } else {
    throw Exception('Unable to fetch crash data');
  }
}

Future<String> postDamagedParts(List<String> damagedParts) async {
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  if (token?.isEmpty ?? true) {
    throw Exception('User not currently logged in');
  }
  final response = await http.post(
      'http://whatthehack.herokuapp.com/user/reportCrash?token=$token',
      body: jsonEncode({'damagedParts': damagedParts}),
      headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['msg'];
  } else {
    throw Exception('Server Error');
  }
}

Future<double> fetchDeathRate(double lat, double long) async {
  final response = await http.get(BaseURL + '/deathRate?lat=$lat&long=$long');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return double.parse(jsonData['deathRate']);
  } else {
    throw Exception("Death rate could not be found");
  }
}

class Venue {
  String name;
  double lat;
  double long;
  String address;

  Venue({this.name, this.lat, this.long, this.address});
  factory Venue.fromJson(Map<String, dynamic> venue) {
    return Venue(
        name: venue['name'],
        lat: venue['lat'],
        long: venue['long'],
        address: venue['address']);
  }
}

Future<List<Venue>> fetchNearbyHospitals(double lat, double long) async {
  const int count = 5;
  final response = await http
      .get(BaseURL + '/nearbyHospitals?lat=$lat&long=$long&count=$count');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    List<Venue> hospitals = (jsonData as List)
        .map((e) => Venue.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return hospitals;
  } else {
    throw Exception("No nearby Hospitals found");
  }
}

Future<List<Venue>> fetchNearbyRepairs(double lat, double long) async {
  const int count = 5;
  final response = await http
      .get(BaseURL + '/nearbyRepair?lat=$lat&long=$long&count=$count');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    List<Venue> repairShops = (jsonData as List)
        .map((e) => Venue.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return repairShops;
  } else {
    throw Exception("No nearby repair shops found");
  }
}

Future<String> postLogin(String role) async {
  String email, password;
  if (role == 'driver') {
    email = "user@driver.com";
    password = "admin";
  } else if (role == 'insurance') {
    email = "user@insurance.com";
    password = "admin";
  }
  final response = await http.post(
      "http://whatthehack.herokuapp.com/user/login",
      body: {'email': email, 'password': password});
  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();

    final jsonData = jsonDecode(response.body);
    print(jsonData);
    prefs.setString('token', jsonData['token']);
    prefs.setString('role', jsonData['role']);

    return jsonData['role'];
  } else {
    throw Exception("Login Failed!");
    return null;
  }
}

class Weather {
  String text;
  String analysis;
  String wind_direction;
  String wind_speed;
  String visibility;
  String precipitation;
  bool day_time;
  Weather(
      {this.text,
      this.wind_direction,
      this.wind_speed,
      this.precipitation,
      this.visibility,
      this.analysis,
      this.day_time});
  factory Weather.fromJson(Map<String, dynamic> weather) {
    return Weather(
        text: weather['text'],
        wind_direction: weather['wind_direction'],
        wind_speed: weather['wind_speed'].toString(),
        precipitation: weather['precipitation'],
        analysis: weather['analysis'],
        day_time: weather['day_time']);
  }
}

Future<Weather> fetchWeather() async {
  final response = await http.get(BaseURL + '/weather');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    Weather weather = Weather.fromJson(jsonData['response']);
    return weather;
  } else {
    throw Exception("Weather data could not be found");
  }
}

class Damage {
  String hit_direction;
  double front_hit;
  double rear_hit;
  double left_hit;
  double right_hit;
  double severity;
  bool rollover;
  bool vehicle_spin;
  int num_impacts;
  String analysis;

  Damage(
      {this.hit_direction,
      this.front_hit,
      this.rear_hit,
      this.left_hit,
      this.right_hit,
      this.severity,
      this.rollover,
      this.vehicle_spin,
      this.num_impacts,
      this.analysis});
  factory Damage.fromJson(Map<String, dynamic> damage) {
    return Damage(
      hit_direction: damage['hit_direction'],
      front_hit: damage['front_hit'].toDouble(),
      rear_hit: damage['rear_hit'].toDouble(),
      left_hit: damage['left_hit'].toDouble(),
      right_hit: damage['right_hit'].toDouble(),
      severity: damage['severity'].toDouble(),
      rollover: damage['rollover'],
      vehicle_spin: damage['vehicle_spin'],
      num_impacts: damage['num_impacts'],
      analysis: damage['analysis'],
    );
  }
}

Future<Damage> fetchDamages() async {
  final response = await http.get(BaseURL + '/damages');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return Damage.fromJson(jsonData);
  } else {
    throw Exception("Unable to fetch damages");
  }
}

class Kinematics {
  List<Map<String, double>> speed_curve;
  List<Map<String, double>> accel_lat;
  List<Map<String, double>> accel_lon;
  List<Map<String, double>> accel_vert;
  List<Map<String, double>> force;
  double start_time;
  double stop_time;
  double impact_time;
  double impact_speed;

  Kinematics(
      {this.accel_lat,
      this.accel_lon,
      this.accel_vert,
      this.force,
      this.impact_speed,
      this.impact_time,
      this.speed_curve,
      this.start_time,
      this.stop_time});

  factory Kinematics.fromJson(Map<String, dynamic> kinematics) {
    return Kinematics(
      accel_lat: (kinematics['accel_lat'] as List)
          .map((e) => Map<String, double>.from(
              {'x': e['x'].toDouble(), 'y': e['y'].toDouble()}))
          .toList(),
      accel_lon: (kinematics['accel_lon'] as List)
          .map((e) => Map<String, double>.from(
              {'x': e['x'].toDouble(), 'y': e['y'].toDouble()}))
          .toList(),
      accel_vert: (kinematics['accel_vert'] as List)
          .map((e) => Map<String, double>.from(
              {'x': e['x'].toDouble(), 'y': e['y'].toDouble()}))
          .toList(),
      speed_curve: (kinematics['speed_curve'] as List)
          .map((e) => Map<String, double>.from(
              {'x': e['x'].toDouble(), 'y': e['y'].toDouble()}))
          .toList(),
      force: (kinematics['force'] as List)
          .map((e) => Map<String, double>.from(
              {'x': e['x'].toDouble(), 'y': e['y'].toDouble()}))
          .toList(),
      start_time: kinematics['start_time'].toDouble(),
      stop_time: kinematics['stop_time'].toDouble(),
      impact_time: kinematics['impact_time'].toDouble(),
      impact_speed: kinematics['impact_speed'].toDouble(),
    );
  }
}

Future<Kinematics> getKinematicData() async {
  final response = await http.get(BaseURL + '/kinematics');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return Kinematics.fromJson(jsonData);
  } else {
    throw Exception("Unable to fetch kinematic data");
  }
}

class LegalAdvice {
  String heading;
  String status;
  String advice;

  LegalAdvice({this.advice, this.heading, this.status});
  factory LegalAdvice.fromJson(Map<String, dynamic> legal) {
    return LegalAdvice(
        advice: legal['advice'],
        status: legal['status'],
        heading: legal['heading']);
  }
}

Future<List<LegalAdvice>> fetchLegalAdvice() async {
  final response = await http.get(BaseURL + '/legalities');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return (jsonData as List)
        .map((e) => LegalAdvice.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } else {
    throw Exception("Could not load legal advice");
  }
}

Future<List<Map<String, dynamic>>> fetchAltitudes() async {
  final response = await http.get(BaseURL + '/altitude');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return (jsonData as List).map((e) => Map<String, dynamic>.from(e)).toList();
  } else {
    throw Exception("No altitude data found");
  }
}

Future<String> sendMessages() async {
  final prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  if (token?.isEmpty ?? true) {
    throw Exception('User not currently logged in');
  }
  final response = await http.post(BaseURL + '/sendSms?token=$token');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['msg'];
  } else {
    throw Exception("Unable to send messages");
  }
}

Future<List<Map<String, dynamic>>> fetchRepairInfo() async {
  final response = await http.get(BaseURL + '/repair');
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return (jsonData as List).map((e) => Map<String, dynamic>.from(e)).toList();
  } else {
    throw Exception("No repair information could be found");
  }
}
