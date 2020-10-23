import 'package:flutter/cupertino.dart';

class Particle {
  double x;
  double y;
  double radius;
  double speed ;
  double runDistance;
  int alpha;
  Color color;
  int maxDistance = 200;
  int angle;
  Particle({
    this.x,this.y,this.radius,this.speed,this.runDistance,this.alpha,this.color,this.maxDistance,this.angle
  });
  Particle.fromParticle(Particle particle) {
    this.x = particle.x;
    this.y = particle.y;
    this.radius = particle.radius;
    this.speed = particle.speed;
    this.runDistance = particle.runDistance;
    this.alpha = particle.alpha;
    this.color=particle.color;
    this.maxDistance = particle.maxDistance;
    this.angle = particle.angle;
  }
}