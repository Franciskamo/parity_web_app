import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parity_web_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ansprechpartner.dart';
import 'kundenuebersicht.dart';
import 'offene_posten.dart';
import 'umsatz_ertrag.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentPage = 'Home';
  String? hoveredPage;

  Future<void> _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('expiresAt');

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double breite = constraints.maxWidth;

        bool nurIcons = breite < 800;
        double sidebarBreite = nurIcons ? 70 : 250;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: Row(
            children: [
              // Sidebar
              Container(
                width: sidebarBreite,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          nurIcons
                              ? 'assets/images/logo_icon.png'
                              : 'assets/images/logo.png',
                          width: nurIcons ? 28 : 203,
                          height: nurIcons ? 28 : 64,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          _buildMenuItem('assets/icons/home.png', 'Home', nurIcons),
                          _buildMenuItem('assets/icons/ku.png', 'Kundenübersicht', nurIcons),
                          _buildMenuItem('assets/icons/ap.png', 'Ansprechpartner', nurIcons),
                          _buildMenuItem('assets/icons/ue.png', 'Umsatz/Ertrag', nurIcons),
                          _buildMenuItem('assets/icons/op.png', 'Offene Posten', nurIcons),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Hauptinhalt
              Expanded(
                child: Column(
                  children: [
                    // Topbar
                    Container(
                      height: 60,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 200,
                                  maxWidth: 500,
                                  minHeight: 30,
                                  maxHeight: 30,
                                ),
                                child: TextField(
                                  cursorColor: const Color(0xFF333333),
                                  cursorWidth: 1.5,
                                  cursorHeight: 20,
                                  cursorRadius: const Radius.circular(10),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                                    hintText: 'Suchen...',
                                    prefixIcon: const Icon(Icons.search),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Color(0xFF333333), width: 0.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Color(0xFF333333), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          PopupMenuButton<String>(
                            offset: const Offset(0, 40),
                            onSelected: (value) {
                              if (value == 'logout') {
                                _logout();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'logout',
                                child: Text('Logout'),
                              ),
                            ],
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFFFFE299),
                              child: Icon(Icons.person, color: Color(0xFF333333)),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Seiteninhalt
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          switch (currentPage) {
                            case 'Home':
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Zuletzt aufgerufen',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          _buildKundenZeile('2184000', 'GMN Paul Müller Industrie GmbH & Co.KG', '0911/5691-323', 'ekspindeln@gmn.de'),
                                          _buildKundenZeile('2184000', 'GMN Paul Müller Industrie GmbH & Co.KG', '0911/5691-323', 'ekspindeln@gmn.de'),
                                          _buildKundenZeile('2184000', 'GMN Paul Müller Industrie GmbH & Co.KG', '0911/5691-323', 'ekspindeln@gmn.de'),
                                          _buildKundenZeile('2184000', 'GMN Paul Müller Industrie GmbH & Co.KG', '0911/5691-323', 'ekspindeln@gmn.de'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            case 'Kundenübersicht':
                              return const Kundenuebersicht();
                            case 'Ansprechpartner':
                              return const Ansprechpartner();
                            default:
                              return const Center(child: Text('Seite nicht gefunden'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(String imagePath, String label, bool nurIcons) {
    bool istAktiv = label == currentPage;
    bool istHover = label == hoveredPage;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredPage = label),
      onExit: (_) => setState(() => hoveredPage = null),
      child: GestureDetector(
        onTap: () => setState(() => currentPage = label),
        child: Container(
          color: istAktiv || istHover ? const Color(0xFFFFE299) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
              if (!nurIcons) ...[
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }Widget _buildKundenZeile(String nummer, String name, String telefon, String email) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(nummer)),
          Expanded(flex: 4, child: Text(name)),
          Expanded(flex: 3, child: Text(telefon)),
          Expanded(flex: 4, child: Text(email)),
        ],
      ),
    );
  }

}
