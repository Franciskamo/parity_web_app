class Kunde {
  String name;
  final int kdnLfdnr;
  final int id;
  final String kontonummer;
  final int kdnZbnr;
  final int kdnLbdnr;
  final int kdnVsanr;

  Kunde({
    required this.kdnLfdnr,
    required this.id,
    required this.kontonummer,
    required this.kdnZbnr,
    required this.kdnLbdnr,
    required this.kdnVsanr,
    this.name = '',
  });

  factory Kunde.fromJson(Map<String, dynamic> json) {
    return Kunde(

      kdnLfdnr: json['kdnLfdnr'] ?? 0,
      id: json['id'] ?? 0, 
      kontonummer: json['kdnKontonr']?.toString() ?? 'unbekannt',
      kdnZbnr: json['kdnZbnr'] ?? 0,
      kdnLbdnr: json['kdnLbdnr'] ?? 0,
      kdnVsanr: json['kdnVsanr'] ?? 0,

    );
  }

}
