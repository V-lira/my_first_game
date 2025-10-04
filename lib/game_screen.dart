import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  final int level;
  const GameScreen({required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}
class _GameScreenState extends State<GameScreen> {
  double ponyY = 0;
  double skorost_dvijenia = 0;
  double gravity = 0.15;
  double jump = -1;
  List<double> columnX = [1.5, 3.0];
  List<double> gapY = [0.3, 0.6];
  int score = 0;
  int bestScore = 0;
  bool gameStarted = false;
  bool gameOver = false;
  bool levelCompleted = false;
  Timer? gameTimer;
  String countdownText = '';
  bool showingCountdown = true;
  String ponySkin = 'just.png';
  int get targetScore => 30 + (widget.level - 1) * 10;
  @override
  void initState() {
    super.initState();
    loadSelectedSkin();
    loadBestScore();
    startCountdown();
  }
  Future<void> loadSelectedSkin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ponySkin = prefs.getString('selectedSkin') ?? 'just.png';
    });
  }
  Future<void> loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt('bestScore') ?? 0;
    });
  }
  Future<void> saveBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > bestScore) {
      await prefs.setInt('bestScore', score);
    }
  }

  void startCountdown() async {
    List<String> countdown = ['3', '2', '1', 'GO!'];
    for (var value in countdown) {
      setState(() {
        countdownText = value;
      });
      await Future.delayed(Duration(seconds: 1));
    }
    setState(() {
      showingCountdown = false;
    });
    startGame();
  }

  double get gapHeight {
  double baseGap = 0.55;
  double gap = baseGap - (widget.level - 1) * 0.01;
  return gap.clamp(0.35, 0.65);
    //return 0.55;
  }

  void startGame() {
    gameStarted = true;
    gameTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        skorost_dvijenia += gravity;
        ponyY += skorost_dvijenia * 0.02;
        for (int i = 0; i < columnX.length; i++) 
        {
          columnX[i] -= 0.02;
          if (columnX[i] < -0.5) 
          {
            columnX[i] += 3.0;
            gapY[i] = Random().nextDouble() * (1 - gapHeight);
          }
          if (columnX[i] + 0.15 < 0.0 && !gameOver) 
          {
            score++;
          }
          if (checkCollision(i))
         {
            endGame(false);
            return;
          }
        }
        if (ponyY > 1 || ponyY < -1) 
        {
          endGame(false);
          return;
        }
        if (score >= targetScore) 
        {
          endGame(true);
          return;
        }
      });
    });
  }
  bool checkCollision(int i) {
    double ponyLeft = 0.2;
    double ponyRight = 0.2 + 0.1;
    double colLeft = columnX[i];
    double colRight = columnX[i] + 0.15;
    if (ponyRight > colLeft && ponyLeft < colRight) {
      double gapTop = gapY[i];
      double gapBottom = gapY[i] + gapHeight;
      double normalizedPonyY = (ponyY + 1) / 2;
      if (normalizedPonyY < gapTop || normalizedPonyY > gapBottom) 
      {
        return true;
      }
    }
    return false;
  }
  void endGame(bool completed) async {
    gameTimer?.cancel();
    await saveBestScore();
    setState(() {
      gameOver = true;
      levelCompleted = completed;
    });
  }
  void flap() {
    if (gameOver || showingCountdown) 
    return;
    setState(() {
      skorost_dvijenia = jump;
    });
  }
  void restartGame() {
    setState(() {
      ponyY = 0;
      skorost_dvijenia = 0;
      columnX = [1.5, 3.0];
      gapY = [0.3, 0.6];
      score = 0;
      gameOver = false;
      gameStarted = false;
      countdownText = '';
      showingCountdown = true;
    });
    startCountdown();
  }
  Widget getMedalWidget() {
    String? medalAsset;
    if (score >= targetScore) 
    {
      medalAsset = 'img/gold_medal.png';
    }
    else if (score >= targetScore * 0.7) 
    {
      medalAsset = 'img/serebro.png';
    }
    else if (score >= targetScore * 0.4)
     {
      medalAsset = 'img/bronze.png';
    }
    if (medalAsset != null) {
      return Column(
        children: [
          Image.asset(medalAsset, width: 100, height: 100),
          SizedBox(height: 10),
          Text(
            'ПОЛУЧЕНА МЕДАЛЬКА! :)',
            style: GoogleFonts.pressStart2p(color: const Color.fromARGB(255, 255, 255, 255), shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)], fontSize: 15),
          ),
        ],
      );
    } 
    else
     {
      return Text(
        'МЕДАЛЬКА НЕ ПОЛУЧЕНА! :(',
        style: GoogleFonts.pressStart2p(color: const Color.fromARGB(255, 255, 255, 255), shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)], fontSize: 15 ) ,
      );
    }
  }

  Widget buildColumns(double screenHeight, double screenWidth) {
    List<Widget> columns = [];
    for (int i = 0; i < columnX.length; i++) {
      columns.add(Positioned(
        left: screenWidth * columnX[i],
        top: 0,
        child: SizedBox(
          width: 150,
          height: screenHeight * gapY[i],
          child: Image.asset('img/column_top.png', fit: BoxFit.fill),
        ),
      ));
      columns.add(Positioned(
        left: screenWidth * columnX[i],
        top: screenHeight * (gapY[i] + gapHeight),
        child: SizedBox(
          width: 150,
          height: screenHeight * (1 - gapY[i] - gapHeight),
          child: Image.asset('img/column_bottom.png', fit: BoxFit.fill),
        ),
      ));
    }

    return Stack(children: columns);
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: flap,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('img/background_for_game.jpg', fit: BoxFit.cover),
            ),
            Positioned(
              left: 60,
              top: h * (ponyY + 0.5),
              child: Image.asset('img/$ponySkin', width: 150, height: 150),
            ),
            buildColumns(h, w),
            Positioned(
              top: 50,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ТВОЙ СЧЁТ СОСТАВЛЯЕТ: $score',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 15,
                      color: Colors.white,
                      shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],
                    ),
                  ),
                  Text(
                    'ЦЕЛЬ: $targetScore',
                    style: GoogleFonts.pressStart2p(fontSize: 12,
                      color: Colors.white, shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)],
                    ),
                  ),
                ],
              ),
            ),
            if (showingCountdown)
              Center(
                child: Text(
                  countdownText,
                  style: GoogleFonts.pressStart2p(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 6, color: const Color.fromARGB(255, 123, 46, 104)
                    )],
                  ),
                ),
              ),
            if (gameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      levelCompleted ? 'УСПЕШНО!' : 'ПРОВАЛ...',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: levelCompleted 
                        ? const Color.fromARGB(255, 123, 46, 104) 
                        : const Color.fromARGB(255, 0, 0, 0),
                        shadows: [Shadow(blurRadius: 4, color: const Color.fromARGB(255, 252, 157, 220))],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ТВОЙ РЕКОРД: $bestScore',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 15,
                        color: Colors.white,
                        shadows: [Shadow(color: const Color.fromARGB(255, 123, 46, 104), blurRadius: 15)]
                      ),
                    ),
                    SizedBox(height: 10),
                    getMedalWidget(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: restartGame,
                      child: Text('ПЕРЕИГРАТЬ!', style: GoogleFonts.pressStart2p(fontSize: 12)),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context,
                         {
                          'completed': levelCompleted,
                          'medal': score >= targetScore
                              ? 3
                              : score >= targetScore * 0.7
                                  ? 2
                                  : score >= targetScore * 0.4
                                      ? 1
                                      : 0,
                          'score': score,
                        });
                      },
                      child: Text('К УРОВНЯМ!', style: GoogleFonts.pressStart2p(fontSize: 12)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
