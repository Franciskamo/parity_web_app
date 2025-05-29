import 'package:flutter/material.dart';
import 'api_service.dart'; 

class Kundenuebersicht extends StatelessWidget {
  final KundeMitAdresse? kunde;

  const Kundenuebersicht({Key? key, required this.kunde}) : super(key: key);

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

          // Kundenname und kundennummer anzeigen
          Text(
            kunde!.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            kunde!.kundennummer,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              final anschriftCard = buildInfoCard("Anschrift", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  buildTextZeile("Name", kunde!.name),
                  buildTextZeile("Straße", kunde!.strasse),
                  buildTextZeile("Ort", "${kunde!.plz} ${kunde!.ort}"),
                  buildTextZeile("Land", kunde!.land),

                ],
              ));

              final kontaktCard = buildInfoCard("Kontakt", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextZeile("Telefon", kunde!.telefon),
                  buildTextZeile("Fax", kunde!.fax),
                  buildTextZeile("E-Mail", kunde!.email),
                  buildTextZeile("Webseite", kunde!.homepage),

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

          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              final konditionenCard = buildInfoCard("Konditionen & Zuständigkeiten", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextZeile("Zahlungsbedingung", "${kunde!.zahlungsNr} | ${kunde!.zahlungsText}"),
                  buildTextZeile("Lieferbedingung", "${kunde!.lieferNr} | ${kunde!.lieferText}"),
                  buildTextZeile("Versandart", "${kunde!.versandNr} | ${kunde!.versandText}"),

                  SizedBox(height: 8),
                ],
              ));

              return isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: konditionenCard),
                          const SizedBox(width: 16),
                          const Expanded(child: SizedBox()), 
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
  Widget buildTextZeile(String label, String wert) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text("$label:", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          
          Expanded(
            child: Text(
              wert,
              softWrap: false, 
            ),
          ),
        ],
      ),
    );
  }

}
