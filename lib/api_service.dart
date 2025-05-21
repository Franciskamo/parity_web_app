// Erweiterter API-Service mit vollständigen Daten für Kundenübersicht

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'adresse.dart';
import 'kunde.dart';
import 'zahlbed.dart';
import 'liefbed.dart';
import 'versart.dart';

class KundeMitAdresse {
  final String kundennummer;
  final String name;
  final String strasse;
  final String plz;
  final String ort;
  final String land;
  final String telefon;
  final String fax;
  final String email;
  final String homepage;
  final String zahlungsNr;
  final String zahlungsText;
  final String lieferNr;
  final String lieferText;
  final String versandNr;
  final String versandText;

  KundeMitAdresse({
    required this.kundennummer,
    required this.name,
    required this.strasse,
    required this.plz,
    required this.ort,
    required this.land,
    required this.telefon,
    required this.fax,
    required this.email,
    required this.homepage,
    required this.zahlungsNr,
    required this.zahlungsText,
    required this.lieferNr,
    required this.lieferText,
    required this.versandNr,
    required this.versandText,
  });
}

Future<List<KundeMitAdresse>> ladeKombinierteKunden() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final headers = {'Authorization': 'Bearer $token'};

  final kundenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/kunden'),
    headers: headers,
  );

  final adressenResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/adressen'),
    headers: headers,
  );

  final kundenJson = json.decode(kundenResponse.body);
  final adressenJson = json.decode(adressenResponse.body);

  final kunden = (kundenJson as List).map((k) => Kunde.fromJson(k)).toList();
  final adressen = (adressenJson as List).map((a) => Adresse.fromJson(a)).toList();

  List<KundeMitAdresse> kombiniert = [];

  for (Kunde kunde in kunden) {
  Adresse adresse = adressen.firstWhere(
    (a) => a.ansnr == kunde.id,
    orElse: () => Adresse.leer(),
  );

  final zahlbedResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/zahlungsbedingungen/${kunde.kdnZbnr}'),
    headers: headers,
  );
  final decodedZahlung = json.decode(zahlbedResponse.body);
  final zahlung = Zahlbed.fromJson(decodedZahlung[0]);

  final liefbedResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/lieferbedingungen/${kunde.kdnLbdnr}'),
    headers: headers,
  );
  final decodedLiefer = json.decode(liefbedResponse.body);
  final liefer = Liefbed.fromJson(decodedLiefer[0]);

  final versartResponse = await http.get(
    Uri.parse('https://api.parity-software.com/api/v1/versandarten/${kunde.kdnVsanr}'),
    headers: headers,
  );
  final decodedVersand = json.decode(versartResponse.body);
  final versand = Versart.fromJson(decodedVersand[0]);

  kombiniert.add(KundeMitAdresse(
    kundennummer: kunde.kontonummer,
    name: adresse.name,
    strasse: adresse.strasse,
    plz: adresse.plz,
    ort: adresse.ort,
    land: adresse.land,
    telefon: adresse.telefon,
    fax: adresse.telefax,
    email: adresse.email,
    homepage: adresse.homepage,
    zahlungsNr: zahlung.zbdNr.toString(),
    zahlungsText: zahlung.zbdBez,
    lieferNr: liefer.lbdNr.toString(),
    lieferText: liefer.lbdBez,
    versandNr: versand.vsaNr.toString(),
    versandText: versand.vsaBez,
  ));
}


  return kombiniert;
}