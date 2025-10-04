import 'package:flutter/material.dart';
///ЧИСТО ЭКСПЕРЕМЕНТ КОТОРЫЙ УДАЧНО РАЗРЕШИЛСЯ!!!
class SleepingPonyWidget extends StatefulWidget {
  @override
  _SleepingPonyWidgetState createState() => _SleepingPonyWidgetState();
}
class _SleepingPonyWidgetState extends State<SleepingPonyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatingAnimation;
  @override
  void initState() 
  {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: -20.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } 
      else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Image.asset(
            'img/poni_sleeping.png',
            width: 350,
            height: 350,
          ),
        );
      },
    );
  }
}
