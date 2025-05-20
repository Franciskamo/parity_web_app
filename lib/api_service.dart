import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'adresse.dart';
import 'kunde.dart';

class KundeMitAdresse {
  final String kundennummer;
  final String name;
  final String telefon;
  final String email;

  KundeMitAdresse({
    required this.kundennummer,
    required this.name,
    required this.telefon,
    required this.email,
  });
}

Future<List<KundeMitAdresse>> ladeKombinierteKunden() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final kundenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/kunden'),
    headers: {'Authorization': 'Bearer $token'},
  );

  final adressenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/adressen'),
    headers: {'Authorization': 'Bearer $token'},
  );

  final kundenJson = json.decode(kundenResponse.body);
  final adressenJson = json.decode(adressenResponse.body);

  final kunden = (kundenJson as List)
      .where((k) => k['kdnLfdnr'] != null && k['kdnKontonr'] != null)
      .map((k) => Kunde.fromJson(k))
      .toList();

  final adressen = (adressenJson as List)
      .map((a) => Adresse.fromJson(a))
      .toList();

  List<KundeMitAdresse> kombiniert = [];

  for (Kunde kunde in kunden) {
    Adresse? adresse;
    try {
      adresse = adressen.firstWhere((a) => a.ansnr == kunde.id);
    } catch (e) {
      adresse = null;
    }

    kombiniert.add(
      KundeMitAdresse(
        kundennummer: kunde.kontonummer,
        name: adresse?.name ?? 'keine Adresse vorhanden',
        telefon: adresse?.telefon ?? '-',
        email: adresse?.email ?? '-',
      ),
    );
  }

  return kombiniert;
}
