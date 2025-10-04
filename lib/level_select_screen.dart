import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelSelectScreen extends StatefulWidget {
  @override
  _LevelSelectScreenState createState() => _LevelSelectScreenState();
}
class _LevelSelectScreenState extends State<LevelSelectScreen> {
  int maxLevel = 10;
  int unlockedLevel = 1;
  Map<int, int> levelScores = {};
  Map<int, int> levelMedals = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedLevel = prefs.getInt('unlockedLevel') ?? 1;
    });
    for (int i = 1; i <= maxLevel; i++) 
    {
      levelScores[i] = prefs.getInt('score_level_$i') ?? 0;
      levelMedals[i] = prefs.getInt('medal_level_$i') ?? 0;
    }
  }

  String getMedalAsset(int medal) {
    switch (medal) {
      case 1:
        return 'img/bronze.png';
      case 2:
        return 'img/serebro.png';
      case 3:
        return 'img/gold_medal.png';
      default:
        return '';
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('СПИСОК УРОВНЕЙ'), titleTextStyle: GoogleFonts.pressStart2p(fontSize: 15, color: Colors.white,),
    backgroundColor: const Color.fromARGB(255, 151, 39, 173),
    ),
    body: Stack(
      children: [
        // Фоновое изображение
        Positioned.fill(
          child: Image.asset(
            'img/background_for_game.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(22),
          child: GridView.builder(
            itemCount: maxLevel,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final level = index + 1;
              final isUnlocked = level <= unlockedLevel;
              final medal = levelMedals[level] ?? 0;
              return ElevatedButton(
                onPressed: isUnlocked
                    ? () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameScreen(level: level),
                          ),
                        );
                        if (result != null && result is Map) {
                          final int score = result['score'] ?? 0;
                          final int medal = result['medal'] ?? 0;
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('score_level_$level', score);
                          final currentMedal = prefs.getInt('medal_level_$level') ?? 0;
                          if (medal > currentMedal) {
                            await prefs.setInt('medal_level_$level', medal);
                          }
                          if (medal >= 1 && level == unlockedLevel) {
                            await prefs.setInt('unlockedLevel', unlockedLevel + 1);
                          }
                          _loadProgress();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUnlocked ? const Color.fromARGB(255, 139, 47, 135) : const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          '$level',
                          style: GoogleFonts.luckiestGuy(fontSize: 35, color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],),
                        ),
                      ),
                    ),
                    if (medal > 0)
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Image.asset(
                          getMedalAsset(medal),
                          width: 55,
                          height: 55,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}