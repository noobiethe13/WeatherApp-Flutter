//Model for storing weather data based on API response

class WeatherModel {
  Location location;
  Current current;

  WeatherModel({required this.location, required this.current});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: Location.fromJson(json['location'] ?? {}),
      current: Current.fromJson(json['current'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'current': current.toJson(),
    };
  }
}

class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      tzId: json['tz_id'] ?? '',
      localtime: json['localtime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'tz_id': tzId,
      'localtime': localtime,
    };
  }
}

class Current {
  String lastUpdated;
  double tempC;
  double tempF;
  int isDay;
  Condition condition;
  double windMph;
  double windKph;
  int windDegree;
  String windDir;
  int pressureMb;
  double pressureIn;
  double precipMm;
  double precipIn;
  int humidity;
  int cloud;
  double feelslikeC;
  double feelslikeF;
  int visKm;
  int visMiles;
  int uv;
  double gustMph;
  double gustKph;
  AirQuality airQuality;

  Current({
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    required this.airQuality,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      lastUpdated: json['last_updated'] ?? '',
      tempC: (json['temp_c'] ?? 0.0).toDouble(),
      tempF: (json['temp_f'] ?? 0.0).toDouble(),
      isDay: json['is_day'] ?? 0,
      condition: Condition.fromJson(json['condition'] ?? {}),
      windMph: (json['wind_mph'] ?? 0.0).toDouble(),
      windKph: (json['wind_kph'] ?? 0.0).toDouble(),
      windDegree: (json['wind_degree'] ?? 0).toInt(),
      windDir: json['wind_dir'] ?? '',
      pressureMb: (json['pressure_mb'] ?? 0).toInt(),
      pressureIn: (json['pressure_in'] ?? 0.0).toDouble(),
      precipMm: (json['precip_mm'] ?? 0.0).toDouble(),
      precipIn: (json['precip_in'] ?? 0.0).toDouble(),
      humidity: (json['humidity'] ?? 0).toInt(),
      cloud: (json['cloud'] ?? 0).toInt(),
      feelslikeC: (json['feelslike_c'] ?? 0.0).toDouble(),
      feelslikeF: (json['feelslike_f'] ?? 0.0).toDouble(),
      visKm: (json['vis_km'] ?? 0).toInt(),
      visMiles: (json['vis_miles'] ?? 0).toInt(),
      uv: (json['uv'] ?? 0).toInt(),
      gustMph: (json['gust_mph'] ?? 0.0).toDouble(),
      gustKph: (json['gust_kph'] ?? 0.0).toDouble(),
      airQuality: AirQuality.fromJson(json['air_quality'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_updated': lastUpdated,
      'temp_c': tempC,
      'temp_f': tempF,
      'is_day': isDay,
      'condition': condition.toJson(),
      'wind_mph': windMph,
      'wind_kph': windKph,
      'wind_degree': windDegree,
      'wind_dir': windDir,
      'pressure_mb': pressureMb,
      'pressure_in': pressureIn,
      'precip_mm': precipMm,
      'precip_in': precipIn,
      'humidity': humidity,
      'cloud': cloud,
      'feelslike_c': feelslikeC,
      'feelslike_f': feelslikeF,
      'vis_km': visKm,
      'vis_miles': visMiles,
      'uv': uv,
      'gust_mph': gustMph,
      'gust_kph': gustKph,
      'air_quality': airQuality.toJson(),
    };
  }
}

class Condition {
  String text;
  String icon;
  int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'] ?? '',
      icon: json['icon'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'icon': icon,
      'code': code,
    };
  }
}

class AirQuality {
  double co;
  double no2;
  double o3;
  double so2;
  double pm2_5;
  double pm10;
  int usEpaIndex;
  int gbDefraIndex;

  AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: (json['co'] ?? 0.0).toDouble(),
      no2: (json['no2'] ?? 0.0).toDouble(),
      o3: (json['o3'] ?? 0.0).toDouble(),
      so2: (json['so2'] ?? 0.0).toDouble(),
      pm2_5: (json['pm2_5'] ?? 0.0).toDouble(),
      pm10: (json['pm10'] ?? 0.0).toDouble(),
      usEpaIndex: (json['us-epa-index'] ?? 0).toInt(),
      gbDefraIndex: (json['gb-defra-index'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co': co,
      'no2': no2,
      'o3': o3,
      'so2': so2,
      'pm2_5': pm2_5,
      'pm10': pm10,
      'us-epa-index': usEpaIndex,
      'gb-defra-index': gbDefraIndex,
    };
  }
}
