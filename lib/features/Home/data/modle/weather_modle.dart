class WeatherModel {
  final String city;
  final double temp;
  final String description;
   final String country;

  WeatherModel({required this.country,required this.city, required this.temp, required this.description});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temp: (json['main']['temp'] as num).toDouble(), // التأكد من تحويلها لـ double
       country: json['sys']['country'],
      description: json['weather'][0]['main'], // استبدلت `main` بـ `description` عشان تكون أدق
    );
  }

  @override
String toString() {
  return 'WeatherModel(city: $city, temp: $temp, description: $description)';
}
}
