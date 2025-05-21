class Kunde {
  final int id;
  final String kontonummer;

  Kunde({
    required this.id,
    required this.kontonummer,
  });

  factory Kunde.fromJson(Map<String, dynamic> json) {
    return Kunde(
      id: json['id'] ?? 0, 
      kontonummer: json['kdnKontonr']?.toString() ?? 'unbekannt',
    );
  }

}
