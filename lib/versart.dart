class Versart {
  final int vsaNr;
  final String vsaBez;

  Versart({
    required this.vsaNr,
    required this.vsaBez,
  });

  factory Versart.fromJson(Map<String, dynamic> json) {
    return Versart(
      vsaNr: json['vsaNr'] ?? 0,
      vsaBez: json['vsaBez'] ?? '',
    );
  }

  factory Versart.leer() {
  return Versart(
    vsaNr: 0,
    vsaBez: '',
  );
}

}
