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

          // Titel
          Text(
            kunde!.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            kunde!.kundennummer,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          //Anschrift + Kontakt
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              final anschriftCard = buildInfoCard("Anschrift", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
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
                          child: Text(kunde!.name),
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
                          child: Text(kunde!.strasse),
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
                          child: Text("${kunde!.plz} ${kunde!.ort}"),
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
                          child: Text(kunde!.land),
                        ),
                      ),
                    ],
                  ),
                ],
              ));

              final kontaktCard = buildInfoCard("Kontakt", Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text("Telefon", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 85),
                          child: Text(kunde!.telefon),
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
                          child: Text(kunde!.fax),
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
                          child: Text(kunde!.email),
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
                          child: Text(kunde!.homepage),
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
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text("Zahlungsbedingung", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 45),
                          child: Text("${kunde!.zahlungsNr} | ${kunde!.zahlungsText}"),
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
                          child: Text("${kunde!.lieferNr} | ${kunde!.lieferText}"),
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
                          child: Text("${kunde!.versandNr} | ${kunde!.versandText}"),
                        ),
                      ),
                    ],
                  ),
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
}
