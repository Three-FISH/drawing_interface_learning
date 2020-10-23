import 'dart:math';
import 'dart:ui';

import 'package:drawing_interface_learning/play_rotation/model/Particle.dart';
import 'package:drawing_interface_learning/play_rotation/run_particle_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayRotationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PlayRotationPage();
  }
}
class _PlayRotationPage extends State<PlayRotationPage> with TickerProviderStateMixin{
  AnimationController _controller;
  AnimationController _picController;
  bool flag = true;
  var _particles = <Particle>[];


  @override
  void initState() {
    super.initState();
    Random random = Random();
    Random randomY = Random();
    for (var i = 0; i < 800; i++) {
      int circleAngle = random.nextInt(359)+1;
      int circleRange = random.nextInt(80)+1;
      double tempX = (80+circleRange)*cos(circleAngle);
      double tempY = (80+circleRange)*sin(circleAngle);
      _particles.add(Particle(
          color: Colors.white.withAlpha(random.nextInt(255)),
          //color:Colors.randomRGB();
          radius:1.5 * random.nextDouble(),
          speed: 4*randomY.nextDouble(),
          x: 220+tempX,
          runDistance: 1,
          angle: circleAngle,
          y: 300+tempY));
    }
    _controller = AnimationController(duration: Duration(days: 999*365),vsync: this);
    _picController = AnimationController(duration: Duration(seconds:20 ),vsync: this);
   /* _controller.addListener(() {
      _render();
    });*/
    _picController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _picController.reset();
        _picController.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _picController.dispose();
  }

  _render(){
    for (var i = 0; i < _particles.length; i++) {
      updateParticle(i);
    }
  }

  void updateParticle(int i){
    var particle = _particles[i];
    particle.x += particle.speed*cos(particle.angle);
    particle.y += particle.speed*sin(particle.angle);
    particle.runDistance += particle.speed;
    //限定下边界
    if (particle.runDistance > 80) {
      particle.x = 220+100*cos(particle.angle);
      particle.y = 300+100*sin(particle.angle);
      particle.runDistance = 1 ;
    }

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Image.asset(
              "images/play_image.jpg",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter:ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: Colors.black12,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context,Widget child){
                 _render();
                return Container(
                  child:  CustomPaint(
                    painter: RunParticleWidget(_particles),
                  ),
                );
              },

            ),
            Container(
              padding: EdgeInsets.fromLTRB(130, 212, 0, 0),
              child: RotationTransition(
                turns: _picController,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width:180,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/rotation_pic.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(200)),
                      ),
                    )
                  ],
                ),
              ),
            )

          ],

        ),
      ),
      onTap: (){
        if(flag == true){
          _controller.forward();
          _picController.forward();
          flag = false;
        }else{
          _controller.stop();
          _picController.stop();
          flag = true;
        }

      },
    );
  }

}
