class Kunde {
  final int id;
  final String kontonummer;
  final int kdnZbnr;
  final int kdnLbdnr;
  final int kdnVsanr;


  Kunde({
    required this.id,
    required this.kontonummer,
    required this.kdnZbnr,
    required this.kdnLbdnr,
    required this.kdnVsanr,
  });

  factory Kunde.fromJson(Map<String, dynamic> json) {
    return Kunde(
      id: json['id'] ?? 0, 
      kontonummer: json['kdnKontonr']?.toString() ?? 'unbekannt',
      kdnZbnr: json['kdnZbnr'] ?? 0,
      kdnLbdnr: json['kdnLbdnr'] ?? 0,
      kdnVsanr: json['kdnVsanr'] ?? 0,

    );
  }

}
