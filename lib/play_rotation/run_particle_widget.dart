import 'package:drawing_interface_learning/play_rotation/model/Particle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RunParticleWidget extends CustomPainter{
  List<Particle> _particles;//粒子集合
  Paint mPaint; //主画笔
  Rect _area ;
  Paint bgPaint; //背景画笔
  Paint linePaint; //主画笔
  RunParticleWidget(this._particles){
    mPaint = new Paint();
    bgPaint = new Paint()..color = Colors.orange;
  }
  @override
  void paint(Canvas canvas, Size size) {
    _particles.forEach((particle) {
      _drawParticle(canvas, particle);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  void _drawParticle(Canvas canvas, Particle particle) {
    canvas.drawCircle(
        Offset(particle.x, particle.y), particle.radius, mPaint..color = particle.color);
  }
}