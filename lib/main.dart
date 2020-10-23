import 'dart:io';

import 'package:drawing_interface_learning/ball_sport/ball_run_widget.dart';
import 'package:drawing_interface_learning/play_rotation/play_rotation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'card_swiper/card_swiper_page.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: new MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home: MyHomePage(title: '目录'),
    )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,style: TextStyle(fontSize: 20),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisSize: MainAxisSize.min,
       children: <Widget>[
         InkWell(
           child: Container(
             width: double.infinity,
             padding: EdgeInsets.all(10),
             child: Text("1、网易云音乐“宇宙尘埃”",style: TextStyle(fontSize: 16),),
           ),
           onTap: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context){
               return PlayRotationPage();
             }));
           },
         ),
         InkWell(
           child: Container(
             width: double.infinity,
             padding: EdgeInsets.all( 10),
             child: Text("2、小球随机跳动",style: TextStyle(fontSize: 16),),
           ),
           onTap: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context){
               return RunBall();
             }));
           },
         ),
         InkWell(
           child: Container(
             width: double.infinity,
             padding: EdgeInsets.all( 10),
             child: Text("3、UI-Swiper绘制",style: TextStyle(fontSize: 16),),
           ),
           onTap: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context){
               return CardSWiperPage();
             }));
           },
         ),
       ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
