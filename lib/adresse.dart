class Adresse {
  final int ansnr;
  final String name;
  final String telefon;
  final String email;
  final String strasse;
  final String plz;
  final String ort;
  final String land;
  final String telefax;
  final String homepage;

  Adresse({
    required this.ansnr,
    required this.name,
    required this.telefon,
    required this.email,
    required this.strasse,
    required this.plz,
    required this.ort,
    required this.land,
    required this.telefax,
    required this.homepage,
  });

  factory Adresse.fromJson(Map<String, dynamic> json) {
    return Adresse(
      ansnr: json['ansnr'] ?? 0,
      name: (json['name001']?.toString()) ?? 'Unbekannter Name',
      telefon: json['ansTelefon']?.toString() ?? '-',
      telefax: json['ansTelefax'] ?? '',
      email: json['ansEmail']?.toString() ?? '-',
      strasse: json['strasse'] ?? '',
      plz: json['plz'] ?? '',
      ort: json['ort'] ?? '',
      land: json['land'] ?? '',
      homepage: json['ansHomepage'] ?? '',
    );
  }
  static Adresse leer() => Adresse(
  ansnr: 0,
  name: '',
  strasse: '',
  plz: '',
  ort: '',
  land: '',
  telefon: '',
  telefax: '',
  email: '',
  homepage: '',
);

}

