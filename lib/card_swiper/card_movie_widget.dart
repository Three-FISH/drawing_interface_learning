import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:drawing_interface_learning/card_swiper/MovieData.dart';
import 'package:drawing_interface_learning/card_swiper/detail_screen_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardMovieWidget extends StatelessWidget{
  final Movie movie;
  const CardMovieWidget(
  {Key key,this.movie}
      ):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child:OpenContainer(
        closedColor: Colors.transparent,
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context,action) =>buildMovieCard(context),
        openBuilder: (context,action) => DetailsScreenWidget(movie:movie),
      ) ,
    );
  }
  Column buildMovieCard(BuildContext context){
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [BoxShadow(
                offset: Offset(0,4),
                blurRadius: 4,
                color: Colors.black26,
              )],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(movie.poster),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            movie.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
          ),
        ),
      ],
    );
  }
}