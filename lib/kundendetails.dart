class Kundendetails {
  final String kundennummer;

  final String name;
  final String strasse;
  final String ort;
  final String plz;
  final String land;

  final String telefon;
  final String fax;
  final String email;
  final String homepage;

  final String zahlungsbedingungNr;
  final String zahlungsbedingung;
  final String lieferbedingungNr;
  final String lieferbedingung;
  final String versandartNr;
  final String versandart;

  Kundendetails({
    required this.kundennummer,
    required this.name,
    required this.strasse,
    required this.ort,
    required this.plz,
    required this.land,
    required this.telefon,
    required this.fax,
    required this.email,
    required this.homepage,
    required this.zahlungsbedingungNr,
    required this.zahlungsbedingung,
    required this.lieferbedingungNr,
    required this.lieferbedingung,
    required this.versandartNr,
    required this.versandart,
  });
}
