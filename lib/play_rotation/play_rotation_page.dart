import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:drawing_interface_learning/music_play/player_song_page.dart';
import 'package:drawing_interface_learning/play_rotation/model/Particle.dart';
import 'package:drawing_interface_learning/play_rotation/run_particle_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class PlayRotationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PlayRotationPage();
  }
}
final GlobalKey<PlayerState> musicPlayerKey = new GlobalKey();
const String mp3Url = 'http://lc-pdocKLdh.cn-n1.lcfile.com/174318a0265d4393f535/%E5%AF%BB%E6%89%BE%2B%E5%BF%BD%E7%84%B6%2B%E7%83%AD%E6%B2%B3.mp3';
const String testUrl = "https://luan.xyz/files/audio/nasa_on_a_mission.mp3";
class _PlayRotationPage extends State<PlayRotationPage> with TickerProviderStateMixin{
  AudioPlayer audioPlayer;

  var _start = DateTime.now().millisecondsSinceEpoch;
  AnimationController _controller;
  AnimationController _picController;
  bool flag = true;
  var _particles = <Particle>[];


  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    Random random = Random();
    Random randomY = Random();
    for (var i = 0; i < 1000; i++) {
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
    updateParticle();
    var cost = DateTime.now().millisecondsSinceEpoch;
    print("时间差:${cost - _start}ms,帧率:${1000 / (cost - _start)}");
    _start = cost;
  }

  void updateParticle(){
    _particles.forEach((particle) {
      particle.x += particle.speed*cos(particle.angle);
      particle.y += particle.speed*sin(particle.angle);
      particle.runDistance += particle.speed;
      //限定下边界
      if (particle.runDistance > 80) {
        particle.x = 220+100*cos(particle.angle);
        particle.y = 300+100*sin(particle.angle);
        particle.runDistance = 0 ;
      }
    });
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child:  Player(
                    color: Colors.white,
                    audioUrl: testUrl,
                    onCompleted: (){
                    },
                    onPlaying: (isPlaying){
                      if(isPlaying ){
                        showToast("播放");
                      }else{
                        showToast("暂停");
                      }
                    },
                    key: musicPlayerKey,
                    onError: (e){
                      Scaffold.of(context).showSnackBar(
                          new SnackBar(
                            content: new Text(e),
                          )
                      );
                    },
                    onNext: (){

                    },
                    onPrevious: (){

                    }
                ),
              ),
            ),


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
