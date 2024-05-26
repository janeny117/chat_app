class Weather {
  final String description;
  final String icon; // 아이콘 속성 추가
  final double temperature;

  Weather({required this.description, required this.icon, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'], // 아이콘 데이터 가져오기
      temperature: json['main']['temp'],
    );
  }
}
