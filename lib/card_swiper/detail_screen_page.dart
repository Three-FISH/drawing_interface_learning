import 'package:drawing_interface_learning/card_swiper/MovieData.dart';
import 'package:drawing_interface_learning/card_swiper/top_backdrop_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsScreenWidget extends StatelessWidget{
  final Movie movie;
  const DetailsScreenWidget(
  {Key key,this.movie}):super(key:key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TopBackdropWidget(size: size, movie: movie),
            SizedBox(height: 10,),


          ],
        ),
      )
    );
  }
}