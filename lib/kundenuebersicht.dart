import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ansprechpartner.dart';
import 'offene_posten.dart';
import 'umsatz_ertrag.dart';
import 'home_page.dart';


class Kundenuebersicht extends StatelessWidget {
  const Kundenuebersicht({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs
          Row(
            children: const [
              Text("Home", style: TextStyle(color: Color(0xFF333333))),
              Text(" > "),
              Text("Kundenübersicht", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          // Titel
          const Text(
            "GMN Paul Müller Industrie GmbH & Co. KG",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "2184000",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          //Anschrift + Kontakt
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              final anschriftCard = buildInfoCard("Anschrift", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("GMN Paul Müller\nIndustrie GmbH & Co.KG"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Straße", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("Äußere Bayreuther Str. 230"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Ort", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("90411 Nürnberg"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Land", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("Deutschland"),
                        ),
                      ),
                    ],
                  ),
                ],
              ));

              final kontaktCard = buildInfoCard("Kontakt", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Telefon", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("0911/5691-323"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Fax", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("0911/5691-501"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("E-Mail", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("ekspindeln@gmn.de"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Webseite", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text("www.gmn.de"),
                        ),
                      ),
                    ],
                  ),
                ],
              ));

              return isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: anschriftCard),
                          const SizedBox(width: 16),
                          Expanded(child: kontaktCard),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        anschriftCard,
                        const SizedBox(height: 16),
                        kontaktCard,
                      ],
                    );
            },
          ),


          const SizedBox(height: 16),

          // Konditionen (+leer)
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              final konditionenCard = buildInfoCard("Konditionen & Zuständigkeiten", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text("Zahlungsbedingung", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text("10 Tage 3 %, 30 Tage netto"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text("Lieferbedingung", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text("unfrei, ab 250,- EUR frei Haus"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text("Versandart", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text("Deutsche Post Paket"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text("Vertreter", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text("Norman Reuter"),
                        ),
                      ),
                    ],
                  ),
                ],
              ));

              return isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: konditionenCard),
                          const SizedBox(width: 16),
                          const Expanded(child: SizedBox()), // Ausgleichsbox
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        konditionenCard,
                      ],
                    );
            },
          ),

        ],
      ),
    );
  }

  Widget buildInfoCard(String title, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFFFCD00),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}
