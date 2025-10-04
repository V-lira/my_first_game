import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SkinSelectScreen extends StatefulWidget {
  @override
  _SkinSelectScreenState createState() => _SkinSelectScreenState();
}
class _SkinSelectScreenState extends State<SkinSelectScreen> {
  final List<String> skinFiles = [
    'just.png',
    'unicorn.png',
    'korol.png',
    'rainbow.png',
    'nerdi.png',
    'pink.png',
    'blue.png',
  ];

  final Map<String, String> skinNames = {
    'just.png': 'ПИКСЕЛЬНЫЙ ПОНИ',
    'unicorn.png': 'ПОНИ С РОГОМ',
    'korol.png': 'КОРОЛЬ ПОНИ',
    'rainbow.png': 'РАДУЖНАЯ ГРИВА',
    'nerdi.png': 'УМНЯШКА ПОНИ',
    'pink.png': 'РОЗОВЫЙ ПОНИ',
    'blue.png': 'СИНИЙ ПОНИ',
  };

  String selectedSkin = 'just.png';

  @override
  void initState() {
    super.initState();
    loadSkin();
  }

  Future<void> loadSkin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedSkin = prefs.getString('selectedSkin') ?? 'just.png';
    });
  }

  Future<void> saveSkin(String skin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSkin', skin);
    setState(() {
      selectedSkin = skin;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ТЫ ВЫБРАЛ: ${skinNames[skin] ?? skin}', style: GoogleFonts.pressStart2p(shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)], fontSize: 10)),
        duration: Duration(seconds: 2),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('ВЫБЕРИ ПОНИ'),
      titleTextStyle: GoogleFonts.pressStart2p(fontSize: 15, color: Colors.white, 
      ),
      backgroundColor: const Color.fromARGB(255, 151, 39, 173),
    ),
    body: Stack(
  children: [
    Positioned.fill(
      child: Image.asset(
        'img/background_for_game.jpg',
        fit: BoxFit.cover,
      ),
    ),
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              'ТВОЙ ПОНИ СЕЙЧАС:',
              style: GoogleFonts.pressStart2p(
                fontSize: 25,
                color: Colors.white,
                shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Image.asset('img/$selectedSkin', height: 160),
            Text(
              skinNames[selectedSkin] ?? '',
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: skinFiles.map((skin) {
                  final isSelected = skin == selectedSkin;
                  return GestureDetector(
                    onTap: () => saveSkin(skin),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? const Color.fromARGB(255, 156, 66, 144) 
                              : const Color.fromARGB(0, 0, 0, 0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Image.asset('img/$skin', height: 60),
                              SizedBox(height: 5),
                              Text(
                                skinNames[skin] ?? '',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 12,
                                  color: Colors.white,
                                  shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(Icons.check_circle, color: const Color.fromARGB(255, 175, 76, 106)),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
));
}
}
