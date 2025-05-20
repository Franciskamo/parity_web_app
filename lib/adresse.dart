class Adresse {
  final int ansnr;
  final String name;
  final String telefon;
  final String email;

  Adresse({
    required this.ansnr,
    required this.name,
    required this.telefon,
    required this.email,
  });

  factory Adresse.fromJson(Map<String, dynamic> json) {
    return Adresse(
      ansnr: json['ansnr'] ?? 0,
      name: (json['name001']?.toString()) ?? 'Unbekannter Name',
      telefon: json['telefon']?.toString() ?? '-',
      email: json['email']?.toString() ?? '-',
    );
  }
}

