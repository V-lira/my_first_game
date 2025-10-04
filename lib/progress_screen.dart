import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}
class _ProgressScreenState extends State<ProgressScreen> {
  int totalScore = 0;
  int gold = 0;
  int silver = 0;
  int bronze = 0;
  int maxLevel = 1;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    int scoreSum = 0;
    int g = 0, s = 0, b = 0;
    for (int i = 1; i <= 10; i++) {
      final medal = prefs.getInt('medal_level_$i') ?? 0;
      final levelScore = prefs.getInt('score_level_$i') ?? 0;
      scoreSum += levelScore;
      if (medal == 3) 
      g++;
      else if (medal == 2) 
      s++;
      else if (medal == 1)
       b++;
    }
    setState(() {
      totalScore = scoreSum;
      gold = g;
      silver = s;
      bronze = b;
      maxLevel = prefs.getInt('unlockedLevel') ?? 1;
    });
  }

@override
Widget build(BuildContext context)
 {
  return Scaffold(
    appBar: AppBar(
      title: Text('ТВОЯ СТАТИСТИКА'),
      titleTextStyle: GoogleFonts.pressStart2p(fontSize: 15, color: Colors.white,),
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
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('ВЕСЬ ТВОЙ СЧЁТ СОСТАВЛЯЕТ: $totalScore',
                    style: GoogleFonts.pressStart2p(fontSize: 22, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],)),
                SizedBox(height: 12),
                Text('МАКСИМАЛЬНЫЙ УРОВЕНЬ НА ДАННЫЙ МОМЕНТ: $maxLevel',
                    style: GoogleFonts.pressStart2p(fontSize: 22, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],)),
                SizedBox(height: 24),
                Text('ТВОИ ПОЛУЧЕННЫЕ МЕДАЛИ:',
                    style: GoogleFonts.pressStart2p(fontSize: 22, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset('img/gold_medal.png', width: 45, height: 45),
                    SizedBox(width: 8),
                    Text('x $gold',
                        style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],)),
                  ],
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    Image.asset('img/serebro.png', width: 45, height: 45),
                    SizedBox(width: 8),
                    Text('x $silver',
                        style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],)),
                  ],
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    Image.asset('img/bronze.png', width: 45, height: 45),
                    SizedBox(width: 8),
                    Text('x $bronze',
                        style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}