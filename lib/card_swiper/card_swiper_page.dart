import 'dart:ui';

import 'package:drawing_interface_learning/card_swiper/card_scroll_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'CardData.dart';

class CardSWiperPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CardSwiperPage();
  }
}
class _CardSwiperPage extends State<CardSWiperPage>{
  var currentPage = images.length - 1.0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length-1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1b1e44),
            Color(0xFF2d3447),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )
      ),
      child: Scaffold(
        backgroundColor:  Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 14, 12, 8),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: (){

                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: (){
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget> [
                    Text("今日推荐",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight:FontWeight.w500,
                      letterSpacing: 2,
                    ),),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: (){

                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20,top: 10),
                child: Row(
                  children:<Widget> [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFff6e6e),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                        child: Text("Animated",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text("25+ stories",
                    style: TextStyle(
                      color: Colors.blue
                    ),)
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                 CardScrollWidget(currentPage),
                 Positioned.fill(
                    child: PageView.builder(
                      itemCount: images.length,
                      reverse: true,
                      controller: controller,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            showToast("点击了$index");
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}