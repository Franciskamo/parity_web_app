class AnsprechpartnerModel {
  String nachname;
  String vorname;
  String abteilung;
  String telefon;
  String email;

  AnsprechpartnerModel({
    required this.nachname,
    required this.vorname,
    required this.abteilung,
    required this.telefon,
    required this.email,
  });

  factory AnsprechpartnerModel.fromJson(Map<String, dynamic> json) {
    return AnsprechpartnerModel(
      nachname: json['anpAnspr'] ?? '',
      vorname: json['anpVorname'] ?? '',
      abteilung: json['anpAbteilung'] ?? '',
      telefon: json['anpTelefon'] ?? '',
      email: json['anpEmail'] ?? '',
    );
  }

  static AnsprechpartnerModel leer() => AnsprechpartnerModel(
    nachname: '',
    vorname: '',
    abteilung: '',
    telefon: '',
    email: '',
  );
}
