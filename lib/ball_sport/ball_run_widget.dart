import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///E:/FlutterProgram/drawing_interface_learning/lib/utils/random_color.dart';

import 'ball.dart';

class RunBall extends StatefulWidget {
  @override
  _RunBallState createState() => _RunBallState();
}

class _RunBallState extends State<RunBall> with SingleTickerProviderStateMixin {
  AnimationController controller;
  var _balls = <Ball>[];
  var _area = Rect.fromLTRB(0 + 40.0, 0 + 200.0, 300 + 40.0, 200 + 300.0);
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: AnimatedBuilder(
            animation: controller,
            builder:(context,Widget child){
              _render();
               return CustomPaint(
                painter: RunBallView(_balls, _area),
              );
            },
        ),
      ),
      onTap: () {
        if(flag ==true){
          controller.forward();
          flag = false;
        }else{
          flag = true;
          controller.stop();
        }
        //执行动画
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Random random = Random();

    for (var i = 0; i < 30; i++) {
      _balls.add(Ball(
          color: randomRGB(),
          r: 5 + 4 * random.nextDouble(),
          vX: 3*random.nextDouble()*pow(-1, random.nextInt(20)),
          vY:  3*random.nextDouble()*pow(-1, random.nextInt(20)),
          aY: 0.1,
          x: 200,
          y: 300));
    }

    controller =
        AnimationController(duration: Duration(days: 999 * 365), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose(); // 资源释放
  }

  //核心渲染方法
  _render() {
    for (var i = 0; i < _balls.length; i++) {
      updateBall(i);
    }
  }

  void updateBall(int i) {
    var ball = _balls[i];
    ball.x += ball.vX;
    ball.y += ball.vY;
    ball.vX += ball.aX;
    ball.vY += ball.aY;

    //限定下边界
    if (ball.y > _area.bottom - ball.r) {
      ball.y = _area.bottom - ball.r;
      ball.vY = -ball.vY;
    }
    //限定上边界
    if (ball.y < _area.top + ball.r) {
      ball.y = _area.top + ball.r;
      ball.vY = -ball.vY;
    }

    //限定左边界
    if (ball.x < _area.left + ball.r) {
      ball.x = _area.left + ball.r;
      ball.vX = -ball.vX;
    }

    //限定右边界
    if (ball.x > _area.right - ball.r) {
      ball.x = _area.right - ball.r;
      ball.vX = -ball.vX;
    }
  }

  f(x) {
    var y = 5 * sin(4 * x); //函数表达式
    return y;
  }
}

class RunBallView extends CustomPainter {
  List<Ball> _balls; //小球集合
  Rect _area; //运动区域
  Paint mPaint; //主画笔
  Paint bgPaint; //背景画笔
  Paint linePaint; //主画笔

  RunBallView(this._balls, this._area) {
    mPaint = new Paint();
    bgPaint = new Paint()..color = Color.fromARGB(148, 198, 246, 248);
    linePaint = new Paint()
      ..color = Color.fromARGB(148, 198, 246, 248)
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    canvas.drawRect(_area, bgPaint);
//    canvas.drawPath(gridPath(20, Size(1280, 1980)), linePaint); //使用path绘制
    _balls.forEach((ball) {
      _drawBall(canvas, ball);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///使用[canvas] 绘制某个[ball]
  void _drawBall(Canvas canvas, Ball ball) {
    canvas.drawCircle(
        Offset(ball.x, ball.y), ball.r, mPaint..color = ball.color);

  }
}

